import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @mustNotEmpty.
  ///
  /// In en, this message translates to:
  /// **'The field must not be empty'**
  String get mustNotEmpty;

  /// No description provided for @loginFailure.
  ///
  /// In en, this message translates to:
  /// **'Login Failure'**
  String get loginFailure;

  /// No description provided for @emailHasBeenTaken.
  ///
  /// In en, this message translates to:
  /// **'Email has been taken'**
  String get emailHasBeenTaken;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @pickupCoordinateIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'pick up coordinate is empty'**
  String get pickupCoordinateIsEmpty;

  /// No description provided for @dropoffCoordinateIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'no destination has been selected.'**
  String get dropoffCoordinateIsEmpty;

  /// No description provided for @taxiTypeNotSelected.
  ///
  /// In en, this message translates to:
  /// **'taxi type not selected'**
  String get taxiTypeNotSelected;

  /// No description provided for @paymentMethodNotSelected.
  ///
  /// In en, this message translates to:
  /// **'payment method is not selected'**
  String get paymentMethodNotSelected;

  /// No description provided for @failedToCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'failed to create order'**
  String get failedToCreateOrder;

  /// No description provided for @failedToCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'failed to cancel order'**
  String get failedToCancelOrder;

  /// No description provided for @failedToChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'failed to change email'**
  String get failedToChangeEmail;

  /// No description provided for @failedToChangeProfile.
  ///
  /// In en, this message translates to:
  /// **'failed to change profile'**
  String get failedToChangeProfile;

  /// No description provided for @confirmationEmailNotSame.
  ///
  /// In en, this message translates to:
  /// **'confirmation email not same'**
  String get confirmationEmailNotSame;

  /// No description provided for @pwdResetFail.
  ///
  /// In en, this message translates to:
  /// **'password reset failed'**
  String get pwdResetFail;

  /// No description provided for @confirmationPwdNotMatch.
  ///
  /// In en, this message translates to:
  /// **'confirmation password not match'**
  String get confirmationPwdNotMatch;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get failed;

  /// No description provided for @currentPwdIncorrect.
  ///
  /// In en, this message translates to:
  /// **'current password is incorrect'**
  String get currentPwdIncorrect;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Email address is invalid'**
  String get emailInvalid;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number is invalid'**
  String get phoneInvalid;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'signup'**
  String get signup;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @pleaseEnterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterYourEmailAddress;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'taxi app'**
  String get appName;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get profile;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @we.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get we;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @callTaxi.
  ///
  /// In en, this message translates to:
  /// **'Call a taxi'**
  String get callTaxi;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @chooseTaxi.
  ///
  /// In en, this message translates to:
  /// **'Choose a taxi'**
  String get chooseTaxi;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get selectPaymentMethod;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash payment'**
  String get cash;

  /// No description provided for @creditDebit.
  ///
  /// In en, this message translates to:
  /// **'Credit / debit payment'**
  String get creditDebit;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'change photo'**
  String get changePhoto;

  /// No description provided for @doYouWantToChangeIt.
  ///
  /// In en, this message translates to:
  /// **'change it?'**
  String get doYouWantToChangeIt;

  /// No description provided for @emailAddressChange.
  ///
  /// In en, this message translates to:
  /// **'e-mail address change'**
  String get emailAddressChange;

  /// No description provided for @pleaseEnterNewEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new email address'**
  String get pleaseEnterNewEmailAddress;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'please try again'**
  String get pleaseTryAgain;

  /// No description provided for @reEnterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'re-enter email address'**
  String get reEnterEmailAddress;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @taxiType.
  ///
  /// In en, this message translates to:
  /// **'taxi type'**
  String get taxiType;

  /// No description provided for @historyDetail.
  ///
  /// In en, this message translates to:
  /// **'history detail'**
  String get historyDetail;

  /// No description provided for @thereAreNoPastOrders.
  ///
  /// In en, this message translates to:
  /// **'There are no past orders'**
  String get thereAreNoPastOrders;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @startingPoint.
  ///
  /// In en, this message translates to:
  /// **'Starting point'**
  String get startingPoint;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @typeOfTaxi.
  ///
  /// In en, this message translates to:
  /// **'Type of taxi'**
  String get typeOfTaxi;

  /// No description provided for @meter.
  ///
  /// In en, this message translates to:
  /// **'meter'**
  String get meter;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'select image source'**
  String get selectImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'gallery'**
  String get gallery;

  /// No description provided for @wouldYouLikeToCancel.
  ///
  /// In en, this message translates to:
  /// **'Would you like to cancel?'**
  String get wouldYouLikeToCancel;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @wouldYouLikeLogout.
  ///
  /// In en, this message translates to:
  /// **'Would you like to log out?'**
  String get wouldYouLikeLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @registerSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'register successfully'**
  String get registerSuccessfully;

  /// No description provided for @successfullyRegistered.
  ///
  /// In en, this message translates to:
  /// **'successfully registered'**
  String get successfullyRegistered;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get origin;

  /// No description provided for @orderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'order created successfully'**
  String get orderCreatedSuccessfully;

  /// No description provided for @orderCanceled.
  ///
  /// In en, this message translates to:
  /// **'Was canceled'**
  String get orderCanceled;

  /// No description provided for @emailAddressChanged.
  ///
  /// In en, this message translates to:
  /// **'email address changed'**
  String get emailAddressChanged;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'profile updated'**
  String get profileUpdated;

  /// No description provided for @pwdReset.
  ///
  /// In en, this message translates to:
  /// **'password reset successfully, check your email'**
  String get pwdReset;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @currentPwd.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPwd;

  /// No description provided for @newPwd.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPwd;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'confirm password'**
  String get confirmPassword;

  /// No description provided for @enterYourNewPwd.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get enterYourNewPwd;

  /// No description provided for @didTheTaxiArrive.
  ///
  /// In en, this message translates to:
  /// **'Did the taxi arrived?'**
  String get didTheTaxiArrive;

  /// No description provided for @haveYouArrivedAt.
  ///
  /// In en, this message translates to:
  /// **'did you arrive at your destination?'**
  String get haveYouArrivedAt;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'thank you'**
  String get thankYou;

  /// No description provided for @yourSessionHasExpired.
  ///
  /// In en, this message translates to:
  /// **'your session has expired'**
  String get yourSessionHasExpired;

  /// No description provided for @tokenIsExpired.
  ///
  /// In en, this message translates to:
  /// **'token is expired'**
  String get tokenIsExpired;

  /// No description provided for @pleaseLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'please login again !'**
  String get pleaseLoginAgain;

  /// No description provided for @redTaxi.
  ///
  /// In en, this message translates to:
  /// **'red taxi'**
  String get redTaxi;

  /// No description provided for @yellowTaxi.
  ///
  /// In en, this message translates to:
  /// **'yellow taxi'**
  String get yellowTaxi;

  /// No description provided for @blueTaxi.
  ///
  /// In en, this message translates to:
  /// **'blue taxi'**
  String get blueTaxi;

  /// No description provided for @reTypeNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password (type again to confirm)'**
  String get reTypeNewPassword;

  /// No description provided for @seater.
  ///
  /// In en, this message translates to:
  /// **'seater'**
  String get seater;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @gotDriver.
  ///
  /// In en, this message translates to:
  /// **'Got a driver'**
  String get gotDriver;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get people;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @thankYouForUsingOurService.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using our service'**
  String get thankYouForUsingOurService;

  /// No description provided for @weLookingForwardToSeeYouAgain.
  ///
  /// In en, this message translates to:
  /// **'We looking forward to see you again.'**
  String get weLookingForwardToSeeYouAgain;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait.'**
  String get pleaseWait;

  /// No description provided for @youGetTaxi.
  ///
  /// In en, this message translates to:
  /// **'The driver will pick you up.'**
  String get youGetTaxi;

  /// No description provided for @platNumber.
  ///
  /// In en, this message translates to:
  /// **'vehicle number'**
  String get platNumber;

  /// No description provided for @carModel.
  ///
  /// In en, this message translates to:
  /// **'Car model'**
  String get carModel;

  /// No description provided for @newEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter new email address'**
  String get newEmailAddress;

  /// No description provided for @newEmailAddressConfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter again to confirm'**
  String get newEmailAddressConfirm;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @driverName.
  ///
  /// In en, this message translates to:
  /// **'Driver name'**
  String get driverName;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @decideOnThePlace.
  ///
  /// In en, this message translates to:
  /// **'Decide on this place'**
  String get decideOnThePlace;

  /// No description provided for @departToCustomerPlace.
  ///
  /// In en, this message translates to:
  /// **'Depart to customer place'**
  String get departToCustomerPlace;

  /// No description provided for @arriveAtCustomerPlace.
  ///
  /// In en, this message translates to:
  /// **'Arrive at customer place'**
  String get arriveAtCustomerPlace;

  /// No description provided for @departToDestination.
  ///
  /// In en, this message translates to:
  /// **'Depart to destination'**
  String get departToDestination;

  /// No description provided for @arriveAtDestination.
  ///
  /// In en, this message translates to:
  /// **'Arrive at destination'**
  String get arriveAtDestination;

  /// No description provided for @weAreArrangingTaxiNow.
  ///
  /// In en, this message translates to:
  /// **'We are arranging a taxi right now.'**
  String get weAreArrangingTaxiNow;

  /// No description provided for @waitingCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Waitong for get your current location'**
  String get waitingCurrentLocation;

  /// No description provided for @textLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure\nyou want to log out of this account ?'**
  String get textLogout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
