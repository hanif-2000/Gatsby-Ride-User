import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/contact_us/presentation/providers/contactus_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddNewCardPopUp extends StatelessWidget {
  // final Function positiveAction;
  const AddNewCardPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactusProvider>(builder: (context, provider, _) {
      return Container(
        color: Colors.red,
        height: 300,
        child: Form(
          key: provider.formKey,
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
                placeholder: "Enter Card Number",
                prefixIcon: SvgPicture.asset('assets/icons/card.svg'),
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
                placeholder: "Enter CVV Number",
                prefixIcon: SvgPicture.asset('assets/icons/card.svg'),
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
                placeholder: "Account Holder Name",
                prefixIcon: SvgPicture.asset('assets/icons/user.svg'),
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
                placeholder: "Expiry Date (yyyy/mm)",
                prefixIcon: SvgPicture.asset(
                  'assets/icons/calender.svg',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.fill,
                ),
                controller:
                    Provider.of<ContactusProvider>(context).firstNameController,
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
              ),
              CustomButton(
                text: const Text(
                  "Save",
                  style: TextStyle(
                    fontFamily: 'poPPinSemiBold',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                buttonHeight: 50,
                isRounded: true,
                event: () {},
                bgColor: black080809Color,
              ),
            ],
          ),
        ),
      );
    });
  }
}
