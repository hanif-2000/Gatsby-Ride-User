import 'package:GetsbyRideshare/core/static/assets.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../static/app_config.dart';
import '../pages/menu_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool canBack;
  final bool centerTitle;
  final bool hideShadow;
  final Color? titleColor;
  final Color? buttonBackColor;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? widgetTitle;
  final void Function()? onBackAction;
  const CustomAppBar({
    Key? key,
    this.title,
    this.canBack = false,
    this.centerTitle = true,
    this.hideShadow = true,
    this.backgroundColor = primaryColor,
    this.titleColor,
    this.buttonBackColor = Colors.black,
    this.actions,
    this.widgetTitle,
    this.onBackAction,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: hideShadow ? 0.0 : 4.0,
      titleSpacing: 10,
      centerTitle: centerTitle,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: IconButton(
            icon: Image.asset(menuIcon),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: const HomeDrawerPage(),
                ),
              );
              // checkUserSession().then((value) async {
              //   if (value) {
              //     Navigator.push(
              //       context,
              //       PageTransition(
              //         type: PageTransitionType.leftToRight,
              //         child: const HomeDrawerPage(),
              //       ),
              //     );
              //   } else {
              //     Navigator.pushNamed(context, LoginPage.routeName);
              //   }
              // });
            },
          ),
        ),
      ],
      title: SizedBox(
          width: App(context).appWidth(30.0),
          child: Image.asset(taxiTextAsset)),
    );
  }
}
