import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/widgets/bottom_profile.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/widgets/top_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/widgets/custom_app_title_bar.dart';
import '../providers/profile_provider.dart';
import '../providers/profile_state.dart';


class ProfilePage extends StatefulWidget {
  static const String routeName = "ProfilePage";
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: whiteColor,
        appBar: CustomAppTtitleBar(
          centerTitle: true,
          canBack: true,
          title: appLoc.profile.toUpperCase(),
          hideShadow: true,
        ),
        body: SafeArea(
          child: Consumer<ProfileProvider>(builder: (context, provider, _) {
            return
              StreamBuilder<ProfileState>(
                stream: context.read<ProfileProvider>().fetchProfile(),
                builder: (context, state) {
                  switch (state.data.runtimeType) {
                    case ProfileLoading:
                      return const Center(child: CircularProgressIndicator());
                    case ProfileFailure:
                      final failure = (state.data as ProfileFailure).failure;
                      showToast(message: failure);
                      return const SizedBox.shrink();
                    case ProfileLoaded:
                      final _data = (state.data as ProfileLoaded).data;
                      return ListView(
                        children: [
                          AspectRatio(
                            aspectRatio: 5 / 4,
                            child: Container(
                              color: greySecondColor,
                              child: TopProfile(
                                data: _data,
                              ),
                            ),
                          ),
                          const BottomProfile()
                        ],
                      );
                  }
                  return const SizedBox.shrink();
                });
          }),
        ));
  }
}
