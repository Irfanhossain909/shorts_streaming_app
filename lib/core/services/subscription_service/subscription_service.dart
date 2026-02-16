import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:testemu/core/utils/app_utils.dart';

class SubscriptionService {
  SubscriptionService._();
  static final SubscriptionService _instance = SubscriptionService._();
  static SubscriptionService get instance => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool _isAvailable = false;
  bool _isSubscribed = false;

  List<ProductDetails> _products = [];

  bool get isSubscribed => _isSubscribed;
  List<ProductDetails> get products => _products;

  /// ===============================
  /// INIT (Call Once in main or splash)
  /// ===============================
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

      /// Listen purchase updates
      _purchaseSubscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () => _purchaseSubscription?.cancel(),
        onError: (error) {
          debugPrint("🔥 Stream Error: $error");
        },
      );

      /// Load products
      await _loadProducts(productIds);

      /// Restore previous purchases
      await restorePurchases();
    } catch (e) {
      debugPrint("🔥 Init Exception: $e");
    }
  }

  /// ===============================
  /// LOAD PRODUCTS
  /// ===============================
  Future<void> _loadProducts(List<String> productIds) async {
    final response = await _iap.queryProductDetails(productIds.toSet());

    if (response.error != null) {
      debugPrint("❌ Product Fetch Error: ${response.error}");
      return;
    }

    if (response.productDetails.isEmpty) {
      Utils.errorSnackBar(
        Get.context!,
        "No products found",
        "Please try again later",
      );
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
  }

  /// ===============================
  /// BUY SUBSCRIPTION
  /// ===============================
  Future<void> buySubscription(String productId) async {
    try {
      if (_products.isEmpty) {
        debugPrint("❌ Products not loaded");
        return;
      }

      final product = _products.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception("Product not found"),
      );

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      bool success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      debugPrint("🚀 Purchase flow started: $success");
    } catch (e) {
      debugPrint("🔥 Buy Exception: $e");
    }
  }

  // Future<void> buySubscription(String productId) async {
  //   try {
  //     final product = _products.firstWhere((p) => p.id == productId);

  //     final PurchaseParam purchaseParam = PurchaseParam(
  //       productDetails: product,
  //     );

  //     /// For subscription (Android + iOS)
  //     await _iap.buyNonConsumable(purchaseParam: purchaseParam);

  //     debugPrint("🚀 Purchase flow started");
  //   } catch (e) {
  //     debugPrint("🔥 Buy Exception: $e");
  //   }
  // }

  /// ===============================
  /// RESTORE PURCHASES
  /// ===============================
  Future<void> restorePurchases() async {
    try {
      debugPrint("🔄 Restoring purchases...");
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint("🔥 Restore Exception: $e");
    }
  }

  /// ===============================
  /// HANDLE PURCHASE UPDATES
  /// ===============================
  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          debugPrint("⏳ Purchase Pending...");
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          bool valid = await _verifyPurchase(purchase);

          if (valid) {
            _deliverProduct(purchase);
          } else {
            debugPrint("❌ Invalid purchase");
          }
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
  }

  /// ===============================
  /// VERIFY PURCHASE
  /// ===============================
  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    debugPrint("🔍 Verifying purchase...");

    /// 🔥 Production:
    /// Send purchase.verificationData.serverVerificationData
    /// to backend for validation

    return true; // temporary
  }

  /// ===============================
  /// DELIVER PRODUCT
  /// ===============================
  void _deliverProduct(PurchaseDetails purchase) {
    debugPrint("🎉 Subscription Activated: ${purchase.productID}");

    _isSubscribed = true;

    /// TODO:
    /// Save subscription status to local storage
    /// Unlock premium features
  }

  /// ===============================
  /// CANCEL STREAM
  /// ===============================
  void dispose() {
    _purchaseSubscription?.cancel();
  }
}
