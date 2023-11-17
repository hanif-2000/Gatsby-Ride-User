import 'package:GetsbyRideshare/core/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class MenuAppBar extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final double appbarHeight;

  const MenuAppBar(
      {Key? key, required this.boxConstraints, required this.appbarHeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBarLoggedIn(
        boxConstraints: boxConstraints, appbarHeight: appbarHeight);
    // return FutureBuilder(
    //   future: checkUserSession(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return const SizedBox();
    //       case ConnectionState.done:
    //         //is login
    //         if (snapshot.data == true) {
    //           return AppBarLoggedIn(
    //               boxConstraints: boxConstraints, appbarHeight: appbarHeight);
    //         }
    //         return AppBarNotLoggedIn(
    //             boxConstraints: boxConstraints, appbarHeight: appbarHeight);
    //       default:
    //         return AppBarNotLoggedIn(
    //             boxConstraints: boxConstraints, appbarHeight: appbarHeight);
    //     }
    //   },
    // );
  }
}
