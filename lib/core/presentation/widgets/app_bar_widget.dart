import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/features/about_us/presentation/pages/aboutus_page.dart';
import 'package:GetsbyRideshare/features/history/presentation/pages/history_page.dart';
import 'package:GetsbyRideshare/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../../../features/login/presentation/pages/login_page.dart';
import '../../../socket/latest_socket_provider.dart';
import '../../static/assets.dart';
import '../../utility/helper.dart';
import '../pages/splash_page.dart';
import 'custom_dialog_logout.dart';
import 'menu_button.dart';

class AppBarLoggedIn extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final double appbarHeight;
  const AppBarLoggedIn(
      {Key? key, required this.boxConstraints, required this.appbarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var socketProvider = locator<LatestSocketProvider>();
    return SizedBox(
        width: boxConstraints.maxWidth * 0.6,
        height: appbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: MenuButton(
                title: appLoc.profile,
                imageAsset: userIcon,
                tap: () {
                  Navigator.pushNamed(
                    context,
                    ProfilePage.routeName,
                  );
                },
                height: appbarHeight,
              ),
            ),
            Expanded(
              child: MenuButton(
                title: appLoc.history,
                imageAsset: historyIcon,
                tap: () {
                  Navigator.pushNamed(
                    context,
                    HistoryPage.routeName,
                  );
                },
                height: appbarHeight,
              ),
            ),
            Expanded(
              child: MenuButton(
                title: appLoc.we,
                imageAsset: introductionIcon,
                tap: () {
                  Navigator.pushNamed(
                    context,
                    AboutUsPage.routeName,
                  );
                },
                height: appbarHeight,
              ),
            ),
            Expanded(
              child: MenuButton(
                title: appLoc.logout,
                imageAsset: logoutIcon,
                tap: () async {
                  showDialog(
                    context: context,
                    builder: (_) => CustomLogoutDialog(
                      positiveAction: () async {
                        socketProvider.disconnectSocket();
                        await sessionLogOut().then((_) => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                LoginPage.routeName, (route) => false));
                      },
                    ),
                  );
                },
                height: appbarHeight,
              ),
            ),
          ],
        ));
  }
}

class AppBarNotLoggedIn extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final double appbarHeight;
  const AppBarNotLoggedIn(
      {Key? key, required this.boxConstraints, required this.appbarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: boxConstraints.maxWidth * 0.3,
        height: appbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: MenuButton(
                title: appLoc.login,
                imageAsset: userIcon,
                tap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.routeName, (route) => false);
                },
                height: appbarHeight,
              ),
            ),
            Expanded(
              child: MenuButton(
                title: appLoc.we,
                imageAsset: introductionIcon,
                tap: () {
                  Navigator.pushNamed(
                    context,
                    AboutUsPage.routeName,
                  );
                },
                height: appbarHeight,
              ),
            ),
          ],
        ));
  }
}
