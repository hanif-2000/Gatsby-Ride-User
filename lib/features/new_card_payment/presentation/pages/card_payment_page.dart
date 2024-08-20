import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/features/new_card_payment/presentation/providers/add_card_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/widgets/add_new_card_popup.dart';
import '../../../../core/presentation/widgets/credit_card_tile_wisget.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/utility/helper.dart';
import '../providers/card_list_state.dart';
import '../providers/payment_provider.dart';

class CardPaymentExpansionTile extends StatefulWidget {
  final String assets;
  final String title;
  final Function onTap;
  final bool selected;
  final HomeProvider provider;

  const CardPaymentExpansionTile(
      {Key? key,
      required this.assets,
      required this.title,
      required this.selected,
      required this.provider,
      required this.onTap})
      : super(key: key);

  @override
  State<CardPaymentExpansionTile> createState() => _CardPaymentExpansionTileState();
}

class _CardPaymentExpansionTileState extends State<CardPaymentExpansionTile> {
  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return ExpansionTile(
        onExpansionChanged: (value) {},
        maintainState: true,
        childrenPadding: EdgeInsets.zero,
        shape: const Border(),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: SvgPicture.asset(
            widget.assets,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        trailing: provider.paymentMethod == PaymentMethod.creditCard
            ? const Icon(
                Icons.radio_button_on_outlined,
                color: yellowE5A829Color,
                size: 30,
              )
            : Icon(
                Icons.radio_button_off_outlined,
                color: greyB6B6B6Color,
                size: 30,
              ),
        title: const Text(
          "Debit/Credit Card",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: blackColor,
          ),
        ),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.0),
            ),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    /******    Show List of Cards */

                    StreamBuilder<CardListState>(
                        initialData: CardListLoading(),
                        stream: context.read<PaymentProvider>().fetchCardListData(),
                        builder: (context, state) {
                          switch (state.data.runtimeType) {
                            case CardListLoading:
                              return const Center(child: CircularProgressIndicator());
                            case CardListFailure:
                              final failure = (state.data as CardListFailure).failure;
                              showToast(message: failure);
                              return const SizedBox.shrink();
                            case CardListSuccess:
                              final _data = (state.data as CardListSuccess).data;
                              log("my card list data is" + _data.data.toString());
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _data.data.length,
                                itemBuilder: (context, index) {
                                  return CreditCardTile(
                                      title:
                                          "*** *** *** ${_data.data[index].cardNumber.substring(_data.data[index].cardNumber.length - 4)}",
                                      assets: 'assets/icons/logos_mastercard.svg',
                                      onTap: () {
                                        var selectedCardId = _data.data[index].id;

                                        log("selected card id is--->>>$selectedCardId");

                                        context.read<PaymentProvider>().updateSelectedCardId(selectedCardId);

                                        context.read<PaymentProvider>().updateSelectedCard(cardNo: _data.data[index].cardNumber, expiry: _data.data[index].expiryDate);

                                        provider.setPaymentMethod = PaymentMethod.creditCard;

                                        log("new card id is====>>${context.read<PaymentProvider>().selectedCardId}");

                                        // provider.setPaymentMethod =
                                        //     PaymentMethod.creditCard;
                                        // Navigator.pop(context);
                                      },
                                      selected: provider.paymentMethod != PaymentMethod.creditCard
                                          ? false
                                          : (context.read<PaymentProvider>().selectedCardId == _data.data[index].id)
                                              ? true
                                              : false,
                                    onDeleteTap: (){
                                        print("object");
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) => DeleteConfirmationDialog(_data.data[index].id),
                                      ).then((value) {
                                        if(value){
                                          setState(() {

                                          });
                                        }
                                      });


                                    },

                                      );
                                },
                              );
                          }
                          return const SizedBox.shrink();
                        }),

                    /** Add New Card  */
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                content: AddNewCardPopUp());
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: whiteF2F2F2Color,
                            borderRadius: BorderRadius.circular(11.0),
                            // Your desired background color

                            boxShadow: const [
                              BoxShadow(
                                color: whiteF2F2F2Color,
                                blurRadius: 20,
                                spreadRadius: 20.0,
                                offset: Offset(0, 15),
                              ),
                            ]),
                        alignment: Alignment.center,
                        height: _deviceSize.height * .1,
                        child: const Text(
                          "+ Add New Card",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                          ),
                        ),
                      ),
                    ),
                    // ],
                    // ),
                  ],
                )


                ),
          )

        ],
      );


    });
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final int id;
  DeleteConfirmationDialog(this.id);
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Delete Card'),
      content: Text('Are you sure you want to delete this card?',style: TextStyle(
          fontWeight: FontWeight.w600,fontSize: 16),),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false); // Return false indicating cancel
          },
          textStyle: TextStyle(color: CupertinoColors.activeBlue),
        ),
        CupertinoDialogAction(
          child: Text('Delete'),
          onPressed: () {
            context.read<PaymentProvider>().deleteCard(id).listen((event)async{
              switch (event.runtimeType) {
                case DeleteCardLoading:
                  showLoading();
                  break;
                case DeleteCardFailure:
                  final msg = (event as DeleteCardFailure).failure;
                  dismissLoading();
                  Navigator.of(context).pop(true);
                  showToast(message: msg);
                  break;
                case DeleteCardSuccess:
                  final data = (event as DeleteCardSuccess).data;
                  dismissLoading();
                  Navigator.of(context).pop(true);
                  break;
              }


            });// Return true indicating delete
          },
          isDestructiveAction: true,
        ),
      ],
    );
  }
}

