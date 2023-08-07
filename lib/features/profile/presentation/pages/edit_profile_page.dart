import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/profile/presentation/widgets/form_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_edit_provider.dart';
import '../providers/profile_provider.dart';
import '../../../../core/utility/injection.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = "EditProfilePage";
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
  }

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
            appBar: AppBar(
              backgroundColor: whiteColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: blackColor,
                ),
              ),
              elevation: 0.0,
            ),
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
