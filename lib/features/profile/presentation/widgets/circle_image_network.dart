import 'package:appkey_taxiapp_user/core/static/assets.dart';
import 'package:flutter/material.dart';

class CircleImageNetwork extends StatelessWidget {
  final ImageProvider imageProvider;
  final BoxFit fit;
  static const placeHolder = AssetImage(userAvatarImage);
  const CircleImageNetwork({
    Key? key,
    this.imageProvider = placeHolder,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image(
        image: imageProvider,
        fit: fit,
      ),
    );
  }
}
