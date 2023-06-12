import 'package:flutter/material.dart';

import '../../static/dimens.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? height;
  final double radius;
  final bool shadow;
  final bool withPadding;
  final Clip clipBehavior;
  const RoundedContainer({
    Key? key,
    required this.child,
    this.color = Colors.white,
    this.height,
    this.radius = sizeLarge,
    this.shadow = false,
    this.withPadding = true,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: sizeSmall,
        left: sizeSmall,
        right: sizeSmall,
      ),
      child: Container(
        clipBehavior: clipBehavior,
        height: height,
        padding: withPadding ? const EdgeInsets.all(sizeSmall) : null,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            (shadow)
                ? BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 2,
                  )
                : const BoxShadow()
          ],
        ),
        child: child,
      ),
    );
  }
}
