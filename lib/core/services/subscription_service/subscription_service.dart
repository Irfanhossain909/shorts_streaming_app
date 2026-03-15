import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  SubscriptionService._();
  static final SubscriptionService instance = SubscriptionService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool _isSubscribed = false;

  List<ProductDetails> _products = [];

  /// callbacks
  Function(PurchaseDetails)? onPurchaseSuccess;
  Function(List<PurchaseDetails>)? onPurchasesRestored;

  bool get isSubscribed => _isSubscribed;
  List<ProductDetails> get products => _products;

  /// ================================
  /// INIT
  /// ================================
  Future<void> init({required List<String> productIds}) async {
    try {
      if (!(Platform.isAndroid || Platform.isIOS)) {
        debugPrint("❌ Platform not supported");
        return;
      }

      _isAvailable = await _iap.isAvailable();

      if (!_isAvailable) {
        debugPrint("❌ IAP not available");
        return;
      }

      debugPrint("✅ IAP Available");

      /// listen purchase stream
      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () => _subscription?.cancel(),
        onError: (error) {
          debugPrint("🔥 Purchase Stream Error: $error");
        },
      );

      /// load products
      await _loadProducts(productIds);

      /// restore previous purchase
      await restorePurchases();
    } catch (e) {
      debugPrint("🔥 Init Error: $e");
    }
  }

  /// ================================
  /// LOAD PRODUCTS
  /// ================================
  Future<void> _loadProducts(List<String> productIds) async {
    try {
      final response = await _iap.queryProductDetails(productIds.toSet());

      if (response.error != null) {
        debugPrint("❌ Product Fetch Error: ${response.error}");
        return;
      }

      if (response.productDetails.isEmpty) {
        debugPrint("⚠️ No products found");
        return;
      }

      _products = response.productDetails;

      for (var product in _products) {
        debugPrint("------ PRODUCT ------");
        debugPrint("ID: ${product.id}");
        debugPrint("Title: ${product.title}");
        debugPrint("Price: ${product.price}");
        debugPrint("---------------------");
      }
    } catch (e) {
      debugPrint("🔥 Product Load Error: $e");
    }
  }

  /// ================================
  /// BUY SUBSCRIPTION
  /// ================================
  Future<void> buySubscription(String productId) async {
    try {
      final product = _products.firstWhere((p) => p.id == productId);

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      /// subscription purchase
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      debugPrint("🚀 Purchase flow started");
    } catch (e) {
      debugPrint("🔥 Buy Error: $e");
    }
  }

  /// ================================
  /// RESTORE PURCHASES
  /// ================================
  Future<void> restorePurchases() async {
    try {
      debugPrint("🔄 Restoring purchases...");
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint("🔥 Restore Error: $e");
    }
  }

  /// ================================
  /// HANDLE PURCHASE UPDATES
  /// ================================
  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    List<PurchaseDetails> restoredPurchases = [];

    for (final purchase in purchases) {
      debugPrint("📦 Purchase Update: ${purchase.status}");

      switch (purchase.status) {
        case PurchaseStatus.pending:
          debugPrint("⏳ Purchase Pending...");
          break;

        case PurchaseStatus.purchased:
          await _handleSuccessfulPurchase(purchase);
          break;

        case PurchaseStatus.restored:
          await _handleRestoredPurchase(purchase);
          restoredPurchases.add(purchase);
          break;

        case PurchaseStatus.error:
          debugPrint("❌ Purchase Error: ${purchase.error}");
          break;

        case PurchaseStatus.canceled:
          debugPrint("⚠️ Purchase Cancelled");
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }

    if (restoredPurchases.isNotEmpty) {
      onPurchasesRestored?.call(restoredPurchases);
    }
  }

  /// ================================
  /// HANDLE PURCHASED
  /// ================================
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    bool valid = await _verifyPurchase(purchase);

    if (!valid) {
      debugPrint("❌ Invalid purchase");
      return;
    }

    await _verifyPurchaseWithAPI(purchase);

    _deliverProduct(purchase);
  }

  /// ================================
  /// HANDLE RESTORED
  /// ================================
  Future<void> _handleRestoredPurchase(PurchaseDetails purchase) async {
    bool valid = await _verifyPurchase(purchase);

    if (!valid) {
      debugPrint("❌ Invalid restored purchase");
      return;
    }

    await _verifyPurchaseWithAPI(purchase);

    _deliverProduct(purchase);

    debugPrint("🔄 Restored subscription: ${purchase.productID}");
  }

  /// ================================
  /// VERIFY PURCHASE (LOCAL)
  /// ================================
  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    debugPrint("🔍 Local verification...");

    /// production: server side validation required

    return true;
  }

  /// ================================
  /// VERIFY PURCHASE WITH API
  /// ================================
  Future<void> _verifyPurchaseWithAPI(PurchaseDetails purchase) async {
    try {
      final receipt = purchase.verificationData.serverVerificationData;

      debugPrint("📄 RECEIPT:");
      debugPrint(receipt);

      /// send to backend

      /*
      await ApiService.verifySubscription(
        receipt: receipt,
        productId: purchase.productID,
        platform: Platform.isIOS ? "apple" : "google",
      );
      */
    } catch (e) {
      debugPrint("🔥 API Verification Error: $e");
    }
  }

  /// ================================
  /// DELIVER PRODUCT
  /// ================================
  void _deliverProduct(PurchaseDetails purchase) {
    debugPrint("🎉 Subscription Activated: ${purchase.productID}");

    _isSubscribed = true;

    if (onPurchaseSuccess != null) {
      debugPrint("📤 Calling onPurchaseSuccess (controller will call verify API)");
      onPurchaseSuccess!.call(purchase);
    } else {
      debugPrint("⚠️ onPurchaseSuccess is null - verify API will NOT be called. Set listener in controller onInit.");
    }

    /// unlock premium features here
  }

  /// ================================
  /// DISPOSE
  /// ================================
  void dispose() {
    _subscription?.cancel();
  }
}


// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:testemu/core/utils/app_utils.dart';
// import 'package:testemu/core/utils/log/app_print.dart';

// class SubscriptionService {
//   SubscriptionService._();
//   static final SubscriptionService _instance = SubscriptionService._();
//   static SubscriptionService get instance => _instance;

//   final InAppPurchase _iap = InAppPurchase.instance;

//   StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

//   bool _isAvailable = false;
//   bool _isSubscribed = false;

//   List<ProductDetails> _products = [];

//   /// Callback to notify when purchase succeeds
//   Function(PurchaseDetails)? onPurchaseSuccess;
  
//   /// Callback to notify when purchases are restored
//   Function(List<PurchaseDetails>)? onPurchasesRestored;

//   bool get isSubscribed => _isSubscribed;
//   List<ProductDetails> get products => _products;

//   /// ===============================
//   /// INIT (Call Once in main or splash)
//   /// ===============================
//   Future<void> init({required List<String> productIds}) async {
//     try {
//       if (!(Platform.isAndroid || Platform.isIOS)) {
//         debugPrint("❌ Platform not supported");
//         return;
//       }

//       _isAvailable = await _iap.isAvailable();

//       if (!_isAvailable) {
//         debugPrint("❌ IAP not available");
//         return;
//       }

//       debugPrint("✅ IAP Available");

//       /// Listen purchase updates
//       _purchaseSubscription = _iap.purchaseStream.listen(
//         _handlePurchaseUpdates,
//         onDone: () => _purchaseSubscription?.cancel(),
//         onError: (error) {
//           debugPrint("🔥 Stream Error: $error");
//         },
//       );

//       /// Load products
//       await _loadProducts(productIds);

//       /// Restore previous purchases
//       await restorePurchases();
//     } catch (e) {
//       debugPrint("🔥 Init Exception: $e");
//     }
//   }

//   /// ===============================
//   /// LOAD PRODUCTS
//   /// ===============================
//   Future<void> _loadProducts(List<String> productIds) async {
//     final response = await _iap.queryProductDetails(productIds.toSet());

//     if (response.error != null) {
//       debugPrint("❌ Product Fetch Error: ${response.error}");
//       return;
//     }

//     if (response.productDetails.isEmpty) {
//       Utils.errorSnackBar(
//         Get.context!,
//         "No products found",
//         "Please try again later",
//       );
//       debugPrint("⚠️ No products found");
//       return;
//     }

//     _products = response.productDetails;

//     for (var product in _products) {
//       debugPrint("------ PRODUCT ------");
//       debugPrint("ID: ${product.id}");
//       debugPrint("Title: ${product.title}");
//       debugPrint("Price: ${product.price}");
//       debugPrint("---------------------");

//       AppPrint.apiResponse("------ PRODUCT ------");
//       AppPrint.apiResponse("ID: ${product.id}");
//       AppPrint.apiResponse("Title: ${product.title}");
//       AppPrint.apiResponse("Price: ${product.price}");
//       AppPrint.apiResponse("---------------------");
//     }
//   }

//   /// ===============================
//   /// BUY SUBSCRIPTION
//   /// ===============================
//   // Future<void> buySubscription(String productId) async {
//   //   try {
//   //     if (_products.isEmpty) {
//   //       debugPrint("❌ Products not loaded");
//   //       return;
//   //     }

//   //     final product = _products.firstWhere(
//   //       (p) => p.id == productId,
//   //       orElse: () => throw Exception("Product not found"),
//   //     );

//   //     final PurchaseParam purchaseParam = PurchaseParam(
//   //       productDetails: product,
//   //     );

//   //     bool success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

//   //     debugPrint("🚀 Purchase flow started: $success");
//   //   } catch (e) {
//   //     debugPrint("🔥 Buy Exception: $e");
//   //   }
//   // }

//   Future<void> buySubscription(String productId) async {
//     try {
//       final product = _products.firstWhere((p) => p.id == productId);

//       final PurchaseParam purchaseParam = PurchaseParam(
//         productDetails: product,
//       );

//       /// For subscription (Android + iOS)
//       await _iap.buyNonConsumable(purchaseParam: purchaseParam);

//       debugPrint("🚀 Purchase flow started");
//     } catch (e) {
//       debugPrint("🔥 Buy Exception: $e");
//     }
//   }

//   /// ===============================
//   /// RESTORE PURCHASES
//   /// ===============================
//   Future<void> restorePurchases() async {
//     try {
//       debugPrint("🔄 Restoring purchases...");
//       await _iap.restorePurchases();
//     } catch (e) {
//       debugPrint("🔥 Restore Exception: $e");
//     }
//   }

//   /// ===============================
//   /// HANDLE PURCHASE UPDATES
//   /// ===============================
//   void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
//     List<PurchaseDetails> restoredPurchases = [];
    
//     for (final purchase in purchaseDetailsList) {
//       switch (purchase.status) {
//         case PurchaseStatus.pending:
//           debugPrint("⏳ Purchase Pending...");
//           break;

//         case PurchaseStatus.purchased:
//           bool valid = await _verifyPurchase(purchase);

//           if (valid) {
//             _deliverProduct(purchase);
//           } else {
//             debugPrint("❌ Invalid purchase");
//           }
//           break;

//         case PurchaseStatus.restored:
//           bool restoredValid = await _verifyPurchase(purchase);

//           if (restoredValid) {
//             _isSubscribed = true;
//             restoredPurchases.add(purchase);
//             debugPrint("🔄 Restored subscription: ${purchase.productID}");
//           } else {
//             debugPrint("❌ Invalid restored purchase");
//           }
//           break;

//         case PurchaseStatus.error:
//           debugPrint("❌ Purchase Error: ${purchase.error}");
//           break;

//         case PurchaseStatus.canceled:
//           debugPrint("⚠️ Purchase Cancelled");
//           break;
//       }

//       if (purchase.pendingCompletePurchase) {
//         await _iap.completePurchase(purchase);
//       }
//     }
    
//     // Notify about restored purchases
//     if (restoredPurchases.isNotEmpty) {
//       onPurchasesRestored?.call(restoredPurchases);
//     }
//   }

//   /// ===============================
//   /// VERIFY PURCHASE
//   /// ===============================
//   Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
//     debugPrint("🔍 Verifying purchase...");

//     /// 🔥 Production:
//     /// Send purchase.verificationData.serverVerificationData
//     /// to backend for validation

//     return true; // temporary
//   }

//   /// ===============================
//   /// DELIVER PRODUCT
//   /// ===============================
//   void _deliverProduct(PurchaseDetails purchase) {
//     debugPrint("🎉 Subscription Activated: ${purchase.productID}");

//     _isSubscribed = true;

//     /// Notify controller about successful purchase
//     onPurchaseSuccess?.call(purchase);

//     /// TODO:
//     /// Save subscription status to local storage
//     /// Unlock premium features
//   }

//   /// ===============================
//   /// CANCEL STREAM
//   /// ===============================
//   void dispose() {
//     _purchaseSubscription?.cancel();
//   }
// }
