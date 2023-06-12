import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';

import '../../../static/assets.dart';
import '../../../static/styles.dart';
import '../rounded_container.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final Function(bool focus)? onFocus;
  final void Function(String)? onSubmitted;
  final void Function()? onCleared;
  final FocusNode? focusNode;
  final VoidCallback? onSearch;
  final void Function(String)? onChanged;
  final bool enabled;
  final double height;
  final String? hint;
  final bool showLeading;
  const CustomSearchBar({
    Key? key,
    this.controller,
    this.onSearch,
    this.enabled = true,
    this.height = 48.0,
    this.onFocus,
    this.focusNode,
    this.hint,
    this.showLeading = true,
    this.onSubmitted,
    this.onCleared,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      height: height,
      color: whiteColor,
      shadow: true,
      child: Focus(
        onFocusChange: onFocus,
        child: TextField(
          enabled: enabled,
          focusNode: focusNode,
          controller: controller,
          textInputAction: TextInputAction.search,
          onEditingComplete: onSearch,
          onChanged: onChanged,
          style: searchBarInputTextStyle,
          textAlignVertical: TextAlignVertical.center,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0.0),
            border: InputBorder.none,
            isDense: true,
            prefixIcon: Icon(
              Icons.search_rounded,
              size: height / 1.5,
            ),
            prefixIconColor: Colors.grey,
            hintText: appLoc.search,
            hintStyle: searchBarHintTextStyle,
            suffixIcon: IconButton(
              splashRadius: 20.0,
              padding: const EdgeInsets.all(2.0),
              onPressed: () {
                controller?.clear();
                onCleared!();
              },
              icon: Icon(
                Icons.cancel_sharp,
                size: height / 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
