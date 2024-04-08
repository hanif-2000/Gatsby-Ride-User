import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreditCardTile extends StatelessWidget {
  final String assets;
  final String title;
  final Function onTap;
  final VoidCallback onDeleteTap;
  bool selected;

  CreditCardTile(
      {Key? key,
      required this.assets,
      required this.title,
      required this.selected,
      required this.onTap,
      required this.onDeleteTap,
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return Consumer<HomeProvider>(builder: (context, provider, _) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, // Your desired background color
            borderRadius: BorderRadius.circular(11),
            boxShadow: const [
              BoxShadow(
                color: whiteF2F2F2Color,
                blurRadius: 20,
                spreadRadius: 20.0,
                offset: Offset(0, 15),
              ),
            ]),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0),
            // side: const BorderSide(
            //   width: 1.0,
            //   color: blackColor,
            // ),
          ),
          tileColor: whiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 10.0, right: 20.0),
                child: SvgPicture.asset(
                  assets,
                  width: 43,
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: AutoSizeText(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16.0),
                  minFontSize: 10,
                  maxLines: 1,
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  selected
                      ? const Icon(
                          Icons.check_box,
                          size: 26,
                          color: green9ADB59Color,
                        )
                      : const Text(''),
                ],
              )),
              SizedBox(height: 10,width: 10,),
              InkWell(
                onTap: onDeleteTap,
                  child: Icon(Icons.delete_forever_outlined,color: Colors.redAccent,)) ,

            ],
          ),
          onTap: () => onTap(),
        ),
      ),
    );
    // });
  }
}
