import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/custom_text_field.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/contact_us/presentation/providers/contactus_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddNewCardPopUp extends StatelessWidget {
  // final Function positiveAction;
  const AddNewCardPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactusProvider>(builder: (context, provider, _) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        // height: 300,
        child: Form(
          key: provider.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/icons/payment_line.svg',
                  color: grey707070Color.withOpacity(.5),
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              //Enter card number
              CustomTextField(
                fillColor: greyE7E7E7Color.withOpacity(.2),
                hintStyle: const TextStyle(
                    fontFamily: 'poPPinRegular',
                    fontWeight: FontWeight.w400,
                    color: grey9c9c9cColor,
                    fontSize: 12.0),
                placeholder: "Enter Card Number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset('assets/icons/card.svg'),
                ),
                controller: Provider.of<ContactusProvider>(context)
                    .cardNumberController,
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
              ),

// Enter CVV Number
              CustomTextField(
                fillColor: greyE7E7E7Color.withOpacity(.2),
                hintStyle: const TextStyle(
                    fontFamily: 'poPPinRegular',
                    fontWeight: FontWeight.w400,
                    color: grey9c9c9cColor,
                    fontSize: 12.0),
                placeholder: "Enter CVV Number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset('assets/icons/card.svg'),
                ),
                controller:
                    Provider.of<ContactusProvider>(context).cardCvvController,
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
              ),

              //Account Holder name
              CustomTextField(
                fillColor: greyE7E7E7Color.withOpacity(.2),
                hintStyle: const TextStyle(
                    fontFamily: 'poPPinRegular',
                    fontWeight: FontWeight.w400,
                    color: grey9c9c9cColor,
                    fontSize: 12.0),
                placeholder: "Account Holder Name",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    'assets/icons/user.svg',
                  ),
                ),
                controller: Provider.of<ContactusProvider>(context)
                    .accountHolderController,
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
              ),

              //Expiry Date
              CustomTextField(
                fillColor: greyE7E7E7Color.withOpacity(.2),
                hintStyle: const TextStyle(
                    fontFamily: 'poPPinRegular',
                    fontWeight: FontWeight.w400,
                    color: grey9c9c9cColor,
                    fontSize: 12.0),
                placeholder: "Expiry Date (yyyy/mm)",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    'assets/icons/calender.svg',
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.fill,
                  ),
                ),
                controller:
                    Provider.of<ContactusProvider>(context).expiryController,
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),

              //Save Button
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
                event: () {
                  Stripe.instance.createToken(
                    CreateTokenParams.card(
                      params: CardTokenParams(
                          type: TokenType.Card,
                          address: Address(
                              city: "mohali",
                              country: "India",
                              line1: "line1",
                              line2: "line2",
                              postalCode: "140603",
                              state: "Mohali"),
                          currency: 'IN'),
                    ),
                  );
                },
                bgColor: black080809Color,
              ),
            ],
          ),
        ),
      );
    });
  }
}
