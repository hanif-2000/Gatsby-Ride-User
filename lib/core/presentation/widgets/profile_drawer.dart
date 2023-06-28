import 'package:appkey_taxiapp_user/core/static/colors.dart';
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
              return Column(
                children: [
                  // data.photo == ''
                  //     ? CachedNetworkImage(
                  //         imageUrl: mergePhotoUrl(data.photo),
                  //         placeholder: (context, url) => const CircleAvatar(
                  //           backgroundColor: Colors.transparent,
                  //           // backgroundColor: Colors.amber,
                  //           radius: 60,
                  //         ),
                  //         imageBuilder: (context, image) => CircleAvatar(
                  //           backgroundColor: Colors.transparent,
                  //           backgroundImage: image,
                  //           radius: 60,
                  //         ),
                  //       )
                  //     : CircleAvatar(
                  //         radius: 60.0,
                  //         backgroundImage: AssetImage(userAvatarImage),
                  //       ),
                  Container(
                    child: data.photo == ''
                        ? const CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(userAvatarImage),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              mergePhotoUrl(data.photo),
                            ),
                          ),
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
