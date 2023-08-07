import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider provider, Widget? child) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: whiteColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: blackColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Terms & Conditions",
              style: TextStyle(
                color: blackColor,
                fontFamily: 'poPPinSemiBold',
                fontSize: 21.0,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                        "1. By using Gatsby rideshare services, you agree to the following terms and conditions"),
                    Text(
                        "2. You must be at least 18 years old and possess a class 4 valid driver's license to use the Gatsby rideshare app as a driver."),
                    Text(
                        "3. You must be at least 18 years old to use the Gatsby rideshare app as a passenger. Unless a parent or guardian consent."),
                    Text(
                        "4. Gatsby rideshare drivers must have a valid and up-to-date insurance policy that meets the minimum requirements set by local laws"),
                    Text(
                        "5. Payment for rides must be made through the Gatsby rideshare app using a valid credit or debit card."),
                    Text(
                        "6. Passengers are advised to behave responsibly and courteously during rides. Any misuse, vandalism, or damage to the vehicle may result in legal action."),
                    Text(
                        "7. Drivers are responsible for ensuring that the vehicle used for transport is roadworthy, clean, and free of defects that may pose a risk to passengers."),
                    Text(
                        "8. Gatsby rideshare does not provide any guarantee for reliability, quality, or success of any ride booked through the app"),
                    Text(
                        "9. Gatsby rideshare does not assume any liability for any loss or damages caused by or arising out of its services, including but not limited to accidents, theft, loss of property, and personal injuries."),
                    Text(
                        "10. Gatsby rideshare reserves the right to suspend or terminate any user's account for any violation of the terms and conditions stated herein, or any other local or federal laws or regulations."),
                    Text(
                        "11. Any disputes arising out of or related to the use of Gatsby rideshare services shall be governed by the laws of Alberta"),
                    Text(
                        "12. These terms and conditions may be modified by Gatsby rideshare at any time without prior notice. Users are advised to read the terms and conditions periodically and to discontinue use of the app if they do not agree with the revised terms and conditions."),
                    Row(
                      children: [
                        Checkbox(
                            value: provider.isAccepted,
                            onChanged: (v) {
                              provider.updateTermsAccepted(v);
                            }),
                        Text(
                          "Accept the terms & Condition",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
