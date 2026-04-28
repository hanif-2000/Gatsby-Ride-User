import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/static/colors.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);
  static const routeName = '/privacypolicy';

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final WebViewController controller;

  static const String _htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Privacy Policy</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
      line-height: 1.8;
      color: #333;
      background-color: #fff;
    }
    h1 {
      font-size: 22px;
      color: #111;
      margin-bottom: 4px;
    }
    h2 {
      font-size: 17px;
      color: #111;
      margin-top: 22px;
      margin-bottom: 6px;
    }
    h3 {
      font-size: 15px;
      color: #222;
      margin-top: 14px;
      margin-bottom: 4px;
    }
    p {
      font-size: 14px;
      color: #333;
      margin-bottom: 10px;
    }
    ul {
      font-size: 14px;
      color: #333;
      padding-left: 20px;
      margin-bottom: 10px;
    }
    li {
      margin-bottom: 4px;
    }
    hr {
      border: none;
      border-top: 1px solid #ddd;
      margin: 20px 0;
    }
  </style>
</head>
<body>
  <h1>Privacy Policy for Gatsby Rideshare</h1>
  <p><b>Effective Date:</b> January 1, 2024</p>

  <p>Gatsby Rideshare ("we," "our," or "us") operates the Gatsby Rideshare mobile application and website (the "Service"). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our Service.</p>
  <p>By using Gatsby Rideshare, you agree to the terms of this Privacy Policy.</p>

  <hr>

  <h2>1. Information We Collect</h2>
  <p>We may collect the following types of information:</p>

  <h3>A. Personal Information</h3>
  <ul>
    <li>Full name</li>
    <li>Phone number</li>
    <li>Email address</li>
    <li>Profile photo (optional)</li>
    <li>Payment information (processed securely via third-party providers such as Stripe)</li>
  </ul>

  <h3>B. Location Data</h3>
  <ul>
    <li>Real-time GPS location while using the app</li>
    <li>Pickup and drop-off locations</li>
    <li>Trip history and route data</li>
  </ul>

  <h3>C. Driver Information (if applicable)</h3>
  <ul>
    <li>Driver\'s license details</li>
    <li>Vehicle information</li>
    <li>Insurance documentation</li>
    <li>Background check information (where required by law)</li>
  </ul>

  <h3>D. Device &amp; Usage Data</h3>
  <ul>
    <li>IP address</li>
    <li>Device type and operating system</li>
    <li>App usage behavior</li>
    <li>Log and diagnostic data</li>
  </ul>

  <hr>

  <h2>2. How We Use Your Information</h2>
  <p>We use your information to:</p>
  <ul>
    <li>Provide and operate the rideshare service</li>
    <li>Match riders with drivers efficiently</li>
    <li>Process payments and send receipts</li>
    <li>Improve app performance and user experience</li>
    <li>Communicate with you (support, updates, promotions)</li>
    <li>Ensure safety, fraud prevention, and compliance with legal obligations</li>
  </ul>

  <hr>

  <h2>3. Sharing of Information</h2>
  <p>We may share your information in the following situations:</p>
  <ul>
    <li><b>Between Riders and Drivers:</b> Limited information such as name, rating, and trip details</li>
    <li><b>Service Providers:</b> Payment processors (e.g., Stripe), cloud hosting, analytics tools</li>
    <li><b>Legal Requirements:</b> When required by law, regulation, or government request</li>
    <li><b>Business Transfers:</b> In case of merger, acquisition, or asset sale</li>
  </ul>
  <p>We do not sell your personal information to third parties.</p>

  <hr>

  <h2>4. Location Data Use</h2>
  <p>Your location is essential to the functionality of the app. We collect and use location data to:</p>
  <ul>
    <li>Connect you with nearby drivers</li>
    <li>Calculate fares and routes</li>
    <li>Enhance safety and trip tracking</li>
  </ul>
  <p>You can disable location services, but this may limit app functionality.</p>

  <hr>

  <h2>5. Data Security</h2>
  <p>We implement industry-standard security measures to protect your data, including:</p>
  <ul>
    <li>Encryption of sensitive data</li>
    <li>Secure payment processing</li>
    <li>Restricted access to personal information</li>
  </ul>
  <p>However, no system is 100% secure, and we cannot guarantee absolute security.</p>

  <hr>

  <h2>6. Data Retention</h2>
  <p>We retain your information only as long as necessary to:</p>
  <ul>
    <li>Provide our services</li>
    <li>Comply with legal obligations</li>
    <li>Resolve disputes and enforce agreements</li>
  </ul>

  <hr>

  <h2>7. Your Rights</h2>
  <p>Depending on your location (including Canada), you may have the right to:</p>
  <ul>
    <li>Access your personal data</li>
    <li>Request correction of inaccurate information</li>
    <li>Request deletion of your data</li>
    <li>Withdraw consent where applicable</li>
  </ul>
  <p>To exercise your rights, contact us at: <b>Gatsbyrideshare@gmail.com</b></p>

  <hr>

  <h2>8. Children\'s Privacy</h2>
  <p>Gatsby Rideshare is not intended for individuals under the age of 18. We do not knowingly collect data from children.</p>

  <hr>

  <h2>9. Third-Party Services</h2>
  <p>Our app may use third-party services such as:</p>
  <ul>
    <li>Payment processors (Stripe)</li>
    <li>Mapping services (Google Maps)</li>
    <li>Analytics providers</li>
  </ul>
  <p>These services have their own privacy policies, and we encourage you to review them.</p>

  <hr>

  <h2>10. Changes to This Privacy Policy</h2>
  <p>We may update this Privacy Policy from time to time. Changes will be posted within the app and on our website with an updated effective date.</p>

  <hr>

  <h2>11. Contact Us</h2>
  <p>If you have any questions about this Privacy Policy, please contact us:</p>
  <p>
    <b>Gatsby Rideshare</b><br>
    Email: Gatsbyrideshare@gmail.com<br>
    Location: Alberta, Canada
  </p>

  <hr>

  <h2>12. Consent</h2>
  <p>By using our Service, you consent to the collection and use of your information as outlined in this Privacy Policy.</p>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(whiteColor)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: black080808Color),
          ),
          title: const Text(
            'Privacy Policy',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
