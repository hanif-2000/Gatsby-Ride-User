import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../presentation/widgets/bottom_sheet_image_source.dart';

class ImagePickerHelper {
  final BuildContext context;
  final ImagePicker imagePicker;
  final Function(XFile? file) successCallBack;
  final Function(String error) failedCallBack;

  ImagePickerHelper.showPicker({
    required this.context,
    required this.imagePicker,
    required this.successCallBack,
    required this.failedCallBack,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => BottomSheetImageSource(
        selectCamera: () async {
          Navigator.pop(context);
          pickImage(ImageSource.camera);
        },
        selectGallery: () async {
          Navigator.pop(context);
          pickImage(ImageSource.gallery);
        },
      ),
    );
  }
  Future<bool> pickImage(ImageSource source) async {
    try {
      XFile? _file = await imagePicker.pickImage(source: source);
      successCallBack(_file);
    } catch (e) {
      failedCallBack(e.toString());
    }
    return true;
  }

  bool isImageExceedOver3MB(int? byte) {
    if (byte == null) return false;
    return byte > 12000000;
  }
}
