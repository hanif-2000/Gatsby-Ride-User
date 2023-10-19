import 'package:GetsbyRideshare/features/contact_us/data/datasources/contactus_data_source.dart';
import 'package:GetsbyRideshare/features/contact_us/data/repositories/contactus_repository_implementation.dart';
import 'package:GetsbyRideshare/features/contact_us/domain/repositories/contactus_repository.dart';
import 'package:GetsbyRideshare/features/contact_us/domain/usecases/get_contactus.dart';
import 'package:GetsbyRideshare/features/contact_us/presentation/providers/contactus_provider.dart';
import 'package:GetsbyRideshare/features/forgot_password/data/datasources/otp_verification_data_source.dart';
import 'package:GetsbyRideshare/features/forgot_password/domain/repositories/otp_verification_repository.dart';
import 'package:GetsbyRideshare/features/forgot_password/domain/usecases/otp_verification.dart';
import 'package:GetsbyRideshare/features/forgot_password/presentation/providers/otp_verification_provider.dart';
import 'package:GetsbyRideshare/features/history/domain/usecases/get_ratings.dart';
import 'package:GetsbyRideshare/features/new_card_payment/data/datasources/payment_data_source.dart';
import 'package:GetsbyRideshare/features/new_card_payment/domain/repositories/payment_repository.dart';
import 'package:GetsbyRideshare/features/new_card_payment/domain/usecases/payment_usercases.dart';
import 'package:GetsbyRideshare/features/new_card_payment/presentation/providers/payment_provider.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/submit_ratings.dart';
import 'package:GetsbyRideshare/features/profile/data/datasources/create_profile_data_source.dart';
import 'package:GetsbyRideshare/features/profile/data/datasources/upload_profile_image_data_source.dart';
import 'package:GetsbyRideshare/features/profile/data/repositories/upload_profile_image_repository_implementation.dart';
import 'package:GetsbyRideshare/features/profile/domain/repositories/create_profile_repository.dart';
import 'package:GetsbyRideshare/features/profile/domain/usecases/create_profile.dart';
import 'package:GetsbyRideshare/features/profile/domain/usecases/upload_profile_image.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/create_profile_provider.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/upload_profile_image_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/about_us/data/datasources/aboutus_data_source.dart';
import '../../features/about_us/data/repositories/aboutus_repository_implementation.dart';
import '../../features/about_us/domain/repositories/aboutus_repository.dart';
import '../../features/about_us/domain/usecases/get_aboutus.dart';
import '../../features/about_us/presentation/providers/aboutus_provider.dart';
import '../../features/forgot_password/data/datasources/forgot_password_data_source.dart';
import '../../features/forgot_password/data/repositories/forgot_password_repository_implementation.dart';
import '../../features/forgot_password/data/repositories/otp_verify_repository_implementation.dart';
import '../../features/forgot_password/domain/repositories/forgot_password_repository.dart';
import '../../features/forgot_password/domain/usecases/do_forgot_password.dart';
import '../../features/forgot_password/presentation/providers/forgot_password_provider.dart';
import '../../features/history/data/datasources/history_data_source.dart';
import '../../features/history/data/repositories/profile_repository_implementation.dart';
import '../../features/history/domain/repositories/profile_repository.dart';
import '../../features/history/domain/usecases/get_history.dart';
import '../../features/history/presentation/providers/history_provider.dart';
import '../../features/login/data/datasources/login_data_source.dart';
import '../../features/login/data/repositories/login_repository_implementation.dart';
import '../../features/login/domain/repositories/login_repository.dart';
import '../../features/login/domain/usecases/do_login.dart';
import '../../features/login/presentation/providers/login_provider.dart';
import '../../features/new_card_payment/data/repositories/payment_repository_implementation.dart';
import '../../features/order/data/datasources/order_data_source.dart';
import '../../features/order/data/repositories/order_repository_implementation.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/domain/usecases/create_oder.dart';
import '../../features/order/domain/usecases/get_driver_detail.dart';
import '../../features/order/domain/usecases/get_driver_location.dart';
import '../../features/order/domain/usecases/get_order_detail.dart';
import '../../features/order/domain/usecases/get_receipt.dart';
import '../../features/order/domain/usecases/get_status_order.dart';
import '../../features/order/domain/usecases/update_status_order.dart';
import '../../features/order/presentation/providers/order_provider.dart';
import '../../features/profile/data/datasources/profile_data_source.dart';
import '../../features/profile/data/repositories/create_profile_repository_implementation.dart';
import '../../features/profile/data/repositories/profile_repository_implementation.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/update_email.dart';
import '../../features/profile/domain/usecases/update_password.dart';
import '../../features/profile/domain/usecases/update_profile.dart';
import '../../features/profile/presentation/providers/change_email_provider.dart';
import '../../features/profile/presentation/providers/change_password_provider.dart';
import '../../features/profile/presentation/providers/profile_edit_provider.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/register/data/datasources/register_data_source.dart';
import '../../features/register/data/repositories/register_repository_implementation.dart';
import '../../features/register/domain/repositories/register_repository.dart';
import '../../features/register/domain/usecases/do_register.dart';
import '../../features/register/presentation/providers/register_provider.dart';
import '../../socket/new_socket_provider.dart';
import '../data/datasources/currency_datasource.dart';
import '../data/datasources/place_text_search_datasource.dart';
import '../data/datasources/price_category_datasource.dart';
import '../data/datasources/total_price_datasource.dart';
import '../data/datasources/vehicles_category_datasource.dart';
import '../data/repositories/currency_repository_implementation.dart';
import '../data/repositories/google_place_repository_implementation.dart';
import '../data/repositories/price_cateogory_repository_implementation.dart';
import '../data/repositories/total_price_repository_implementation.dart';
import '../data/repositories/vehicle_catagory_repository_implementation.dart';
import '../domain/repositories/currency_repository.dart';
import '../domain/repositories/google_place_repository.dart';
import '../domain/repositories/price_category_repository.dart';
import '../domain/repositories/total_price_repository.dart';
import '../domain/repositories/vehicle_catagory_repository.dart';
import '../domain/usecases/get_currency.dart';
import '../domain/usecases/get_google_place.dart';
import '../domain/usecases/get_price_category.dart';
import '../domain/usecases/get_total_price.dart';
import '../domain/usecases/get_vehicle_catagory.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../presentation/providers/home_provider.dart';
import '../presentation/providers/place_picker_provider.dart';
import '../presentation/providers/splash_provider.dart';
import 'session_helper.dart';

late Locale myLocale;

late Session sessionHelper;
late bool isLoggedIn;

final locator = GetIt.instance;

Future<void> init() async {
  //network info
  locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplementation(locator<Connectivity>()));

  //external
  locator.registerLazySingleton<Dio>(() => DioClient().dio);
  locator.registerLazySingletonAsync<Session>(() async =>
      SessionHelper(pref: await locator.getAsync<SharedPreferences>()));
  locator.registerLazySingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
  locator.registerLazySingleton<GlobalKey<NavigatorState>>(
      () => GlobalKey<NavigatorState>());
  locator.registerLazySingleton<Connectivity>(() => Connectivity());
  locator.registerLazySingleton<GlobalKey<ScaffoldState>>(
      () => GlobalKey<ScaffoldState>());

  //repository
  locator.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImplementation(
      dataSource: locator<CurrencyDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  locator.registerLazySingleton<PriceCategoryRepository>(
    () => PriceCategoryRepositoryImplementation(
      dataSource: locator<PriceCategoryDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );

  locator.registerLazySingleton<VehiclesCategoryRepository>(
    () => VehiclesCategoryRepositoryImplementation(
      dataSource: locator<VehicleCategoryDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  locator.registerLazySingleton<TotalPriceRepository>(
    () => TotalPriceRepositoryImplementation(
      dataSource: locator<TotalPriceDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  locator.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImplementation(
      dataSource: locator<LoginDataSource>(),
    ),
  );
  locator.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImplementation(
      dataSource: locator<RegisterDataSource>(),
    ),
  );
  locator.registerLazySingleton<AboutUsRepository>(
    () => AboutUsRepositoryImplementation(
      dataSource: locator<AboutUsDataSource>(),
    ),
  );
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImplementation(
      dataSource: locator<ProfileDataSource>(),
    ),
  );
  locator.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImplementation(
      dataSource: locator<HistoryDataSource>(),
    ),
  );
  locator.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImplementation(
      dataSource: locator<ForgotPasswordDataSource>(),
    ),
  );
  locator.registerLazySingleton<OtpVerificationRepository>(
    () => OtpVerifyRepositoryImplementation(
      dataSource: locator<OtpVerificationDataSource>(),
    ),
  );
  locator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImplementation(
      dataSource: locator<OrderDataSource>(),
    ),
  );
  //   locator.registerLazySingleton<OrderRepository>(
  //   () => OrderRepositoryImplementation(
  //     dataSource: locator<OrderDataSource>(),
  //   ),
  // );

  locator.registerLazySingleton<CreateProfileRepository>(
    () => CreateProfileRepositoryImplementation(
      dataSource: locator<CreateProfileDataSource>(),
    ),
  );

  locator.registerLazySingleton<UploadProfileImageRepository>(
    () => UploadProfileImageRepositoryImplementation(
      dataSource: locator<UploadProfileImageDataSource>(),
    ),
  );

  locator.registerLazySingleton<ContactUsRepository>(
    () => ContactUsRepositoryImplementation(
      dataSource: locator<ContactUsDataSource>(),
    ),
  );

  locator.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImplementation(
      dataSource: locator<PaymentDataSource>(),
    ),
  );

  // locator.registerLazySingleton<PaymentRepository>(
  //   () => PaymentRepositoryImplementation(
  //     dataSource: locator<PaymentDataSource>(),
  //   ),
  // );
  // locator.registerLazySingleton<SocketProvider>(() => SocketProvider());

  //datasource
  locator.registerLazySingleton<CurrencyDataSource>(
      () => CurrencyDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<PriceCategoryDataSource>(
      () => PriceCategoryDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<VehicleCategoryDataSource>(
      () => VehicleCategoryDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<GooglePlaceDataSource>(
      () => GooglePlaceDataSourceImpl(dio: locator<Dio>()));
  locator.registerLazySingleton<GooglePlaceRepository>(() =>
      GooglePlaceRepositoryImpl(dataSource: locator(), networkInfo: locator()));
  locator.registerLazySingleton<TotalPriceDataSource>(
      () => TotalPriceDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<LoginDataSource>(
      () => LoginDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<RegisterDataSource>(
      () => RegisterDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<AboutUsDataSource>(
      () => AboutUsDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<ProfileDataSource>(
      () => ProfileDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<HistoryDataSource>(
      () => HistoryDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<ForgotPasswordDataSource>(
      () => ForgotPasswordDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<OtpVerificationDataSource>(
      () => OtpVerificationDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<OrderDataSource>(
      () => OrderDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<CreateProfileDataSource>(
      () => CreateProfileDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<UploadProfileImageDataSource>(
      () => UploadProfileImageDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<ContactUsDataSource>(
      () => ContactUsDataSourceImplementation(dio: locator<Dio>()));

  locator.registerLazySingleton<PaymentDataSource>(
      () => PaymentDataSourceImplementation(dio: locator<Dio>()));

  //usecase
  locator.registerLazySingleton<GetCurrency>(
      () => GetCurrency(locator<CurrencyRepository>()));
  locator.registerLazySingleton<GetPriceCategory>(
      () => GetPriceCategory(locator<PriceCategoryRepository>()));
  locator.registerLazySingleton<GetVehiclesCategory>(
      () => GetVehiclesCategory(locator<VehiclesCategoryRepository>()));
  locator.registerLazySingleton<GetGooglePlace>(
      () => GetGooglePlace(repository: locator()));
  locator.registerLazySingleton<GetTotalPrice>(
      () => GetTotalPrice(locator<TotalPriceRepository>()));
  locator.registerLazySingleton<DoLogin>(
      () => DoLogin(repository: locator<LoginRepository>()));
  locator.registerLazySingleton<DoRegister>(
      () => DoRegister(repository: locator<RegisterRepository>()));
  locator.registerLazySingleton<GetAboutUs>(
      () => GetAboutUs(repository: locator<AboutUsRepository>()));
  locator.registerLazySingleton<GetProfile>(
      () => GetProfile(repository: locator<ProfileRepository>()));
  locator.registerLazySingleton<GetHistory>(
      () => GetHistory(repository: locator<HistoryRepository>()));

  locator.registerLazySingleton<GetRating>(
      () => GetRating(repository: locator<HistoryRepository>()));
  locator.registerLazySingleton<UpdateProfile>(
      () => UpdateProfile(repository: locator<ProfileRepository>()));
  locator.registerLazySingleton<UpdateEmail>(
      () => UpdateEmail(repository: locator<ProfileRepository>()));
  locator.registerLazySingleton<UpdatePassword>(
      () => UpdatePassword(repository: locator<ProfileRepository>()));
  locator.registerLazySingleton<DoForgotPassword>(
      () => DoForgotPassword(repository: locator<ForgotPasswordRepository>()));
  locator.registerLazySingleton<DoOtpVerify>(
      () => DoOtpVerify(repository: locator<OtpVerificationRepository>()));
  locator.registerLazySingleton<CreateOrder>(
      () => CreateOrder(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<UpdateStatusOrder>(
      () => UpdateStatusOrder(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<GetStatusOrder>(
      () => GetStatusOrder(repository: locator<OrderRepository>()));

  locator.registerLazySingleton<GetOrderDetail>(
      () => GetOrderDetail(repository: locator<OrderRepository>()));

  locator.registerLazySingleton<GetOrderReceipt>(
      () => GetOrderReceipt(repository: locator<OrderRepository>()));

  locator.registerLazySingleton<SubmitRatings>(
      () => SubmitRatings(repository: locator<OrderRepository>()));

  locator.registerLazySingleton<GetDriverDetail>(
      () => GetDriverDetail(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<GetDriverLocation>(
      () => GetDriverLocation(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<CreateProfile>(
      () => CreateProfile(repository: locator<CreateProfileRepository>()));

  locator.registerLazySingleton<UploadProfileImage>(() =>
      UploadProfileImage(repository: locator<UploadProfileImageRepository>()));
  locator.registerLazySingleton<DoContactUs>(
      () => DoContactUs(repository: locator<ContactUsRepository>()));

  locator.registerLazySingleton<PaymentCard>(
      () => PaymentCard(repository: locator<PaymentRepository>()));

  //   locator.registerLazySingleton<DoCardList>(
  // () => DoCardList(repository: locator<CardListRepository>()));

  /**             providers             **/
  locator.registerFactory(
    () => SplashProvider(getCurrency: locator<GetCurrency>()),
  );
  locator.registerFactory(
    () => HomeProvider(
      getPriceCategory: locator<GetPriceCategory>(),
      createOrder: locator<CreateOrder>(),
      getTotalPrice: locator<GetTotalPrice>(),
      getVehicleCatagory: locator<GetVehiclesCategory>(),
    ),
  );
  locator.registerFactory(
    () => OrderProvider(
        updateStatusOrder: locator<UpdateStatusOrder>(),
        getDriverDetail: locator<GetDriverDetail>(),
        getDriverLocation: locator<GetDriverLocation>(),
        getOrderDetail: locator<GetOrderDetail>(),
        getStatusOrder: locator<GetStatusOrder>(),
        submitRatings: locator<SubmitRatings>(),
        orderReceipt: locator<GetOrderReceipt>()),
  );

  locator.registerFactory<PlacePickerProvider>(
      () => PlacePickerProvider(getGooglePlace: locator<GetGooglePlace>()));
  locator.registerFactory<LoginProvider>(() => LoginProvider(
        doLogin: locator<DoLogin>(),
        doLoginSocial: locator<DoLogin>(),
      ));
  locator.registerFactory<ForgotPasswordProvider>(
      () => ForgotPasswordProvider(doForgotPassword: locator()));
  locator.registerFactory<RegisterProvider>(
      () => RegisterProvider(doRegister: locator()));
  locator.registerFactory<AboutUsProvider>(
      () => AboutUsProvider(getAboutUs: locator()));
  locator.registerFactory<ProfileProvider>(
      () => ProfileProvider(getProfile: locator()));
  locator.registerFactory<HistoryProvider>(
    () => HistoryProvider(
      getHistory: locator(),
      getRatings: locator(),
    ),
  );
  locator.registerFactory<ProfileEditProvider>(
      () => ProfileEditProvider(updateProfile: locator()));
  locator.registerFactory<ChangeEmailProvider>(
      () => ChangeEmailProvider(updateEmail: locator()));
  locator.registerFactory<ChangePasswordProvider>(
      () => ChangePasswordProvider(updatePassword: locator()));
  locator.registerFactory<OtpVerificationProvider>(
      () => OtpVerificationProvider(doOtpVerify: locator()));

  locator.registerFactory<CreateProfileProvider>(
      () => CreateProfileProvider(doCreateProfile: locator()));
  locator.registerFactory<UploadProfileImageProvider>(
      () => UploadProfileImageProvider(doUploadProfileImage: locator()));

  locator.registerFactory<ContactusProvider>(
      () => ContactusProvider(doContactus: locator()));
  locator.registerFactory<PaymentProvider>(
      () => PaymentProvider(paymentCard: locator()));

  // locator.registerFactory<SocketProvider>(() => SocketProvider());
  locator.registerFactory<NewSocketProvider>(() => NewSocketProvider());
  // locator.registerFactory<ChatProvider>(() => ChatProvider());
}
