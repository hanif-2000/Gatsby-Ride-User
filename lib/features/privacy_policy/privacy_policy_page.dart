import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
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
          "Privacy Policy",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  "1. Safety first: Our top priority is the safety of both our passengers and drivers. We expect all drivers to comply with traffic laws, use seat belts, and never engage in distracted driving."),
              Text(
                  "2. Respectful behavior: We value courteous and respectful behavior from both passengers and drivers. Discrimination and inappropriate conduct will not be tolerated and could result in suspension or termination of the driver's account."),
              Text(
                  "3. Cleanliness: We expect drivers to maintain a clean and tidy car for the comfort of passengers. Passengers are also expected to respect the driver's property and keep the car clean."),
              Text(
                  "4. Open communication: We encourage open communication between drivers and passengers to ensure a pleasant and safe ride. Passengers should indicate their destination upon entering the car and be willing to assist with navigation if necessary"),
              Text(
                  "5. Fair pricing: We strive to keep pricing competitive and transparent. Passengers should see an estimate of the fare before requesting a ride, and drivers are expected to follow the pricing structure in their area.."),
              Text(
                  "6. Zero-tolerance policy for intoxication: Our services are strictly for sober transportation. Drivers have the right to refuse pick up passengers who are visibly intoxicated, and passengers who become belligerent or disruptive will be removed from the vehicle."),
              Text(
                  "By agreeing to these policies, we aim to provide a safe, comfortable, and reliable transportation service for all parties involved."),
            ],
          ),
        ),
      ),
    );
  }
}
