import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/custom_text_field.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import '../../../features/new_card_payment/presentation/providers/add_card_state.dart';
import '../../../features/new_card_payment/presentation/providers/payment_provider.dart';

class AddNewCardPopUp extends StatelessWidget {
  // final Function positiveAction;
  const AddNewCardPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, provider, _) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        // height: 300,
        child: Form(
          key: provider.formKey,
          child: SingleChildScrollView(
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
                  // onChanged: (val) {
                  //   log("val: $val");
                  // },
                  inputType: TextInputType.number,
                  // onChanged: (val) {
                  //   log("onchanged:--> $val");
                  // },
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
                  controller: Provider.of<PaymentProvider>(context)
                      .cardNumberController,
                  fieldValidator: (val) {
                    log("value print :- $val");
                    if (val == '') {
                      return appLoc.mustNotEmpty;
                    }
                    return null;
                  },
                ),

                // Enter CVV Number
                // CustomTextField(
                //   fillColor: greyE7E7E7Color.withOpacity(.2),
                //   hintStyle: const TextStyle(
                //       fontFamily: 'poPPinRegular',
                //       fontWeight: FontWeight.w400,
                //       color: grey9c9c9cColor,
                //       fontSize: 12.0),
                //   placeholder: "Enter CVV Number",
                //   prefixIcon: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: SvgPicture.asset('assets/icons/card.svg'),
                //   ),
                //   controller:
                //       Provider.of<PaymentProvider>(context).cardCvvController,
                //   fieldValidator: (val) {
                //     if (val == '') {
                //       return appLoc.mustNotEmpty;
                //     }
                //     return null;
                //   },
                // ),

                //Account Holder name
                CustomTextField(
                  fillColor: greyE7E7E7Color.withOpacity(.2),
                  hintStyle: const TextStyle(
                      fontFamily: 'poPPinRegular',
                      fontWeight: FontWeight.w400,
                      color: grey9c9c9cColor,
                      fontSize: 12.0),
                  placeholder: "Card Holder Name",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/icons/user.svg',
                    ),
                  ),
                  controller: Provider.of<PaymentProvider>(context)
                      .accountHolderController,
                  fieldValidator: (val) {
                    if (val == '') {
                      return appLoc.mustNotEmpty;
                    }
                    return null;
                  },
                ),

                //Expiry Date
                InkWell(
                  onTap: () async {
                    var picked = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        initialMonthYearPickerMode: MonthYearPickerMode.year,
                        lastDate: DateTime(DateTime.now().year + 30)
                        // showCupertinoDialog<void>(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return Container(
                        //       height: 200,
                        //       child: CupertinoDatePicker(
                        //         mode: CupertinoDatePickerMode.date,
                        //         initialDateTime: DateTime.now(),
                        //         onDateTimeChanged: (DateTime newDate) {
                        //           // setState(() {
                        //           //   _selectedDate = newDate;
                        //           // });
                        //         },
                        //       ),
                        //     );
                        //   },
                        );

                    if (picked != null) {
                      log("picked:  ${picked}");
                      String formattedDate = DateFormat('MM/yy').format(picked);
                      log(formattedDate);

                      provider.setExpiryDate = formattedDate;
                    }
                    // CupertinoDatePicker(
                    //     mode: CupertinoDatePickerMode.date,
                    //     initialDateTime: DateTime.now(),
                    //     onDateTimeChanged: (DateTime newDate) {
                    //       // setState(() {
                    //       //  _selectedDate = newDate;
                    //     });
                    //  };

                    // ),
                    // DateTime? pickedDate = await showDatePicker(
                    //     context: context,
                    //     initialDate: DateTime.now(),
                    //     firstDate: DateTime.now(),
                    //     initialDatePickerMode: DatePickerMode.year,
                    //     lastDate: DateTime(DateTime.now().year + 30));
                    // if (pickedDate != null) {
                    //   log(pickedDate.toString());
                    //   log(pickedDate.toString());
                    //   String formattedDate =
                    //       DateFormat('yyyy/MM').format(pickedDate);
                    //   log(formattedDate);

                    //   provider.setExpiryDate = formattedDate;

                    // Provider.of<PaymentProvider>(context)
                    //     .expiryController
                    //     .text = formattedDate;

                    // expairyController.text = formattedDate;
                    // }

                    // log("celcil sdfa");
                    // var date = DatePickerDialog(
                    //     initialDate: DateTime.now(),
                    //     firstDate: DateTime.now(),
                    //     lastDate: DateTime(DateTime.now().year + 20));
                  },
                  child: IgnorePointer(
                    child: CustomTextField(
                      onTap: null,
                      readOnly: true,
                      fillColor: greyE7E7E7Color.withOpacity(.2),
                      hintStyle: const TextStyle(
                          fontFamily: 'poPPinRegular',
                          fontWeight: FontWeight.w400,
                          color: grey9c9c9cColor,
                          fontSize: 12.0),
                      placeholder: "Expiry Date (mm/yy)",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/icons/calender.svg',
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      controller: Provider.of<PaymentProvider>(context)
                          .expiryController,
                      fieldValidator: (val) {
                        if (val == '') {
                          return appLoc.mustNotEmpty;
                        }
                        return null;
                      },
                    ),
                  ),
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
                    final provider = context.read<PaymentProvider>();

                    if (provider.cardNumberController.text.trim() == '' ||
                            // provider.cardCvvController.text.trim() == '' ||
                            provider.accountHolderController.text.trim() == ''
                        // ||

                        // provider.expiryController.text.trim() == ''
                        ) {
                      showToast(message: "Please fill all the fields");
                    } else {
                      final provider = context.read<PaymentProvider>();
                      provider.addCardDetails().listen((state) async {
                        switch (state.runtimeType) {
                          case AddCardLoading:
                            showLoading();
                            break;
                          case AddCardFailure:
                            final msg = (state as AddCardFailure).failure;
                            dismissLoading();
                            showToast(message: msg);
                            break;
                          case AddCardSuccess:
                            final data = (state as AddCardSuccess).data;
                            dismissLoading();
                            if (data.success == 1) {
                              showToast(message: "add card success");

                              provider.cardNumberController.clear();
                              provider.accountHolderController.clear();
                              provider.expiryController.clear();

                              Navigator.pop(context);
                              // Navigator.pushNamedAndRemoveUntil(
                              //     context, HomePage.routeName, (route) => false);
                            } else {
                              if (data.message == '1') {
                                showToast(message: appLoc.registrationFailed);
                              } else {
                                showToast(message: appLoc.registrationFailed);
                              }
                            }

                            break;
                        }
                      });
                    }
                    // Stripe.instance.createToken(
                    //   CreateTokenParams.card(
                    //     params: CardTokenParams(
                    //         type: TokenType.Card,
                    //         address: Address(
                    //             city: "mohali",
                    //             country: "India",
                    //             line1: "line1",
                    //             line2: "line2",
                    //             postalCode: "140603",
                    //             state: "Mohali"),
                    //         currency: 'IN'),
                    //   ),
                    // );
                  },
                  bgColor: black080809Color,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
