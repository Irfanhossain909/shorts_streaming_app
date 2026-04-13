import 'dart:io';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:testemu/core/services/storage/storage_keys.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
import 'package:testemu/core/services/subscription_service/subscription_service.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/app_print.dart';
import 'package:testemu/features/profile/presentation/controller/profile_controller.dart';
import 'package:testemu/features/setting/data/model/subscription_model.dart';
import 'package:testemu/features/setting/repository/setting_repository.dart';
import 'package:testemu/features/setting/repository/subscription_repository.dart';

class SubscriptionController extends GetxController {
  SettingRepository settingRepository = SettingRepository.instance;
  SubscriptionRepository subscriptionRepository =
      SubscriptionRepository.instance;

  ProfileController profileController = Get.find<ProfileController>();

  /// Api status check here
  Status status = Status.completed;

  /// Subscriptions list here (filtered to only show available IAP products)
  List<SubscriptionData> subscriptions = [];

  /// Map of product ID to ProductDetails for easy lookup
  Map<String, ProductDetails> productDetailsMap = {};

  /// Set of subscribed product IDs
  Set<String> subscribedProductIds = {};

  @override
  void onInit() {
    getSubscriptionRepo();
    _setupPurchaseListener();

    super.onInit();
  }

  /// Initialize subscription service
  final SubscriptionService subscriptionService = SubscriptionService.instance;

  /// Setup purchase success listener
  void _setupPurchaseListener() {
    subscriptionService.onPurchaseSuccess = _handlePurchaseSuccess;
    subscriptionService.onPurchasesRestored = _handlePurchasesRestored;
  }

  /// Handle successful purchase
  void _handlePurchaseSuccess(PurchaseDetails purchase) async {
    // ✅ Print full purchase details
    AppPrint.apiResponse("===== PURCHASE SUCCESS =====");
    AppPrint.apiResponse("Product ID: ${purchase.productID}");
    AppPrint.apiResponse("Purchase ID / Order ID: ${purchase.purchaseID}");
    AppPrint.apiResponse("Transaction Date: ${purchase.transactionDate}");
    AppPrint.apiResponse(
      "Local Verification Data: ${purchase.verificationData.localVerificationData}",
    );
    AppPrint.apiResponse(
      "Server Verification Data: ${purchase.verificationData.serverVerificationData}",
    );
    AppPrint.apiResponse("Source: ${purchase.verificationData.source}");
    AppPrint.apiResponse(
      "Pending Complete: ${purchase.pendingCompletePurchase}",
    );
    AppPrint.apiResponse("Status: ${purchase.status}");
    AppPrint.apiResponse("============================");

    // Add to subscribed products
    subscribedProductIds.add(purchase.productID);

    // Do not verify restored purchases on screen load.
    // Requirement: if already purchased in store, only update UI state.
    if (purchase.status == PurchaseStatus.purchased) {
      await _verifyPurchaseWithAPI(purchase);
    } else {
      if (profileController.profileModel.value?.isSubscribed == false) {
        await _verifyPurchaseWithAPI(purchase);
      } else {
        appLog(
          "ℹ️ Skipping verify API for restored purchase: ${purchase.productID}",
          source: "Verify Purchase",
        );
      }
    }

    // Update UI
    update();
  }

  /// Handle restored purchases
  void _handlePurchasesRestored(List<PurchaseDetails> purchases) {
    appLog(
      "🔄 Restored ${purchases.length} purchases",
      source: "Purchase Restore",
    );

    for (final purchase in purchases) {
      subscribedProductIds.add(purchase.productID);
      appLog("✅ Restored: ${purchase.productID}", source: "Purchase Restore");
    }

    // Update UI
    update();
  }

  String getPurchaseToken(PurchaseDetails purchase) {
    if (Platform.isAndroid) {
      /// Android → purchaseToken
      return purchase.verificationData.serverVerificationData;
    } else if (Platform.isIOS) {
      /// iOS → receipt data
      return purchase.verificationData.serverVerificationData;
    }

    return "";
  }

  /// Verify purchase with backend API
  Future<void> _verifyPurchaseWithAPI(PurchaseDetails purchase) async {
    try {
      final provider = Platform.isIOS ? "apple" : "google";

      // Get token / receipt
      final purchaseToken = purchase.verificationData.serverVerificationData;

      if (purchaseToken.isEmpty) {
        appLog(
          "❌ Verify skipped: purchaseToken is empty for ${purchase.productID}",
          source: "Verify Purchase",
        );
        return;
      }

      appLog("🔍 Provider: $provider", source: "Verify Purchase");
      appLog("📦 Product ID: ${purchase.productID}", source: "Verify Purchase");
      appLog("🔑 Token: $purchaseToken", source: "Verify Purchase");

      /// Match subscription (Android / iOS both)
      double? price;

      for (final sub in subscriptions) {
        final googleId = sub.googleProductId;
        final appleId = sub.appleProductId;

        if ((googleId != null &&
                googleId.isNotEmpty &&
                googleId == purchase.productID) ||
            (appleId != null &&
                appleId.isNotEmpty &&
                appleId == purchase.productID)) {
          price = sub.price;
          break;
        }
      }

      final response = await subscriptionRepository.verifyPurchase(
        provider: provider,
        productId: purchase.productID,
        purchaseToken: purchaseToken, // iOS = receipt, Android = token
        packageName: "com.rubengalindo.creepyshorts",
        price: price,
      );

      if (response) {
        appLog(
          "✅ Purchase verified successfully with backend",
          source: "Verify Purchase",
        );

        // await LocalStorage.setBool(LocalStorageKeys.isSubscribed, true);

        // profileController.profileModel.value?.isSubscribed = true;
        profileController.getProfile();

        Get.back();
      } else {
        appLog(
          "❌ Purchase verification failed (API returned false)",
          source: "Verify Purchase",
        );
      }
    } catch (e) {
      appLog("❌ Error verifying purchase: $e", source: "Verify Purchase");
    }
  }

  /// Check if a product is subscribed.
  /// 1) Local IAP state (subscribedProductIds) — populate হয় purchase success + restore এ
  /// 2) Fallback: backend/profile isSubscribed — restore আগে বা অন্য device এ
  /// Restore হলে _handlePurchasesRestored → subscribedProductIds update → update() → UI refresh
  bool isProductSubscribed(String productId) {
    if (subscribedProductIds.contains(productId)) return true;
    if (profileController.profileModel.value?.isSubscribed == true) return true;
    return false;
  }

  /// Restore purchases manually (user taps Restore).
  /// SubscriptionService.restorePurchases() → IAP stream → _handlePurchasesRestored → UI update
  Future<void> restorePurchases() async {
    await subscriptionService.restorePurchases();
  }

  // /// Check if a product is subscribed
  // bool isProductSubscribed(String productId) {
  //   return subscribedProductIds.contains(productId);
  // }

  /// Load IAP products and filter subscriptions
  Future<void> loadSubscriptions({required List<String> productIds}) async {
    // Filter out empty product IDs
    final validProductIds = productIds.where((id) => id.isNotEmpty).toList();

    if (validProductIds.isEmpty) {
      appLog("❌ No valid product IDs found", source: "Load Subscriptions");
      subscriptions = [];
      status = Status.completed;
      update();
      return;
    }

    await subscriptionService.init(productIds: validProductIds);

    final products = subscriptionService.products;

    if (products.isEmpty) {
      appLog("❌ No IAP Products Found", source: "Load Subscriptions");
      subscriptions = [];
      status = Status.completed;
      update();
      return;
    }

    // Create a map of product ID to ProductDetails
    productDetailsMap = {for (var product in products) product.id: product};

    appLog(
      "🟢 Found ${products.length} IAP products",
      source: "Load Subscriptions",
    );
    for (var product in products) {
      appLog(
        "Product ID: ${product.id}, Title: ${product.title}, Price: ${product.price}",
        source: "Load Subscriptions",
      );
    }
  }

  void buySubscription(String productId) async {
    await subscriptionService.buySubscription(productId);
  }

  /// Get ProductDetails for a subscription
  ProductDetails? getProductDetails(SubscriptionData subscription) {
    final productId = Platform.isIOS
        ? subscription.googleProductId
        : subscription.googleProductId;

    if (productId == null || productId.isEmpty) {
      return null;
    }

    return productDetailsMap[productId];
  }

  /// Get subscription repository
  Future<void> getSubscriptionRepo() async {
    status = Status.loading;
    update();

    try {
      final response = await settingRepository.getSubscription();

      if (response.success == true) {
        final allSubscriptions = response.data ?? [];

        appLog(
          "📦 Fetched ${allSubscriptions.length} subscriptions from API",
          source: "Get Subscription",
        );

        // Extract product IDs based on platform
        final productIds = allSubscriptions
            .map((e) {
              if (Platform.isIOS) {
                return e.googleProductId ?? '';
              } else {
                return e.googleProductId ?? '';
              }
            })
            .where((id) => id.isNotEmpty)
            .toList();

        appLog(
          "🔍 Product IDs to fetch: $productIds",
          source: "Get Subscription",
        );

        // Load IAP products
        await loadSubscriptions(productIds: productIds);

        // Filter subscriptions to only include those with available IAP products
        subscriptions = allSubscriptions.where((subscription) {
          final productId = Platform.isIOS
              ? subscription.googleProductId
              : subscription.googleProductId;

          if (productId == null || productId.isEmpty) {
            return false;
          }

          return productDetailsMap.containsKey(productId);
        }).toList();

        appLog(
          "✅ Filtered to ${subscriptions.length} available subscriptions",
          source: "Get Subscription",
        );

        status = Status.completed;
        update();
      } else {
        status = Status.error;
        update();
      }
    } catch (e) {
      appLog("❌ Error fetching subscriptions: $e", source: "Get Subscription");
      status = Status.error;
      update();
    }
  }
}



// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:testemu/core/services/storage/storage_services.dart';
// import 'package:testemu/core/services/subscription_service/subscription_service.dart';
// import 'package:testemu/core/utils/enum/enum.dart';
// import 'package:testemu/core/utils/log/app_log.dart';
// import 'package:testemu/core/utils/log/app_print.dart';
// import 'package:testemu/features/profile/presentation/controller/profile_controller.dart';
// import 'package:testemu/features/setting/data/model/subscription_model.dart';
// import 'package:testemu/features/setting/repository/setting_repository.dart';
// import 'package:testemu/features/setting/repository/subscription_repository.dart';

// class SubscriptionController extends GetxController {
//   SettingRepository settingRepository = SettingRepository.instance;
//   SubscriptionRepository subscriptionRepository =
//       SubscriptionRepository.instance;

//   ProfileController profileController = Get.find<ProfileController>();
//   LocalStorage localStorage = LocalStorage();

//   Status status = Status.completed;
//   List<SubscriptionData> subscriptions = [];
//   Map<String, ProductDetails> productDetailsMap = {};
//   Set<String> subscribedProductIds = {};

//   final SubscriptionService subscriptionService = SubscriptionService.instance;

//   @override
//   void onInit() {
//     _setupPurchaseListener();
//     getSubscriptionRepo();
//     super.onInit();
//   }

//   void _setupPurchaseListener() {
//     subscriptionService.onPurchaseSuccess = _handlePurchaseSuccess;
//     subscriptionService.onPurchasesRestored = _handlePurchasesRestored;
//   }

//   /// Handle successful purchase
//   void _handlePurchaseSuccess(PurchaseDetails purchase) async {
//     AppPrint.apiResponse("===== PURCHASE SUCCESS =====");
//     AppPrint.apiResponse("Product ID: ${purchase.productID}");
//     AppPrint.apiResponse("Purchase ID / Order ID: ${purchase.purchaseID}");
//     AppPrint.apiResponse("Transaction Date: ${purchase.transactionDate}");
//     AppPrint.apiResponse(
//       "Local Verification Data: ${purchase.verificationData.localVerificationData}",
//     );
//     AppPrint.apiResponse(
//       "Server Verification Data: ${purchase.verificationData.serverVerificationData}",
//     );
//     AppPrint.apiResponse("Source: ${purchase.verificationData.source}");
//     AppPrint.apiResponse(
//       "Pending Complete: ${purchase.pendingCompletePurchase}",
//     );
//     AppPrint.apiResponse("Status: ${purchase.status}");
//     AppPrint.apiResponse("============================");

//     // ✅ Restored purchase হলে localStorage check করো
//     if (purchase.status == PurchaseStatus.restored) {
//       final isSubscribed = LocalStorage.isSubscribed;

//       if (!isSubscribed) {
//         appLog(
//           "⚠️ Ignoring restored purchase — user not subscribed: ${purchase.productID}",
//           source: "Purchase Success",
//         );
//         return;
//       }

//       subscribedProductIds.add(purchase.productID);
//       update();
//       return;
//     }

//     // ✅ শুধু নতুন purchase এর জন্য verify
//     if (purchase.status == PurchaseStatus.purchased) {
//       subscribedProductIds.add(purchase.productID);
//       await _verifyPurchaseWithAPI(purchase);
//       update();
//     }
//   }

//   /// Handle restored purchases
//   void _handlePurchasesRestored(List<PurchaseDetails> purchases) {
//     appLog(
//       "🔄 Restored ${purchases.length} purchases",
//       source: "Purchase Restore",
//     );

//     final isSubscribed = LocalStorage.isSubscribed;

//     if (!isSubscribed) {
//       appLog(
//         "⚠️ User not subscribed — ignoring all restored purchases",
//         source: "Purchase Restore",
//       );
//       return;
//     }

//     for (final purchase in purchases) {
//       subscribedProductIds.add(purchase.productID);
//       appLog("✅ Restored: ${purchase.productID}", source: "Purchase Restore");
//     }

//     update();
//   }

//   String getPurchaseToken(PurchaseDetails purchase) {
//     if (Platform.isAndroid) {
//       return purchase.verificationData.serverVerificationData;
//     } else if (Platform.isIOS) {
//       return purchase.verificationData.serverVerificationData;
//     }
//     return "";
//   }

//   /// Verify purchase with backend API
//   Future<void> _verifyPurchaseWithAPI(PurchaseDetails purchase) async {
//     try {
//       final provider = Platform.isIOS ? "apple" : "google";
//       final purchaseToken = purchase.verificationData.serverVerificationData;

//       if (purchaseToken.isEmpty) {
//         appLog(
//           "❌ Verify skipped: purchaseToken is empty for ${purchase.productID}",
//           source: "Verify Purchase",
//         );
//         return;
//       }

//       appLog("🔍 Provider: $provider", source: "Verify Purchase");
//       appLog("📦 Product ID: ${purchase.productID}", source: "Verify Purchase");
//       appLog("🔑 Token: $purchaseToken", source: "Verify Purchase");

//       double? price;

//       // ✅ Provider + store SKU — একই productID দুই স্টোরে থাকলে সঠিক row
//       for (final sub in subscriptions) {
//         if (!sub.matchesRunningAppStore) continue;
//         final platformId = sub.storeProductId;
//         if (platformId != null &&
//             platformId.isNotEmpty &&
//             platformId == purchase.productID) {
//           price = sub.price;
//           break;
//         }
//       }

//       final response = await subscriptionRepository.verifyPurchase(
//         provider: provider,
//         productId: purchase.productID,
//         purchaseToken: purchaseToken,
//         packageName: "com.rubengalindo.creepyshorts",
//         price: price,
//       );

//       if (response) {
//         appLog(
//           "✅ Purchase verified successfully with backend",
//           source: "Verify Purchase",
//         );

//         profileController.getProfile();
//         Get.back();
//       } else {
//         appLog(
//           "❌ Purchase verification failed (API returned false)",
//           source: "Verify Purchase",
//         );
//       }
//     } catch (e) {
//       appLog("❌ Error verifying purchase: $e", source: "Verify Purchase");
//     }
//   }

//   /// ✅ localStorage false হলে সবসময় false
//   bool isProductSubscribed(String productId) {
//     final isSubscribed = LocalStorage.isSubscribed;
//     if (!isSubscribed) return false;
//     if (subscribedProductIds.contains(productId)) return true;
//     if (profileController.profileModel.value?.isSubscribed == true) return true;
//     return false;
//   }

//   /// Restore purchases manually (user taps Restore button)
//   Future<void> restorePurchases() async {
//     await subscriptionService.restorePurchases();
//   }

//   /// Load IAP products
//   Future<void> loadSubscriptions({required List<String> productIds}) async {
//     final validProductIds = productIds.where((id) => id.isNotEmpty).toList();

//     if (validProductIds.isEmpty) {
//       appLog("❌ No valid product IDs found", source: "Load Subscriptions");
//       status = Status.completed;
//       update();
//       return;
//     }

//     final isSubscribed = LocalStorage.isSubscribed;

//     if (!isSubscribed) {
//       appLog(
//         "⚠️ User not subscribed — skipping IAP init to prevent unwanted restore",
//         source: "Load Subscriptions",
//       );
//       return;
//     }

//     await subscriptionService.init(productIds: validProductIds);

//     final products = subscriptionService.products;

//     if (products.isEmpty) {
//       appLog("❌ No IAP Products Found", source: "Load Subscriptions");
//       status = Status.completed;
//       update();
//       return;
//     }

//     productDetailsMap = {for (var product in products) product.id: product};

//     appLog(
//       "🟢 Found ${products.length} IAP products",
//       source: "Load Subscriptions",
//     );
//     for (var product in products) {
//       appLog(
//         "Product ID: ${product.id}, Title: ${product.title}, Price: ${product.price}",
//         source: "Load Subscriptions",
//       );
//     }
//   }

//   /// ✅ Buy করার আগে আলাদাভাবে IAP init করো
//   void buySubscription(String productId) async {
//     await subscriptionService.init(productIds: [productId]);
//     await subscriptionService.buySubscription(productId);
//   }

//   /// ✅ Platform অনুযায়ী সঠিক ProductDetails নাও
//   ProductDetails? getProductDetails(SubscriptionData subscription) {
//     final productId = subscription.storeProductId;
//     if (productId == null || productId.isEmpty) return null;
//     return productDetailsMap[productId];
//   }

//   /// Get subscription from API
//   Future<void> getSubscriptionRepo() async {
//     status = Status.loading;
//     update();

//     try {
//       final response = await settingRepository.getSubscription();

//       if (response.success == true) {
//         final allSubscriptions = response.data ?? [];

//         appLog(
//           "📦 Fetched ${allSubscriptions.length} subscriptions from API",
//           source: "Get Subscription",
//         );

//         // ✅ Provider + store ID — same SKU string on Google & Apple এ দুটো row আলাদা রাখে
//         final forPlatform = allSubscriptions
//             .where((e) => e.matchesRunningAppStore)
//             .toList();

//         appLog(
//           "🎯 After provider filter (${Platform.isIOS ? 'Apple' : 'Google'}): ${forPlatform.length}",
//           source: "Get Subscription",
//         );

//         // ✅ শুধু এই স্টোরের SKU দিয়ে IAP query
//         final productIds = forPlatform
//             .map((e) => e.storeProductId ?? '')
//             .where((id) => id.isNotEmpty)
//             .toSet()
//             .toList();

//         appLog(
//           "🔍 Product IDs to fetch (${Platform.isIOS ? 'iOS' : 'Android'}): $productIds",
//           source: "Get Subscription",
//         );

//         await loadSubscriptions(productIds: productIds);

//         // ✅ productDetailsMap এ data আছে মানে isSubscribed true ছিল
//         if (productDetailsMap.isNotEmpty) {
//           subscriptions = forPlatform.where((subscription) {
//             final productId = subscription.storeProductId;
//             if (productId == null || productId.isEmpty) return false;
//             return productDetailsMap.containsKey(productId);
//           }).toList();
//         } else {
//           // ✅ isSubscribed false — শুধু এই প্ল্যাটফর্মের প্ল্যান
//           subscriptions = forPlatform;
//         }

//         appLog(
//           "✅ Final subscriptions count: ${subscriptions.length}",
//           source: "Get Subscription",
//         );

//         status = Status.completed;
//         update();
//       } else {
//         status = Status.error;
//         update();
//       }
//     } catch (e) {
//       appLog("❌ Error: $e", source: "Get Subscription");
//       status = Status.error;
//       update();
//     }
//   }
// }




// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:testemu/core/services/storage/storage_services.dart';
// import 'package:testemu/core/services/subscription_service/subscription_service.dart';
// import 'package:testemu/core/utils/enum/enum.dart';
// import 'package:testemu/core/utils/log/app_log.dart';
// import 'package:testemu/core/utils/log/app_print.dart';
// import 'package:testemu/features/profile/presentation/controller/profile_controller.dart';
// import 'package:testemu/features/setting/data/model/subscription_model.dart';
// import 'package:testemu/features/setting/repository/setting_repository.dart';
// import 'package:testemu/features/setting/repository/subscription_repository.dart';

// class SubscriptionController extends GetxController {
//   SettingRepository settingRepository = SettingRepository.instance;
//   SubscriptionRepository subscriptionRepository =
//       SubscriptionRepository.instance;

//   ProfileController profileController = Get.find<ProfileController>();
//   LocalStorage localStorage = LocalStorage();

//   Status status = Status.completed;
//   List<SubscriptionData> subscriptions = [];
//   Map<String, ProductDetails> productDetailsMap = {};
//   Set<String> subscribedProductIds = {};

//   final SubscriptionService subscriptionService = SubscriptionService.instance;

//   @override
//   void onInit() {
//     _setupPurchaseListener();
//     getSubscriptionRepo();
//     super.onInit();
//   }

//   void _setupPurchaseListener() {
//     subscriptionService.onPurchaseSuccess = _handlePurchaseSuccess;
//     subscriptionService.onPurchasesRestored = _handlePurchasesRestored;
//   }

//   /// Handle successful purchase
//   void _handlePurchaseSuccess(PurchaseDetails purchase) async {
//     AppPrint.apiResponse("===== PURCHASE SUCCESS =====");
//     AppPrint.apiResponse("Product ID: ${purchase.productID}");
//     AppPrint.apiResponse("Purchase ID / Order ID: ${purchase.purchaseID}");
//     AppPrint.apiResponse("Transaction Date: ${purchase.transactionDate}");
//     AppPrint.apiResponse(
//       "Local Verification Data: ${purchase.verificationData.localVerificationData}",
//     );
//     AppPrint.apiResponse(
//       "Server Verification Data: ${purchase.verificationData.serverVerificationData}",
//     );
//     AppPrint.apiResponse("Source: ${purchase.verificationData.source}");
//     AppPrint.apiResponse(
//       "Pending Complete: ${purchase.pendingCompletePurchase}",
//     );
//     AppPrint.apiResponse("Status: ${purchase.status}");
//     AppPrint.apiResponse("============================");

//     // ✅ Restored purchase হলে localStorage check করো
//     if (purchase.status == PurchaseStatus.restored) {
//       final isSubscribed = LocalStorage.isSubscribed;

//       if (!isSubscribed) {
//         appLog(
//           "⚠️ Ignoring restored purchase — user not subscribed: ${purchase.productID}",
//           source: "Purchase Success",
//         );
//         return;
//       }

//       subscribedProductIds.add(purchase.productID);
//       update();
//       return;
//     }

//     // ✅ শুধু নতুন purchase এর জন্য verify
//     if (purchase.status == PurchaseStatus.purchased) {
//       subscribedProductIds.add(purchase.productID);
//       await _verifyPurchaseWithAPI(purchase);
//       update();
//     }
//   }

//   /// Handle restored purchases
//   void _handlePurchasesRestored(List<PurchaseDetails> purchases) {
//     appLog(
//       "🔄 Restored ${purchases.length} purchases",
//       source: "Purchase Restore",
//     );

//     // ✅ localStorage false হলে restore সম্পূর্ণ ignore
//     final isSubscribed = LocalStorage.isSubscribed;

//     if (!isSubscribed) {
//       appLog(
//         "⚠️ User not subscribed — ignoring all restored purchases",
//         source: "Purchase Restore",
//       );
//       return;
//     }

//     for (final purchase in purchases) {
//       subscribedProductIds.add(purchase.productID);
//       appLog("✅ Restored: ${purchase.productID}", source: "Purchase Restore");
//     }

//     update();
//   }

//   String getPurchaseToken(PurchaseDetails purchase) {
//     if (Platform.isAndroid) {
//       return purchase.verificationData.serverVerificationData;
//     } else if (Platform.isIOS) {
//       return purchase.verificationData.serverVerificationData;
//     }
//     return "";
//   }

//   /// Verify purchase with backend API
//   Future<void> _verifyPurchaseWithAPI(PurchaseDetails purchase) async {
//     try {
//       final provider = Platform.isIOS ? "apple" : "google";
//       final purchaseToken = purchase.verificationData.serverVerificationData;

//       if (purchaseToken.isEmpty) {
//         appLog(
//           "❌ Verify skipped: purchaseToken is empty for ${purchase.productID}",
//           source: "Verify Purchase",
//         );
//         return;
//       }

//       appLog("🔍 Provider: $provider", source: "Verify Purchase");
//       appLog("📦 Product ID: ${purchase.productID}", source: "Verify Purchase");
//       appLog("🔑 Token: $purchaseToken", source: "Verify Purchase");

//       double? price;

//       for (final sub in subscriptions) {
//         final googleId = sub.googleProductId;
//         final appleId = sub.appleProductId;

//         if ((googleId != null &&
//                 googleId.isNotEmpty &&
//                 googleId == purchase.productID) ||
//             (appleId != null &&
//                 appleId.isNotEmpty &&
//                 appleId == purchase.productID)) {
//           price = sub.price;
//           break;
//         }
//       }

//       final response = await subscriptionRepository.verifyPurchase(
//         provider: provider,
//         productId: purchase.productID,
//         purchaseToken: purchaseToken,
//         packageName: "com.rubengalindo.creepyshorts",
//         price: price,
//       );

//       if (response) {
//         appLog(
//           "✅ Purchase verified successfully with backend",
//           source: "Verify Purchase",
//         );

//         profileController.getProfile();
//         Get.back();
//       } else {
//         appLog(
//           "❌ Purchase verification failed (API returned false)",
//           source: "Verify Purchase",
//         );
//       }
//     } catch (e) {
//       appLog("❌ Error verifying purchase: $e", source: "Verify Purchase");
//     }
//   }

//   /// ✅ localStorage false হলে সবসময় false
//   bool isProductSubscribed(String productId) {
//     final isSubscribed = LocalStorage.isSubscribed;
//     if (!isSubscribed) return false;
//     if (subscribedProductIds.contains(productId)) return true;
//     if (profileController.profileModel.value?.isSubscribed == true) return true;
//     return false;
//   }

//   /// Restore purchases manually (user taps Restore button)
//   Future<void> restorePurchases() async {
//     await subscriptionService.restorePurchases();
//   }

//   /// Load IAP products
//   /// ✅ isSubscribed false হলে IAP init skip — restore এর সুযোগ নেই
//   /// ✅ isSubscribed true হলে normally init হবে
//   Future<void> loadSubscriptions({required List<String> productIds}) async {
//     final validProductIds = productIds.where((id) => id.isNotEmpty).toList();

//     if (validProductIds.isEmpty) {
//       appLog("❌ No valid product IDs found", source: "Load Subscriptions");
//       status = Status.completed;
//       update();
//       return;
//     }

//     final isSubscribed = LocalStorage.isSubscribed;

//     if (!isSubscribed) {
//       appLog(
//         "⚠️ User not subscribed — skipping IAP init to prevent unwanted restore",
//         source: "Load Subscriptions",
//       );
//       return;
//     }

//     await subscriptionService.init(productIds: validProductIds);

//     final products = subscriptionService.products;

//     if (products.isEmpty) {
//       appLog("❌ No IAP Products Found", source: "Load Subscriptions");
//       status = Status.completed;
//       update();
//       return;
//     }

//     productDetailsMap = {for (var product in products) product.id: product};

//     appLog(
//       "🟢 Found ${products.length} IAP products",
//       source: "Load Subscriptions",
//     );
//     for (var product in products) {
//       appLog(
//         "Product ID: ${product.id}, Title: ${product.title}, Price: ${product.price}",
//         source: "Load Subscriptions",
//       );
//     }
//   }

//   /// ✅ Buy করার আগে আলাদাভাবে IAP init করো
//   void buySubscription(String productId) async {
//     await subscriptionService.init(productIds: [productId]);
//     await subscriptionService.buySubscription(productId);
//   }

//   /// App Store / Play product id for this device (one id = one purchasable SKU).
//   String? _storeProductId(SubscriptionData s) {
//     if (Platform.isIOS) {
//       final apple = s.appleProductId;
//       if (apple != null && apple.isNotEmpty) return apple;
//       final google = s.googleProductId;
//       if (google != null && google.isNotEmpty) return google;
//       return null;
//     }
//     final google = s.googleProductId;
//     if (google != null && google.isNotEmpty) return google;
//     final apple = s.appleProductId;
//     if (apple != null && apple.isNotEmpty) return apple;
//     return null;
//   }

//   /// One row per store product id — backend often returns duplicates (same name,
//   /// different description) for the same SKU.
//   List<SubscriptionData> _dedupeByStoreProductId(
//     List<SubscriptionData> list,
//   ) {
//     final byId = <String, SubscriptionData>{};
//     for (final sub in list) {
//       final id = _storeProductId(sub);
//       if (id == null || id.isEmpty) continue;
//       byId.putIfAbsent(id, () => sub);
//     }
//     return byId.values.toList();
//   }

//   /// Get ProductDetails for a subscription
//   ProductDetails? getProductDetails(SubscriptionData subscription) {
//     final productId = _storeProductId(subscription);
//     if (productId == null || productId.isEmpty) return null;
//     return productDetailsMap[productId];
//   }

//   /// Get subscription from API
//   Future<void> getSubscriptionRepo() async {
//     status = Status.loading;
//     update();

//     try {
//       final response = await settingRepository.getSubscription();

//       if (response.success == true) {
//         final allSubscriptions = response.data ?? [];

//         appLog(
//           "📦 Fetched ${allSubscriptions.length} subscriptions from API",
//           source: "Get Subscription",
//         );

//         final productIds = allSubscriptions
//             .map(_storeProductId)
//             .whereType<String>()
//             .where((id) => id.isNotEmpty)
//             .toSet()
//             .toList();

//         appLog(
//           "🔍 Product IDs to fetch: $productIds",
//           source: "Get Subscription",
//         );

//         await loadSubscriptions(productIds: productIds);

//         final uniqueBySku = _dedupeByStoreProductId(allSubscriptions);

//         // ✅ productDetailsMap এ data আছে মানে isSubscribed true ছিল
//         // সেক্ষেত্রে filter করো
//         if (productDetailsMap.isNotEmpty) {
//           subscriptions = uniqueBySku.where((subscription) {
//             final productId = _storeProductId(subscription);
//             if (productId == null || productId.isEmpty) return false;
//             return productDetailsMap.containsKey(productId);
//           }).toList();
//         } else {
//           // ✅ isSubscribed false — productDetailsMap empty
//           // allSubscriptions সরাসরি দাও (buy করার জন্য list দেখাতে হবে)
//           subscriptions = uniqueBySku;
//         }

//         appLog(
//           "✅ Final subscriptions count: ${subscriptions.length}",
//           source: "Get Subscription",
//         );

//         status = Status.completed;
//         update();
//       } else {
//         status = Status.error;
//         update();
//       }
//     } catch (e) {
//       appLog("❌ Error: $e", source: "Get Subscription");
//       status = Status.error;
//       update();
//     }
//   }
// }


