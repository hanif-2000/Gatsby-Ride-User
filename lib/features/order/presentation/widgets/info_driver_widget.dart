import 'package:GetsbyRideshare/core/types/fonts.dart';
import 'package:GetsbyRideshare/socket/deryde_folder/chat/provider/test_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/rounded_upper_container.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';

class DriverInfoWidget extends StatelessWidget {
  const DriverInfoWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<TestSocketProvider>(builder: (context, provider, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: FloatingActionButton(
              child: const Icon(
                Icons.person_pin,
                color: Colors.grey,
                size: 40,
              ),
              backgroundColor: Colors.white,
              onPressed: () async {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (context) {
                      return RoundedUpperContainer(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              smallVerticalSpacing(),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  //***iamge and data */
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: CircleAvatar(
                                          backgroundImage:
                                              AssetImage(userAvatarImage),
                                          maxRadius: 15,
                                          minRadius: 15,
                                        ),
                                      ),
                                      mediumHorizontalSpacing(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          /** plate number */
                                          Text(
                                            provider.driverDetailResponseModel!
                                                .message.plateNumber
                                                .toString(),
                                            style: titlePlatStyle,
                                          ),
                                          /** driver model */

                                          Text(
                                            provider.driverDetailResponseModel!
                                                .message.carModel
                                                .toString(),
                                            style: titleModelStyle,
                                          ),
                                          Text(
                                            provider.driverDetailResponseModel!
                                                .message.name
                                                .toString(),
                                            style: TextStyle(
                                                    fontSize: 13,
                                                    color: greyBlackColor,
                                                    fontWeight: FontWeight.bold)
                                                .useHiraginoKakuW6Font(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  smallVerticalSpacing(),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  smallVerticalSpacing(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.my_location,
                                          color: primaryColor, size: 30),
                                      smallHorizontalSpacing(),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              appLoc.origin,
                                              style: TextStyle(
                                                      fontSize: 13,
                                                      color: greyBlackColor,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  .useHiraginoKakuW6Font(),
                                            ),
                                            Text(
                                              provider.originAddress,
                                              style: titleModelStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  mediumVerticalSpacing(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: primaryColor, size: 30),
                                      smallHorizontalSpacing(),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              appLoc.destination,
                                              style: TextStyle(
                                                      fontSize: 13,
                                                      color: greyBlackColor,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  .useHiraginoKakuW6Font(),
                                            ),
                                            Text(
                                              provider.destinationAddress,
                                              style: titleModelStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      );
    });
  }
}
