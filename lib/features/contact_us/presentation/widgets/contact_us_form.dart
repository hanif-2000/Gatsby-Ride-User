import 'dart:developer';

import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/contact_us/presentation/providers/contactus_provider.dart';
import 'package:appkey_taxiapp_user/features/contact_us/presentation/widgets/contact_us_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/helper.dart';

class ContactUsForm extends StatefulWidget {
  const ContactUsForm({Key? key}) : super(key: key);

  @override
  State<ContactUsForm> createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<ContactUsForm> {
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
                    Provider.of<ContactusProvider>(context).firstNameController,
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
                controller:
                    Provider.of<ContactusProvider>(context).lastNameController,
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
                  log("On Click on send message ");
                  showDialog(
                      barrierColor: whiteColor.withOpacity(.8),
                      context: context,
                      builder: (_) => const ContactUsDialog());
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
