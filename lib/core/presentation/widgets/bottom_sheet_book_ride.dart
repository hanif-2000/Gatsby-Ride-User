import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_vehicle_info.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/payment_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetBookRide extends StatelessWidget {
  const BottomSheetBookRide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        height: _deviceSize.height * .5,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: _deviceSize.height * .02),
                child: SvgPicture.asset(
                  'assets/icons/grey-dropdown-icon.svg',
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomVehicleInfo(
                      vehicleImage: 'assets/icons/car-dropdown.png',
                      time: "2 min",
                      price: r'$ 40.00',
                      vehicleType: 'Economy',
                      capacity: "4",
                    ),
                  );
                },
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: _deviceSize.height * .02),
                child: const DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: greyB6B6B6Color,
                  // dashGradient: const [Colors.red, Colors.blue],
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  // dashGapGradient: const [Colors.red, Colors.blue],
                  dashGapRadius: 0.0,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentOption()));
                  // showBottomSheet(
                  //   context: context,
                  //   builder: (context) {
                  //     return const PaymentOption();
                  //   },
                  // );
                  // showBottomSheet(

                  //   context: context,
                  //   builder: (context) {
                  //     return const Text("SDFASDFASD");
                  //   },
                  // );
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: _deviceSize.width * .05),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: _deviceSize.width * .05,
                                ),
                                child:
                                    SvgPicture.asset('assets/icons/cash.svg'),
                              ),
                              const Text(
                                "Cash",
                                style: TextStyle(
                                  fontFamily: 'poPPinMedium',
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(right: _deviceSize.width * .02),
                            child: SvgPicture.asset(
                                'assets/icons/grey-disclosure.svg'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _deviceSize.height * .03,
                      ),
                      CustomButton(
                        text: const Text(
                          "Book Now",
                          style: TextStyle(
                            fontFamily: 'poPPinSemiBold',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        event: () {
                          // showBottomSheet(
                          //   context: context,
                          //   builder: (context) {
                          //     return const BottomSheetBookRide();
                          //   },
                          // );
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const BottomSheetBookRide();
                            },
                          );
                        },
                        buttonHeight: 50,
                        isRounded: true,
                        bgColor: black080809Color,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
