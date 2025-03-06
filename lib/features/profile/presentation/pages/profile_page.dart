import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/profile/presentation/widgets/form_edit_profile.dart';
import 'package:GetsbyRideshare/features/profile/presentation/widgets/top_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/injection.dart';
import '../providers/profile_edit_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/profile_state.dart';
import 'edit_profile_page.dart';

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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: blackColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: whiteColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Consumer<ProfileProvider>(builder: (context, provider, _) {
            return StreamBuilder<ProfileState>(
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
                            aspectRatio: 5 / 3,
                            child: Container(
                              color: whiteColor,
                              child: TopProfile(
                                data: _data,
                              ),
                            ),
                          ),

                          EditProfilePage(),

                          showProfileData(),
                          // FormEditProfile(),
                          // const BottomProfile()
                        ],
                      );
                  }
                  return const SizedBox.shrink();
                });
          }),
        ));
  }
}

class showProfileData extends StatefulWidget {
  const showProfileData({Key? key}) : super(key: key);

  @override
  State<showProfileData> createState() => _showProfileDataState();
}

class _showProfileDataState extends State<showProfileData> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ProfileProvider>(
              create: (_) => locator<ProfileProvider>()..setProfileData()),
          ChangeNotifierProxyProvider<ProfileProvider, ProfileEditProvider>(
            create: (_) => locator<ProfileEditProvider>(),
            update: (context, profile, edit) =>
                edit!..setupTextControllerValues(profile.profile),
          )
        ],
        builder: (context, child) => Scaffold(
            key: locator<GlobalKey<ScaffoldState>>(),
            backgroundColor: whiteColor,
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Consumer<ProfileProvider>(
                    builder: (context, provider, _) {
                  if (provider.isLoadProfile) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView(
                      children: const [FormEditProfile()],
                    );
                  }
                });
              },
            )));
  }
}
