import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../order/presentation/providers/order_provider.dart';
import 'package:provider/provider.dart';

class DriverProfileWidget extends StatefulWidget {
  final String category;
  final String driverId;

  const DriverProfileWidget({
    Key? key,
    required this.category,
    required this.driverId,
  }) : super(key: key);

  @override
  State<DriverProfileWidget> createState() => _DriverProfileWidgetState();
}

class _DriverProfileWidgetState extends State<DriverProfileWidget> {
  @override
  void initState() {
    super.initState();
  }

  fetchDriverProfileData() {
    // Provider.of<OrderProvider>(context).
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;

    return Consumer<OrderProvider>(builder: (context, provider, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(),
                Padding(
                  padding: EdgeInsets.only(left: _deviceSize.width * .02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Driver Name",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset('assets/icons/filled_star.svg'),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "4.5",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Text(
                            "Reviews",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: yellowE6B045Color,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Text(
                      widget.category,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(
                      "Car Number",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
//   }
// }
    });
  }
}

// class DriverProfileWidget extends StatefullWidget {
//   final String category;

//   final String driverId;
//   const DriverProfileWidget({
//     Key? key,
//     required this.category,
//     required this.driverId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var _deviceSize = MediaQuery.of(context).size;
//     return Consumer<OrderProvider>(builder: (context, provider, _) {
//       return const Text("sdf");
//     });

//     // Row(
//     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //   children: [
//     //     Flexible(
//     //       flex: 2,
//     //       child: Row(
//     //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //         children: [
//     //           const CircleAvatar(),
//     //           Padding(
//     //             padding: EdgeInsets.only(left: _deviceSize.width * .02),
//     //             child: Column(
//     //               crossAxisAlignment: CrossAxisAlignment.start,
//     //               children: [
//     //                 const Text(
//     //                   "Driver Name",
//     //                   style: TextStyle(
//     //                     fontSize: 16.0,
//     //                     fontWeight: FontWeight.w500,
//     //                   ),
//     //                 ),
//     //                 Row(
//     //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                   children: [
//     //                     SvgPicture.asset('assets/icons/filled_star.svg'),
//     //                     const Padding(
//     //                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//     //                       child: Text(
//     //                         "4.5",
//     //                         style: TextStyle(
//     //                           fontSize: 14.0,
//     //                           fontWeight: FontWeight.w600,
//     //                         ),
//     //                       ),
//     //                     ),
//     //                     const Text(
//     //                       "Reviews",
//     //                       style: TextStyle(
//     //                         decoration: TextDecoration.underline,
//     //                         fontSize: 14.0,
//     //                         fontWeight: FontWeight.w500,
//     //                         color: yellowE6B045Color,
//     //                       ),
//     //                     )
//     //                   ],
//     //                 ),
//     //               ],
//     //             ),
//     //           ),
//     //         ],
//     //       ),
//     //     ),
//     //     Flexible(
//     //       flex: 2,
//     //       child: Row(
//     //         mainAxisAlignment: MainAxisAlignment.end,
//     //         children: [
//     //           Column(
//     //             children: [
//     //               Text(
//     //                 category,
//     //                 style: const TextStyle(
//     //                   fontSize: 12.0,
//     //                   fontWeight: FontWeight.w400,
//     //                 ),
//     //               ),
//     //               const Text(
//     //                 "Car Number",
//     //                 style: TextStyle(
//     //                   fontSize: 12.0,
//     //                   fontWeight: FontWeight.w500,
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //         ],
//     //       ),
//     //     )
//     //   ],
//     // );
//   }
// }

