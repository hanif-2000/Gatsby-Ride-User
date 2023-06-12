import 'package:flutter/material.dart';

import '../../static/colors.dart';
import '../../static/dimens.dart';
import 'rounded_container.dart';

class BottomSheetImageSource extends StatelessWidget {
  final Function selectCamera;
  final Function selectGallery;
  const BottomSheetImageSource(
      {Key? key, required this.selectCamera, required this.selectGallery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sizeSmall),
      color: bgGreyColor,
      height: 210,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(sizeSmall),
            child: InkWell(
              onTap: () => selectCamera(),
              child: const RoundedContainer(
                height: null,
                child: ListTile(
                  leading: Icon(Icons.camera_alt_rounded),
                  title: Text(
                    'Camera',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(sizeSmall),
            child: InkWell(
              onTap: () => selectGallery(),
              child: const RoundedContainer(
                height: null,
                child: ListTile(
                  leading: Icon(Icons.image_rounded),
                  title: Text(
                    'Gallery',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
