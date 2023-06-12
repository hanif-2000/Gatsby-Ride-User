import 'package:appkey_taxiapp_user/core/presentation/providers/place_picker_provider.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_search_bar.dart';

class AutoCompleteAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AutoCompleteAppBar({
    Key? key,
  }) : super(key: key);

  static late PlacePickerProvider provider;

  @override
  Widget build(BuildContext context) {
    try {
      provider = Provider.of(context);

      return SafeArea(
        child: Column(
          children: [
            AppBar(
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
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomSearchBar(
                      controller: provider.controller,
                      showLeading: false,
                      height: kToolbarHeight - 12,
                      onSubmitted: (String query) async {
                        await provider.fetchGooglePlaces();
                      },
                      onChanged: (String _) {
                        provider.changeValue = provider.controller.text;
                        if (provider.textFieldIsEmpty) {}
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      logMe(e);
      return SizedBox.fromSize();
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
