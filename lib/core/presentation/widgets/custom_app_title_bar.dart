import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';

import '../../static/styles.dart';
import 'custom_back_button.dart';

class CustomAppTtitleBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final Widget? wTitle;
  final bool canBack;
  final bool centerTitle;
  final bool hideShadow;
  final bool hideLeading;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;
  final Color? titleColor;
  final Color? buttonBackColor;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final double toolbarHeight;
  final Widget? flexibleSpace;
  final Widget? titleWidget;
  final void Function()? onPressed;

  const CustomAppTtitleBar(
      {Key? key,
      this.title,
      this.canBack = false,
      this.centerTitle = true,
      this.hideShadow = true,
      this.backgroundColor = primaryColor,
      this.titleColor,
      this.buttonBackColor = Colors.black,
      this.actions,
      this.onPressed,
      this.wTitle,
      this.hideLeading = false,
      this.automaticallyImplyLeading = false,
      this.titleSpacing,
      this.toolbarHeight = kToolbarHeight,
      this.flexibleSpace,
      this.titleWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: hideShadow ? 0.0 : 4.0,
      shadowColor: hideShadow ? Colors.transparent : Colors.black,
      leading: hideLeading
          ? null
          : canBack
              ? CustomBackButton(
                  iconColor: Colors.white,
                  onPressed: onPressed,
                )
              : null,
      // title: wTitle ?? Text(title ?? "", style: appBarStyle(titleColor)),
      title: titleWidget ??
          wTitle ??
          Text(title ?? "", style: appBarStyle(titleColor)),
      actions: actions,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      flexibleSpace: flexibleSpace,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
