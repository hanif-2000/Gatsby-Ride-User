# TAXI USER

# Requirement

- Flutter 2.10.x or later
- VSCode or Android Studio


# Configuration

## Preparation
- Generate your Google API key based on [this](https://support.google.com/googleapi/answer/6158862?hl=en).
- Prepare your domain.

## Settings 
- Replace with yours at `/lib/core/utility/app_settings.dart`:
    ```
    const String BASE_URL = 'https://[your_domain]/';
    const String BASE_URL_PHOTO = 'https://[your_domain]/public';
    const String GOOGLEMAPKEY = "use_your_google_api_key";
    ```
- Replace with yours at `AndroidManifest.xml`:
    ```
    <meta-data android:name="com.google.android.geo.API_KEY"
            android:value="use_your_google_api_key"/>
    ```
- Replace with yours at `AppDelegate.swift`:
    ```
    GMSServices.provideAPIKey("use_your_google_api_key")
    ```

# Installation
Run like normal Flutter's app with:

    # flutter pub get
    # flutter run