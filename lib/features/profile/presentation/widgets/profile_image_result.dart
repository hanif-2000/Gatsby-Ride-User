import 'dart:io';

import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import 'circle_image_network.dart';

class ProfileImagePicker extends StatelessWidget {
  final String? imageURL;
  final FormProvider provider;
  const ProfileImagePicker(
      {Key? key, required this.provider, this.imageURL = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          InkWell(
            onTap: () => provider.showImagePicker(context: context),
            child: ProfilePhotoResult(
              imagePath: provider.imageFilePath,
              imageURL: imageURL ?? '',
              constraints: constraints,
            ),
          ),
          ImagePickerButton(
            constraints: constraints,
            onTap: () {
              logMe("Click on Image Picker Button");
              provider.showImagePicker(context: context);
            },
          ),
        ],
      ),
    );
  }
}

class ProfilePhotoResult extends StatelessWidget {
  final BoxConstraints constraints;
  final String imagePath;
  final String imageURL;
  const ProfilePhotoResult({
    Key? key,
    required this.imagePath,
    required this.constraints,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: constraints / 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: imagePath.isEmpty
              ? imageURL.isNotEmpty
                  ? CircleImageNetwork(
                      imageProvider: Image.network(imageURL).image)
                  : Icon(
                      Icons.person_rounded,
                      color: Colors.black,
                      size: constraints.maxWidth / 5,
                    )
              : CircleImageNetwork(
                  imageProvider: Image.file(File(imagePath)).image),
        ),
      ),
    );
  }
}

class ImagePickerButton extends StatelessWidget {
  final BoxConstraints constraints;
  final Function onTap;
  const ImagePickerButton(
      {Key? key, required this.constraints, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: constraints / 3.1,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return Material(
                  color: Colors.white,
                  type: MaterialType.circle,
                  elevation: 0.5,
                  child: IconButton(
                    constraints: constraints,
                    padding: const EdgeInsets.all(4.0),
                    icon: const Icon(Icons.add_a_photo_rounded),
                    onPressed: () => onTap(),
                    iconSize: 20.0,
                    splashRadius: 20.0,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
