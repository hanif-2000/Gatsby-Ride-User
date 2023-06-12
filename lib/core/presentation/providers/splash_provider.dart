import 'package:appkey_taxiapp_user/core/domain/usecases/get_currency.dart';
import 'package:appkey_taxiapp_user/core/presentation/providers/currency_state.dart';
import 'package:flutter/material.dart';

import '../../utility/injection.dart';
import '../../utility/session_helper.dart';

class SplashProvider with ChangeNotifier {
  final GetCurrency getCurrency;

  SplashProvider({required this.getCurrency});

  Stream<CurrencyState> fetchCurrency() async* {
    // enter loading state
    yield CurrencyLoading();

    // getting data
    final result = await getCurrency();
    yield* result.fold(
      (failure) async* {
        // enter failure state
        yield CurrencyFailure(failure: failure);
      },
      (data) async* {
        final session = locator<Session>();
        session.setCurrency = data.data;
        yield CurrencyLoaded(data: data);
      },
    );
  }
}
