import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../static/assets.dart';
import '../../static/colors.dart';
import '../../utility/helper.dart';

class CustomCacheNetworkImage extends StatelessWidget {
  final String img;
  final double size;
  const CustomCacheNetworkImage({
    Key? key,
    required this.img,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return img == ''
        ? CircleAvatar(
            backgroundColor: transparentColor,
            radius: size / 2,
            backgroundImage: AssetImage(userAvatarImage),
          )
        : CachedNetworkImage(
            imageUrl: mergePhotoUrl(img),
            imageBuilder: (context, imageProvider) => Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) {
              log("DOWNLOAD PROGRESS IS:-->> " +
                  downloadProgress.progress.toString());
              // log("DOWNLOAD PROGRESS IS:-->> " + progress.toString());

              return CircularProgressIndicator(
                value: downloadProgress.progress,
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
  }
}
