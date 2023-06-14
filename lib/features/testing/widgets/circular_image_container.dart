import 'package:flutter/material.dart';

class CommonCircularImageContainer extends StatelessWidget {
  final double? height;
  final double? width;
  const CommonCircularImageContainer({Key? key, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 36,
      height: height ?? 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage('https://googleflutter.com/sample_image.jpg'),
            fit: BoxFit.fill),
      ),
    );
  }
}
