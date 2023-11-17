import 'dart:io';

import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/create_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/static/assets.dart';
import '../widgets/create_profile_form.dart';

class CreateProfilePage extends StatelessWidget {
  const CreateProfilePage({Key? key}) : super(key: key);
  static const routeName = '/createProfile';
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateProfileProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: black15141FColor,
            ),
          ),
          title: const Text(
            "Create Profile",
            style: TextStyle(
              fontFamily: "poPPinSemiBold",
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: black414141Color,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                            width: 135,
                            height: 135,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: greyB6B6B6Color,
                            ),
                            child: Center(
                              child: Provider.of<CreateProfileProvider>(context,
                                              listen: false)
                                          .imageFilePath ==
                                      ''
                                  ? Image.asset(
                                      cameraIcon,
                                      width: 52,
                                      height: 46,
                                    )
                                  : Image.file(
                                      File(Provider.of<CreateProfileProvider>(
                                              context,
                                              listen: true)
                                          .imageFilePath),
                                      width: 135,
                                      height: 135,
                                      fit: BoxFit.cover,
                                    ),
                            )),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            provider.showPicker(context: context);

                            // Provider.of<UploadProfileImageProvider>(context,
                            //         listen: false)
                            //     .checkImagePicked();
                          },
                          child: Image.asset(
                            pickGalleryImage,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const CreateProfileForm(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
