import 'package:flutter/material.dart';

import '../../static/colors.dart';

class CustomListTile extends StatelessWidget {
  final String? titleText;
  final String? subTitleText;
  final Color? color;
  final Widget? leading;
  final Widget? title;
  final Widget? subTitle;
  final Widget? trailing;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool enabled;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final bool selected;
  final bool enableDivider;
  final TextStyle? customStyle;
  final EdgeInsets? titlePadding;
  const CustomListTile({
    Key? key,
    this.titleText,
    this.subTitleText,
    this.color,
    this.leading,
    this.title,
    this.subTitle,
    this.trailing,
    this.padding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enableDivider = true,
    this.customStyle,
    this.titlePadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: enabled ? onTap : null,
        child: Column(
          children: [
            Container(
              padding: padding,
              margin: margin,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      leading ?? Container(),
                      Expanded(
                        child: Padding(
                          padding: titlePadding ??
                              const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              titleText != null
                                  ? Text(
                                      titleText!,
                                      style: customStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : title ?? Container(),
                            ],
                          ),
                        ),
                      ),
                      trailing ?? Container(),
                    ],
                  ),
                  subTitle ?? Container(),
                ],
              ),
            ),
            enableDivider
                ? const Divider(
                    height: 2,
                    color: secondaryColor,
                  )
                : Container()
          ],
        ),
      );
}
