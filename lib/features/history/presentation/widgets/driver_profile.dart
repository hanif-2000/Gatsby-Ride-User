import 'package:GetsbyRideshare/core/presentation/widgets/cache_network_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/socket/deryde_folder/chat/provider/test_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../../../core/utility/dynamic_toasstring_helper.dart';

class DriverProfileWidget extends StatefulWidget {
  final String category;
  final String driverId;
  final String driverName;
  final String driverImage;
  final dynamic rating;
  final String platerNumber;

  final VoidCallback? onClickOnReview;

  const DriverProfileWidget({
    Key? key,
    required this.category,
    required this.driverId,
    required this.driverName,
    required this.driverImage,
    required this.rating,
    required this.platerNumber,
    this.onClickOnReview,
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

    return Consumer<TestSocketProvider>(builder: (context, provider, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomCacheNetworkImage(img: widget.driverImage, size: 40),
                // widget.driverImage == ''
                //     ? CircleAvatar(
                //         backgroundColor: transparentColor,
                //         radius: 20,
                //         backgroundImage: AssetImage(userAvatarImage),
                //       )
                //     : CachedNetworkImage(
                //         imageUrl: mergePhotoUrl(widget.driverImage),
                //         imageBuilder: (context, imageProvider) => Container(
                //           height: 40,
                //           width: 40,
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             image: DecorationImage(
                //               image: imageProvider,
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //         progressIndicatorBuilder: (context, url, progress) {
                //           return CircularProgressIndicator(
                //             value: progress.progress,
                //           );
                //         },
                //         errorWidget: (context, url, error) => Icon(Icons.error),
                //       ),

                // CircleAvatar(
                //   backgroundImage: NetworkImage(widget.driverImage == ''
                //       ? 'https://picsum.photos/250?image=9'
                //       : mergePhotoUrl(widget.driverImage)),
                // ),
                Padding(
                  padding: EdgeInsets.only(left: _deviceSize.width * .02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.driverName,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset('assets/icons/filled_star.svg'),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              // double.tryParse(widget.rating).toString(),
                              convertToFixedOneDecimal(widget.rating),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: widget.onClickOnReview,
                            child: const Text(
                              "Reviews",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: yellowE6B045Color,
                              ),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.category,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.platerNumber,
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

