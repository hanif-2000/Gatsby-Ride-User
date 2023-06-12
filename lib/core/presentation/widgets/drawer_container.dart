import 'package:flutter/material.dart';

class DrawerContainerWidget extends StatelessWidget {
  const DrawerContainerWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: children,
          ),
        ),
      ),
    );
  }
}