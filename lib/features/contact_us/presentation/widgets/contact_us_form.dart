import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/custom_text_field.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/contact_us/data/models/contactus_response_modal.dart';
import 'package:GetsbyRideshare/features/contact_us/presentation/providers/contactus_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/helper.dart';
import '../providers/contactus_state.dart';
import 'contact_us_popup.dart';

class ContactUsForm extends StatefulWidget {
  const ContactUsForm({Key? key}) : super(key: key);

  @override
  State<ContactUsForm> createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<ContactUsForm> {
  void submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    final provider = context.read<ContactusProvider>();
    provider
        .doContactusApi(
            email: provider.emailController.text,
            message: provider.contactMessageController.text)
        .listen((state) async {
      log(state.toString());
      switch (state.runtimeType) {
        case ContactusLoading:
          showLoading();

          break;
        case ContactusFailure:
          final msg = (state as ContactusFailure).failure;

          // log("-------->>>>>>" + msg.toString());
          dismissLoading();

          showToast(message: msg);
          break;
        case ContactusSuccess:
          ContactUsResponseModel result = (state as ContactusSuccess).data;

          log("-------->>>>>>>" + result.message.toString());

          dismissLoading();
          if (result.success == 1) {
            provider.emailController.clear();
            provider.contactMessageController.clear();
            showDialog(
                barrierColor: whiteColor.withOpacity(.8),
                context: context,
                builder: (_) => const ContactUsDialog());
          } else {
            showToast(message: result.message!);
          }

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Consumer<ContactusProvider>(builder: (context, provider, _) {
      return Form(
        key: provider.formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _deviceSize.width * .02),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              CustomTextField(
                fillColor: greyE7E7E7Color.withOpacity(.2),
                hintStyle: const TextStyle(
                    fontFamily: 'poPPinRegular',
                    fontWeight: FontWeight.w400,
                    color: grey9c9c9cColor,
                    fontSize: 12.0),
                placeholder: "Enter Your Email",
                controller:
                    Provider.of<ContactusProvider>(context).emailController,
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
              ),
              CustomTextField(
                fillColor: greyE7E7E7Color.withOpacity(.2),
                hintStyle: const TextStyle(
                    fontFamily: 'poPPinRegular',
                    fontWeight: FontWeight.w400,
                    color: grey9c9c9cColor,
                    fontSize: 12.0),
                maxLine: 5,
                placeholder: "Enter Your Message",
                controller: Provider.of<ContactusProvider>(context)
                    .contactMessageController,
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: _deviceSize.height * .15,
              ),
              CustomButton(
                text: const Text(
                  "Send Message",
                  style: TextStyle(
                    fontFamily: 'poPPinSemiBold',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                buttonHeight: 50,
                isRounded: true,
                event: () {
                  log(provider.emailController.text);
                  log(provider.contactMessageController.text);
                  if (provider.formKey.currentState!.validate()) {
                    submit();
                  }
                },
                bgColor: black080809Color,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: _deviceSize.height * .02,
                      bottom: _deviceSize.height * .02),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontFamily: 'poPPinSemiBold',
                        fontWeight: FontWeight.w500,
                        color: black282828Color,
                        fontSize: 16.0),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
