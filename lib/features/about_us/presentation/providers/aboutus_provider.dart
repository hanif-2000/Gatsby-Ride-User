import 'package:flutter/material.dart';

import '../../domain/usecases/get_aboutus.dart';
import 'aboutus_state.dart';

class AboutUsProvider extends ChangeNotifier {
  final GetAboutUs getAboutUs;

  AboutUsProvider({required this.getAboutUs});

  Stream<AboutUsState> fetchAboutUs() async* {
    yield AboutUsLoading();
    final result = await getAboutUs();
    yield* result.fold((failure) async* {
      yield AboutUsFailure(failure: failure.message);
    }, (data) async* {
      yield AboutUsLoaded(data: data);
    });
  }
}
