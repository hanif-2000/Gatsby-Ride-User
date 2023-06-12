import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/dynamic_network_image.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.data.name,
              style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(widget.data.email,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 17)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(widget.data.phone,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 17)),
          )
        ],
      ),
    );
  }
}
