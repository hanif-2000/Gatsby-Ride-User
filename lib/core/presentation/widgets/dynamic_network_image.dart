import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../static/assets.dart';

class DynamicCachedNetworkImage extends StatelessWidget {
  const DynamicCachedNetworkImage(
      {Key? key,
      required this.imageUrl,
      this.height = 0.0,
      this.width = 0.0,
      this.boxFit})
      : super(key: key);
  final String imageUrl;
  final double height, width;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: boxFit,
      width: width,
      height: height,
      placeholder: (context, url) => Image.asset(
        userAvatarImage,
        fit: BoxFit.cover,
        height: height,
        width: width,
      ),
      errorWidget: (context, url, error) => Image.asset(
        userAvatarImage,
        fit: BoxFit.cover,
      ),
      imageBuilder: (context, imageProvider) => Image(
        image: imageProvider,
        fit: BoxFit.cover,
      ),
    );
  }
}
