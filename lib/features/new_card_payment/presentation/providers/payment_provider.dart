import 'dart:developer';

import 'package:GetsbyRideshare/features/new_card_payment/presentation/providers/add_card_state.dart';
import 'package:dio/dio.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/helper.dart';
import '../../domain/usecases/payment_usercases.dart';
import 'card_list_state.dart';

class PaymentProvider extends FormProvider {
  final PaymentCard paymentCard;

  // final DoOtpVerify doOtpVerify;

  // String otp = '';

  PaymentProvider({required this.paymentCard});

  late int selectedCardId = 0;

  String selectedCardNumber = '';
  String selectedCardExpiry = '';

  updateSelectedCard({cardNo, expiry}) {
    selectedCardNumber = cardNo;
    selectedCardExpiry = expiry;
    notifyListeners();
  }

  updateSelectedCardId(cardId) {
    selectedCardId = cardId;
    notifyListeners();
  }

  Stream<CardListState> fetchCardListData() async* {
    logMe("loading fetchCardListData",name: "GET CARDS");
    yield CardListLoading();
    final result = await paymentCard.call();
    yield* result.fold((failure) async* {
      logMe("error");
      logMe(failure);
      yield CardListFailure(failure: failure.message);
    }, (data) async* {
      logMe("loadedddd");

      log("Data.photo :===> ${data}");
      yield CardListSuccess(data: data);
    });
  }

  Stream<AddCardState> addCardDetails() async* {

    yield AddCardLoading();
    final formData = FormData.fromMap({
      'card_number': cardNumberController.text,
      'card_holder_name': accountHolderController.text,
      'card_type': "visa",
      'expiry_date': expiryController.text,
      // 'token': "111000"
    });
    log(formData.fields.toString());
    final result = await paymentCard.execute(formData);
    yield* result.fold((statusCode) async* {
      yield AddCardFailure(failure: statusCode.message);
    }, (result) async* {
      yield AddCardSuccess(data: result);
    });
  }

  Stream<AddCardState> deleteCard(int cardId) async* {
    yield DeleteCardLoading();
    final formData = FormData.fromMap({'id': cardId});
    log(formData.fields.toString());
    final result = await paymentCard.delete(formData);
    yield* result.fold((statusCode) async* {
      yield DeleteCardFailure(failure: statusCode.message);
    }, (result) async* {
      yield DeleteCardSuccess(data: result);
    });
  }

  Stream<AddCardState> createPaymentIntent({
    required String orderId,
    required String driverId,
    required String amount,
    required String tip,
  }) async* {
    yield CreatePaymentIntentLoading();
    final formData = FormData.fromMap({
      'order_id': orderId,
      'driver_id': driverId,
      'amount': amount,
      'tip': tip,
      'currency': 'cad',
    });
    final result = await paymentCard.createIntent(formData);
    yield* result.fold((failure) async* {
      yield CreatePaymentIntentFailure(failure: failure.message);
    }, (data) async* {
      final clientSecret = data['client_secret'] as String? ?? '';
      yield CreatePaymentIntentSuccess(clientSecret: clientSecret);
    });
  }

  // Stream<AddCardState> doAddCardApi({
  //   // required String email,
  //   // required String message,
  // }) async* {
  //   // saveEmailToLocal();
  //   yield AddCardLoading();
  //   // final formData =
  //   //     FormData.fromMap({'email': email, 'type': 1, 'message': message});
  //   // final result = await doAddCard.call(formData);
  //   yield* result.fold((statusCode) async* {
  //     yield AddCardFailure(failure: statusCode.message);
  //   }, (result) async* {
  //     yield AddCardSuccess(data: result);
  //   });
  // }
}
