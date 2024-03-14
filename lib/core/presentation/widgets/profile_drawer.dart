import 'dart:developer';

import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../../features/profile/presentation/providers/profile_provider.dart';
import '../../../features/profile/presentation/providers/profile_state.dart';
import '../../static/assets.dart';
import '../../utility/helper.dart';

class ProfileInformationDrawer extends StatelessWidget {
  const ProfileInformationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;

    return StreamBuilder<ProfileState>(
        stream: context.read<ProfileProvider>().fetchProfile(),
        builder: (context, state) {
          switch (state.data.runtimeType) {
            case ProfileLoading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ProfileFailure:
              final failure = (state.data as ProfileFailure).failure;
              logMe(failure);
              return const SizedBox.shrink();
            case ProfileLoaded:
              logMe("loaded");
              final data = (state.data as ProfileLoaded).data;
              log("photo data----->>>>>" + data.photo.toString());

              log("profile data is:-->>${data}");
              return Column(
                children: [
                  Container(
                    child: (data.photo == '') || (data.photo == null)
                        ? const CircleAvatar(
                            backgroundColor: transparentColor,
                            radius: 60,
                            backgroundImage: AssetImage(userAvatarImage),
                          )
                        : CachedNetworkImage(
                            imageUrl: mergePhotoUrl(data.photo),
                            imageBuilder: (context, imageProvider) => Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            progressIndicatorBuilder: (context, url, progress) {
                              return CircularProgressIndicator(
                                value: progress.progress,
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),

                    // CircleAvatar(
                    //     backgroundColor: transparentColor,
                    //     radius: 60,
                    //     backgroundImage: NetworkImage(
                    //       mergePhotoUrl(data.photo),
                    //     ),
                    //   ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: _deviceSize.height * .02,
                      bottom: _deviceSize.height * .005,
                    ),
                    child: Text(
                      data.name,
                      style: const TextStyle(
                          fontFamily: 'poPPinMedium',
                          fontWeight: FontWeight.w500,
                          color: bluegrey242E42Color,
                          fontSize: 20.0),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EditProfilePage())).then((value) {
                        if (value != null) {
                          // provider.refreshProfile();
                        }
                      });
                      // Navigator.pushReplacementNamed(
                      //   context,
                      //   ProfilePage.routeName,
                      // );
                    },
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontFamily: 'poPPinRegular',
                          fontWeight: FontWeight.w400,
                          color: grey8A8A8FColor,
                          fontSize: 15.0),
                    ),
                  ),
                ],
              );

            // CustomListTile(
            //   onTap: () {},
            //   titlePadding: const EdgeInsets.only(left: 10),
            //   margin: EdgeInsets.zero,
            //   padding: EdgeInsets.zero,
            //   enableDivider: false,
            //   leading: data.photo == null
            //       ? const CircleAvatar(
            //           radius: 33,
            //           backgroundImage: AssetImage(userAvatarImage),
            //         )
            //       : CircleAvatar(
            //           radius: 33,
            //           backgroundImage:
            //               NetworkImage(mergePhotoUrl(data.photo)),
            //         ),
            //   title: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         data.name,
            //         style: formTextFieldStyle,
            //       ),
            //       Text(
            //         data.phone,
            //         style: formTextFieldStyle,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Text(
            //             data.email,
            //             style: formTextFieldStyle,
            //           ),
            //           const Expanded(child: SizedBox()),
            //         ],
            //       ),
            //     ],
            //   ),
            // );
          }
          return const SizedBox.shrink();
        });
  }
}
