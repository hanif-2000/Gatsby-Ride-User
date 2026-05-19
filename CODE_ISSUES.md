# Gatsby Ride — User App: Full Code Issues List

**Date:** 14 May 2026  
**Reviewed By:** Claude Code  
**Total Issues Found:** 28

---

## CRITICAL — Crash Risks (6)

### 1. Wrong Notification Class Name — App Crash
**File:** `lib/core/presentation/providers/home_provider.dart` ~Line 145  
**Type:** Crash Risk  
**Problem:** `NotificationService().clearAllNotifications()` call kiya hai lekin class ka naam `NotificationHelper` hai. Yeh runtime par crash karega.  
**Fix:** `NotificationHelper().clearAllNotifications()` karo.

---

### 2. Hardcoded Google API Key — Security + Crash Risk
**File:** `lib/core/presentation/providers/home_provider.dart` ~Line 404  
**Type:** Security + Crash Risk  
**Problem:** Google Maps API key `AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs` source code mein hardcoded hai. Key revoke hone par map features kaam karna band ho jayenge.  
**Fix:** Environment variable ya secure config file mein move karo.

---

### 3. Null Pointer — Receipt Page Crash
**File:** `lib/features/order/presentation/pages/new_receipt_page.dart` ~Line 162  
**Type:** Crash Risk  
**Problem:** `provider.receiptResponseModel!.data!.image` — `image` field null ho sakta hai. Null safety check nahi hai.  
**Fix:** `provider.receiptResponseModel?.data?.image ?? ''` use karo.

---

### 4. `cameraPosition` Null Access
**File:** `lib/core/presentation/providers/place_picker_provider.dart` ~Line 68, 84  
**Type:** Crash Risk  
**Problem:** `cameraPosition!.target` — agar `cameraPosition` kabhi initialize nahi hua to crash hoga.  
**Fix:** `if (cameraPosition == null) return;` pehle check karo.

---

### 5. FCM Token Race Condition
**File:** `lib/core/presentation/providers/splash_provider.dart` ~Line 28-35  
**Type:** Crash Risk  
**Problem:** `_getFcmToken()` bina `await` ke call ho raha hai. App notifications bhejne ki koshish kare aur token abhi ready na ho to fail hoga.  
**Fix:** `await _getFcmToken()` use karo ya callback se ensure karo token ready hai.

---

### 6. Multiple Concurrent Timers — Memory Leak
**File:** `lib/features/order/presentation/pages/new_order_page.dart` ~Line 152  
**Type:** Crash Risk / Memory Leak  
**Problem:** "Search Again" dialog mein `startTimerAndNavigate(time: 180)` call hota hai bina pehle wala timer cancel kiye. Multiple timers ek saath chal sakte hain.  
**Fix:** Naya timer shuru karne se pehle `_timer?.cancel()` karo.

---

## BUGS — Logic Errors (6)

### 7. Wrong Variable in Destination Address
**File:** `lib/core/presentation/providers/place_picker_provider.dart` ~Line 82  
**Type:** Bug  
**Problem:** `setDestinationAddress` mein `originTextToShow` use ho raha hai. Destination address mein origin text set ho jaata hai.  
**Fix:** `destinationTextToShow` use karo.

---

### 8. Status 7 par Receipt Navigation Missing
**File:** `lib/features/order/presentation/pages/new_order_page.dart` ~Line 62-68  
**Type:** Bug  
**Problem:** Order complete hone par (status 7) `_hasNavigatedToReceipt = true` set hota hai lekin actual navigation code missing hai. Receipt page kabhi automatically nahi khulti.  
**Fix:** Navigation add karo:
```dart
if (status == 7 && !_hasNavigatedToReceipt) {
  _hasNavigatedToReceipt = true;
  Navigator.pushNamedAndRemoveUntil(context, ReceiptScreen.routeName, (r) => false);
}
```

---

### 9. Duplicate `appLoc.paymentInformation` Text
**File:** `lib/features/order/presentation/pages/new_receipt_page.dart` ~Line 279  
**Type:** Bug  
**Problem:** `appLoc.paymentInformation` do baar use hua hai — line 269 aur 279. Line 279 par payment method label hona chahiye.  
**Fix:** Sahi localization key lagao.

---

### 10. Distance Hardcoded "1" — Wrong Default
**File:** `lib/core/presentation/providers/home_provider.dart` ~Line 76  
**Type:** Bug  
**Problem:** `String distance = "1"` hardcoded default hai. Shuru mein 1 km distance set rehti hai.  
**Fix:** `String distance = "0"` karo.

---

### 11. Hardcoded Currency "CA$"
**File:** `lib/core/utility/helper.dart` ~Line 113  
**Type:** Bug  
**Problem:** `mergePriceTxt()` mein `"CA$ "` hardcoded hai. Session mein currency field hai lekin ignore ho rahi hai. Multi-currency support kaam nahi karega.  
**Fix:** `session.currency` se currency string lo.

---

### 12. Silent Token Clearing — Edge Case
**File:** `lib/core/network/app_interceptor.dart` ~Line 96-98  
**Type:** Bug  
**Problem:** Token externally clear ho jaye jab request in-progress ho to silently return ho jaata hai, caller ko pata nahi chalta.  
**Fix:** Log ya error callback add karo.

---

## MISSING IMPLEMENTATIONS (3)

### 13. Google Pay Result Handler Empty
**File:** `lib/features/order/presentation/pages/new_receipt_page.dart` ~Line 46  
**Type:** Missing Implementation  
**Problem:** `onGooglePayResult` callback define hai lekin bilkul empty hai. Google Pay payment result handle nahi hota.  
**Fix:** Google Pay success/failure handle karo jaise Apple Pay ka logic hai.

---

### 14. Notification Tap Navigation Not Implemented
**File:** `lib/core/utility/push_notification_helper.dart` ~Line 178-200  
**Type:** Missing Implementation  
**Problem:** `callApi()` hamesha `null` return karta hai. `_pushNextScreenFromForeground` kuch nahi karta. Notification tap par koi screen nahi khulti.  
**Fix:** Type ke basis par screen navigate karo (dekho Issue Doc — Issue 2).

---

### 15. `clearOrderSessionNew()` Commented Out
**File:** `lib/core/utility/session_helper.dart` ~Line 465-486  
**Type:** Missing Implementation  
**Problem:** Poora method commented out hai. Order session clear karne ka yeh alternative path kaam nahi karta.  
**Fix:** Ya implement karo ya completely delete karo.

---

## DEAD CODE (5)

### 16. `splash_page.dart` — Currency Fetch Commented
**File:** `lib/core/presentation/pages/splash_page.dart` ~Line 40-62  
Poora `fetchCurrency()` call commented out hai.

### 17. `new_receipt_page.dart` — ~100 Lines Payment Code Commented
**File:** `lib/features/order/presentation/pages/new_receipt_page.dart` ~Line 437-543  
Google Pay + Apple Pay ka purana FutureBuilder commented hai.

### 18. `login_page.dart` — Facebook Login Commented
**File:** `lib/features/login/presentation/pages/login_page.dart` ~Line 144-186  
Facebook login button poora commented out hai.

### 19. `notification_service.dart` — Old showNotifications Commented
**File:** `lib/core/utility/notification_service.dart` ~Line 104-124  
Purani implementation commented hai.

### 20. `firebase_helper.dart` — `_fetchRemoteMessage()` Never Called
**File:** `lib/core/utility/firebase_helper.dart` ~Line 115-156  
Method define hai, kahi se call nahi hota.

---

## BAD PRACTICES (8)

### 21. `home_provider.dart` — Dio DI Bypass
**File:** `lib/core/presentation/providers/home_provider.dart` ~Line 34  
`var dio = Dio()` directly create kiya — app interceptors bypass ho jaate hain, auth token attach nahi hoti.

### 22. `new_receipt_page.dart` — Dio Without Auth
**File:** `lib/features/order/presentation/pages/new_receipt_page.dart` ~Line 59  
`var dio = Dio()` bina headers — requests mein auth token nahi jaata.

### 23. `direction_helper.dart` — Assign + Return Same Line
**File:** `lib/core/utility/direction_helper.dart` ~Line 30  
`return polylinePoints = decodeEncodedPolyline(...)` — assign aur return ek line mein. Confusing hai.

### 24. `firebase_helper.dart` — God Function
**File:** `lib/core/utility/firebase_helper.dart` ~Line 70-112  
`_handleNoDriverAvailable()` bahut zyada kaam karta hai: ride cancel, session update, navigate, dialog show. Separate karo.

### 25. `iOS foreground notifications disabled`
**File:** `lib/core/utility/push_notification_helper.dart` ~Line 86-90, 134  
`alert: false, badge: false, sound: false` + `Platform.isIOS` skip — iOS par koi notification nahi aati.

### 26. `home_page.dart` — `didChangeAppLifecycleState` Missing
**File:** `lib/core/presentation/pages/home_page/home_page.dart`  
`WidgetsBindingObserver` add hai lekin override nahi — background se aane par status sync nahi hoti.

### 27. `home_page.dart` — Multiple `.then()` Mein `context.mounted` Missing
**File:** `lib/core/presentation/pages/home_page/home_page.dart` ~Line 74-189  
Async callbacks mein context.mounted check nahi — slow network par crash possible.

### 28. Global Variables in `helper.dart`
**File:** `lib/core/utility/helper.dart` ~Line 84-89  
`appLoc`, `myLocale`, `sessionHelper` global variables hain — testing mushkil, initialization order unpredictable.

---

## Priority Summary

| Priority | Count | Examples |
|----------|-------|---------|
| Critical (Crash) | 6 | Wrong class name, null pointer, timer leak |
| High (Bug) | 6 | Status 7 nav missing, wrong currency, duplicate text |
| Medium (Missing) | 3 | Google Pay, notification nav, session clear |
| Low (Dead Code) | 5 | Facebook login, commented payment code |
| Low (Bad Practice) | 8 | DI bypass, iOS notifications, context.mounted |
| **Total** | **28** | |
