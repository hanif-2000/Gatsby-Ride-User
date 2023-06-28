import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';

class CommonCircularImageContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final String? image;
  const CommonCircularImageContainer(
      {Key? key, this.width, this.height, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 36,
      height: height ?? 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: image == ''
                ? NetworkImage('https://googleflutter.com/sample_image.jpg')
                : NetworkImage(mergePhotoUrl(image!)),
            fit: BoxFit.fill),
      ),
    );
  }
}
