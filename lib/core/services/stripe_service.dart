import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<void> makePayment({
    required String clientSecret,
    required String amount,
    String currency = 'CAD',
  }) async {
    await _initPaymentSheet(
      clientSecret: clientSecret,
      amount: amount,
      currency: currency,
    );
    await _presentPaymentSheet();
  }

  Future<void> _initPaymentSheet({
    required String clientSecret,
    required String amount,
    required String currency,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Gatsby Rideshare',
        style: ThemeMode.light,
        googlePay: PaymentSheetGooglePay(
          merchantCountryCode: 'CA',
          currencyCode: currency,
          testEnv: false,
        ),
        applePay: const PaymentSheetApplePay(
          merchantCountryCode: 'CA',
        ),
      ),
    );
    log('PaymentSheet initialized', name: 'STRIPE');
  }

  Future<void> _presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
    log('PaymentSheet completed', name: 'STRIPE');
  }
}
