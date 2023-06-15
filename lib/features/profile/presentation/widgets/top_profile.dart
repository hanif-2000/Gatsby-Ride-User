import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/presentation/widgets/dynamic_network_image.dart';
import '../../../../core/utility/helper.dart';
import '../../data/models/profile_response_model.dart';

class TopProfile extends StatefulWidget {
  final User data;

  const TopProfile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<TopProfile> createState() => _TopProfileState();
}

class _TopProfileState extends State<TopProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: 140,
                        height: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: DynamicCachedNetworkImage(
                            imageUrl: mergePhotoUrl(widget.data.photo ?? ''),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: Container(
                        child: Row(
                          children: [
                            Center(
                                child:
                                    SvgPicture.asset('assets/icons/edit.svg')),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                  fontFamily: "poPPinMedium",
                                  fontSize: 15.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
