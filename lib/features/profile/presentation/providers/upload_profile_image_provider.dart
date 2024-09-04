import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/profile/domain/usecases/upload_profile_image.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/create_profile_provider.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/upload_profile_image_state.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/providers/form_provider.dart';

class UploadProfileImageProvider extends FormProvider {
  final UploadProfileImage doUploadProfileImage;

  UploadProfileImageProvider({required this.doUploadProfileImage});

  Stream<UploadProfileImageState> doUploadProfileImageApi(context) async* {
    var imageFilePath = Provider.of<CreateProfileProvider>(context, listen: false).imageFile;
    if(imageFilePath?.isEmpty??true){
      return;
    }

    // log(imageFilePath.toString());
    //show loader
    yield UploadProfileImageLoading();

    //formdata
    var formData = FormData.fromMap({
      'upload': await MultipartFile.fromFile(imageFilePath!,
          filename: 'profile'),
    });
    // logMe(formData.files[0].toString());
    logMe(imageFilePath);
    final result = await doUploadProfileImage.execute(formData);
    yield* result.fold((statusCode) async* {
      yield UploadProfileImageFailure(failure: statusCode.message);
    }, (result) async* {
      yield UploadProfileImageSuccess(data: result);
    });
  }
}
