import 'package:GetsbyRideshare/core/presentation/widgets/components/dialog_container.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactUsDialog extends StatelessWidget {
  // final Function positiveAction;
  const ContactUsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return DialogContainer(
      withPadding: true,
      withMargin: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: _deviceSize.height * .03,
          left: _deviceSize.width * .05,
          right: _deviceSize.width * .05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: grey767676Color,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SvgPicture.asset('assets/icons/sent_message.svg'),

            Padding(
              padding: EdgeInsets.only(top: _deviceSize.height * .05),
              child: const Text(
                "Message Sent",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0,
                    color: black282828Color),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: _deviceSize.height * .01,
                  bottom: _deviceSize.height * .05),
              child: const Text(
                "Your Message has been Sent",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: grey767676Color,
                ),
              ),
            ),

            CustomButton(
              text: const Text(
                "Done",
                style: TextStyle(
                  fontFamily: 'poPPinSemiBold',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              buttonHeight: 50,
              isRounded: true,
              event: () {
                Navigator.pop(context);
              },
              bgColor: black080809Color,
            ),

            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            //   child: Text(
            //     appLoc.wouldYouLikeLogout,
            //     style: const TextStyle(fontSize: 15.0).useHiraginoKakuW3Font(),
            //     textAlign: TextAlign.center,
            //     maxLines: 2,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
            // mediumVerticalSpacing(),
            // // ConfirmationButtons(
            // //   positiveAction: positiveAction,
            // // ),
            // smallVerticalSpacing()
          ],
        ),
      ),
    );
  }
}
