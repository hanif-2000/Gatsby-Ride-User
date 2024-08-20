import 'dart:developer';

import 'package:GetsbyRideshare/core/static/assets.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/enums.dart';

import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'dart:developer' as dev;

import '../../../domain/entities/google_places.dart';
import '../../providers/place_auto_complete_state.dart';
import '../../providers/place_picker_provider.dart';
import '../../widgets/place_result_item.dart';
import '../../widgets/search_bar/custom_search_bar.dart';

class PlacePickerPage extends StatefulWidget {
  final LatLng latLng;
  final AddressType addressType;
  final String address;
  const PlacePickerPage(
      {Key? key,
      required this.latLng,
      required this.addressType,
      required this.address})
      : super(key: key);
  static const routeName = '/place_picker';

  @override
  State<PlacePickerPage> createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
  }

  _displayOverlay(Widget overlayChild) {
    dev.log("Display overlay called");
    _clearOverlay();
    final screenWidth = MediaQuery.of(context).size.width;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight * 2.1,
        left: screenWidth * 0.055,
        right: screenWidth * 0.055,
        child: Material(
          elevation: 4.0,
          child: overlayChild,
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  clearOverlay() {
    _clearOverlay();
  }

  _clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return ChangeNotifierProvider(
        create: (_) => locator<PlacePickerProvider>()..setupCurrentLatLongValues(widget.latLng, widget.address, widget.addressType),
        builder: (context, child) {
          return Consumer<PlacePickerProvider>(builder: (context, provider, _) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                iconTheme: Theme.of(context).iconTheme,
                elevation: 0,
                backgroundColor: Colors.transparent,
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: IconButton(
                        onPressed: () {
                          _clearOverlay();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomSearchBar(
                        onCleared: () {
                          clearOverlay();
                        },
                        controller: provider.controller,
                        showLeading: false,
                        height: kToolbarHeight - 12,
                        onSubmitted: (String query) async {
                          dev.log("search query is -->> $query");
                          _displayOverlay(buildSearchingOverlay());
                           await provider.fetchGooglePlaces();
                          if (provider.state.runtimeType == PlaceAutoLoaded) {
                            final data = (provider.state as PlaceAutoLoaded).data;
                            _displayOverlay(buildPredictionOverlay(data, context));
                          }
                        },
                        onChanged: (String val) async {
                          dev.log("onchnaged called on search $val");
                          provider.changeValue = provider.controller.text;
                          if (provider.textFieldIsEmpty) {
                            _clearOverlay();
                          }
                          dev.log("search val onchanged is -->> $val");
                          _displayOverlay(buildSearchingOverlay());
                          await provider.fetchGooglePlaces();
                          if (provider.state.runtimeType == PlaceAutoLoaded) {
                            final data =
                                (provider.state as PlaceAutoLoaded).data;
                            _displayOverlay(
                                buildPredictionOverlay(data, context));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  //show background google maps
                  Listener(
                    onPointerMove: (event) {
                      provider.updateIsSearch(val: false);
                      dev.log("On pointer moved called");
                    },
                    child: GoogleMap(
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: widget.addressType == AddressType.origin
                            ? provider.originLatLng
                            : provider.destinationLatLng,
                        zoom: 18.0,
                      ),
                      mapType: MapType.normal,
                      onMapCreated: (controller) {
                        provider.googleMapController = controller;
                      },
                      onCameraMove: (CameraPosition cameraPositiona) {
                        provider.cameraPosition = cameraPositiona;
                      },
                      onCameraIdle: () async {
                        dev.log("On CAMERA ideal called");
                        if (provider.cameraPosition != null) {
                          provider.setAddressLoad(true);

                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                  provider.cameraPosition!.target.latitude,
                                  provider.cameraPosition!.target.longitude);

                          log("placemark from coordinates:-->> $placemarks");
                          if (widget.addressType == AddressType.origin) {
                            FocusScope.of(context).unfocus();

                            provider.setOriginAddress =
                                "${placemarks.first.name}, ${placemarks.first.locality}";

                            provider.setAddressLoad(false);
                          } else {
                            provider.setDestinationAddress = "${placemarks.first.name}, ${placemarks.first.locality}";
                            provider.setAddressLoad(false);
                            FocusScope.of(context).unfocus();
                          }
                        }
                      },
                    ),
                  ),

                  Center(
                    child: Image.asset(
                      widget.addressType == AddressType.origin
                          ? initialPickUpIcon
                          : destinationIcon,
                      width: 100,
                    ),
                  ),

                  //Bottom Section
                  Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      // height: queryData.size.height * 0.3,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 8.0),
                                child: provider.isCurrentLoading
                                    ? FloatingActionButton(
                                        child: const CircularProgressIndicator(
                                            strokeWidth: 3),
                                        backgroundColor: Colors.white,
                                        onPressed: () {},
                                      )
                                    : FloatingActionButton(
                                        child: const Icon(
                                            Icons.my_location_rounded,
                                            color: Colors.grey,
                                            size: 35),
                                        backgroundColor: Colors.white,
                                        onPressed: () async {
                                          clearOverlay();
                                          provider.setCurrentLoad();
                                          await provider.getCurrentLocation();
                                        },
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: queryData.size.height * 0.16,
                            child: Material(
                              type: MaterialType.canvas,
                              color: whiteColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  side: BorderSide(color: Colors.transparent)),
                              elevation: 0.0,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: GestureDetector(
                                        onTap: () {
                                          dev.log("address on tap called");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: provider.isAddressLoading
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : AutoSizeText(
                                                    // "sdf",
                                                    provider.addressSelected,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                    minFontSize: 10,
                                                    maxLines: 3,
                                                    textAlign: TextAlign.center,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //Select this place button
                                    Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                provider.isAddressLoading
                                                    ? Colors.grey
                                                    : blackColor,
                                              ),
                                            ),
                                            onPressed: () {
                                              dev.log(
                                                  "on pressed called -------->>>..");
                                              if (!provider.isAddressLoading) {
                                                if (widget.addressType ==
                                                    AddressType.origin) {
                                                  clearOverlay();
                                                  Navigator.pop(context,
                                                      provider.placeDataOrigin);
                                                } else {
                                                  clearOverlay();
                                                  Navigator.pop(
                                                      context,
                                                      provider
                                                          .placeDataDestination);
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                    child: Center(
                                                        child: AutoSizeText(
                                                  "Select this place",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                )))
                                              ],
                                            ),
                                          ),
                                        )),

                                    // SizedBox(
                                    //   height:
                                    //       MediaQuery.of(context).size.width *
                                    //           .02,
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            );
          });
        });
  }

  Widget buildSearchingOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              appLoc.search,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPredictionOverlay(
      List<GooglePlaceSearch> predictions, BuildContext ctxConsumer) {
    var provider = Provider.of<PlacePickerProvider>(ctxConsumer, listen: false);
    if (predictions.length > 4) {
      return SingleChildScrollView(
        child: SizedBox(
            height: 250,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return PlaceResultItem(
                  name: mergeAddress(predictions[index].name,
                      predictions[index].formattedAddress),
                  onTap: () async {
                    provider.updateIsSearch(val: true);

                    provider.updateOriginTextShow(mergeAddress(
                        predictions[index].name,
                        predictions[index].formattedAddress));
                    dev.log("On Tap on predict location called");
                    FocusScope.of(context).unfocus();
                    provider.clearController();

                    dev.log("lat: ${predictions[index].geometry.location}");
                    // setOriginAddress();
                    // provider.updateOriginTextShow(mergeAddress(
                    //     predictions[index].name,
                    //     predictions[index].formattedAddress));

                    dev.log(
                        mergeAddress(predictions[index].name,
                                predictions[index].formattedAddress)
                            .toString(),
                        name: "Ankit");
                    provider.addressSelected = mergeAddress(
                            predictions[index].name,
                            predictions[index].formattedAddress)
                        .toString();
                    clearOverlay();
                    provider.googleMapController.moveCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(
                                predictions[index].geometry.location.lat,
                                predictions[index].geometry.location.lng),
                            zoom: 18)));
                    provider.cameraPosition = CameraPosition(
                        target: LatLng(predictions[index].geometry.location.lat,
                            predictions[index].geometry.location.lng),
                        zoom: 18);
                    FocusScope.of(context).unfocus();
                  },
                );
              },
              itemCount: predictions.length,
            )),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return PlaceResultItem(
            name: mergeAddress(
                predictions[index].name, predictions[index].formattedAddress),
            onTap: () async {
              provider.updateIsSearch(val: true);

              provider.updateOriginTextShow(mergeAddress(
                  predictions[index].name,
                  predictions[index].formattedAddress));
              dev.log("On Tap on when item < 4predict location called");
              FocusScope.of(context).unfocus();
              provider.clearController();

              dev.log("lat: ${predictions[index].geometry.location}");
              clearOverlay();
              provider.googleMapController.moveCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(predictions[index].geometry.location.lat,
                          predictions[index].geometry.location.lng),
                      zoom: 18)));
              provider.cameraPosition = CameraPosition(
                  target: LatLng(predictions[index].geometry.location.lat,
                      predictions[index].geometry.location.lng),
                  zoom: 18);
            },
          );
        },
        itemCount: predictions.length,
      );
    }
  }
}
