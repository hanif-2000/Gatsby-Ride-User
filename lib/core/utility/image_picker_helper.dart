import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../presentation/widgets/bottom_sheet_image_source.dart';
import 'helper.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ImagePickerHelper {
  final BuildContext context;
  final ImagePicker imagePicker;
  final Function(String? file) successCallBack;
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
      XFile? file = await imagePicker.pickImage(source: source);
      if(file != null){
        _isImageSizeAcceptable(file.path);
      }
    //  successCallBack(_file);
    } catch (e) {
      failedCallBack(e.toString());
    }
    return true;
  }

  bool isImageExceedOver3MB(int? byte) {
    if (byte == null) return false;
    return byte > 12000000;
  }
  Future<XFile?> _compressFile(File file) async {
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      return null;
    }

    // Image file info
    final String fileExtension = mimeType.split('/')[1];
    final dir = await path_provider.getTemporaryDirectory();
    final dateTime = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    final targetPath = '${dir.absolute.path}/${dateTime}temp.$fileExtension';

    CompressFormat format;
    switch (fileExtension.toLowerCase()) {
      case 'png':
        format = CompressFormat.png;
        break;
      case 'jpeg':
        format = CompressFormat.jpeg;
        break;
      case 'heic':
        format = CompressFormat.heic;
        break;
      case 'webp':
        format = CompressFormat.webp;
        break;
      default:
        format = CompressFormat.jpeg;
    }

    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        format: format,
        minWidth: 900,
        minHeight: 900,
        quality: 50,
      );
      if (result?.path != null) {
        logMe('Original image size: ${await _getImageSizeInMB(file.path)} MB');
        logMe('Compressed image size: ${await _getImageSizeInMB(result!.path)} MB');
        if(await _getImageSizeInMB(result.path)>1) {
          showToast(message: "The image size is too large. Please select a different image.");
          return null;
        }
      } else {
        showToast(message: 'Compression failed or result is null.');
        failedCallBack('Compression failed or result is null.');
      }
      return result;
    } catch (e) {
      logMe('Error during compression: $e');
      failedCallBack(e.toString());
      return null;
    }
  }

  Future<void> _isImageSizeAcceptable(String imagePath) async {
    double imageSizeInMB = await _getImageSizeInMB(imagePath);
    logMe("image Size==>>>>>>>$imageSizeInMB----->>$imagePath");
    if(imageSizeInMB<=0.5){
      successCallBack(imagePath);
    }else {
      File imageFile = File(imagePath);
      var compressImageFile = await _compressFile(imageFile);
      if(compressImageFile?.path != null){
        logMe("compress Image File==>>>>>>>${compressImageFile?.path}");
        successCallBack(compressImageFile?.path);
        // _navigateToEdit(compressImageFile?.path);
      }
    }
  }
  Future<double> _getImageSizeInMB(String imagePath) async {
    File imageFile = File(imagePath);
    int fileSizeInBytes = await imageFile.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return fileSizeInMB;
  }
}
