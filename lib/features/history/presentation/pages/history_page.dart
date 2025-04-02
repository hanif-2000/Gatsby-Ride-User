import 'dart:developer';

import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/history/presentation/widgets/history_item.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/history_state.dart';
import '../providers/history_provider.dart';

class HistoryPage extends StatefulWidget {
  static const String routeName = "HistoryPage";
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: blackColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: whiteColor,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            appLoc.history,
            style: const TextStyle(
              fontSize: 24.0,
              fontFamily: 'poPPinMedium',
              color: blackColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Consumer<HistoryProvider>(builder: (context, provider, _) {
            return StreamBuilder<HistoryState>(
                stream: context.read<HistoryProvider>().fetchHistory(),
                builder: (context, state) {
                  switch (state.data.runtimeType) {
                    case HistoryLoading:
                      log("history loading called");
                      return Center(
                        child: LottieBuilder.asset(
                            'assets/icons/lottie_animation.json'),
                      );

                    // const Center(child: CircularProgressIndicator());
                    case HistoryFailure:
                      log("history failure called");

                      final failure = (state.data as HistoryFailure).failure;
                      showToast(message: failure);
                      return const SizedBox.shrink();
                    case HistoryLoaded:
                      log("history loadeed called");

                      final _data = (state.data as HistoryLoaded).data;

                      log("history data is====>>>${_data}");
                      if (_data.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: LottieBuilder.asset(
                                  'assets/lottie_animation/no_data_found.json'),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .3,
                            )
                          ],
                        );
                        // return Center(
                        //   child: Text(
                        //     appLoc.thereAreNoPastOrders,
                        //     style: formLabelHeaderStyle,
                        //   ),
                        // );
                      }
                      return ListView.builder(
                          itemCount: _data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: HistoryItem(data: _data[index]),
                            );
                          });
                  }
                  return const SizedBox.shrink();
                });
          }),
        ));
  }
}
