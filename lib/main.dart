import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_olx/Model/PriceProposal.dart';
import 'package:flutter_olx/Screens/ForgotPassword/EnterEmailOtp.dart';
import 'package:flutter_olx/Screens/PriceProposal/CreatePriceProposal.dart';
import 'package:flutter_olx/Screens/PriceProposal/PriceProposalList.dart';
import 'package:flutter_olx/Screens/PriceProposal/ViewPriceProposal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/NotificationDemo.dart';
import 'package:flutter_olx/Provider/LeadProvider.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/ApiTesting.dart';
import 'package:flutter_olx/Screens/HomeScreen/HomePage.dart';
import 'package:flutter_olx/Screens/HomeScreen/Lead/AddLeadPage.dart';
import 'package:flutter_olx/Screens/HomeScreen/Lead/LeadPage.dart';
import 'package:flutter_olx/Screens/LoginPage.dart';
import 'package:flutter_olx/Screens/MyBussinessPage.dart';
import 'package:flutter_olx/Screens/SignUpScreen.dart';

void main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider.value(
          value: UserDataProvider(),
        ),

        ChangeNotifierProvider.value(
          value: User(),
        ),
        ChangeNotifierProvider.value(
          value: LeadProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Lead Marker',
        theme: ThemeData(
          dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),

          appBarTheme: AppBarTheme(
              color: red, iconTheme: IconThemeData(color: Colors.white)),
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage()
      ),
    );
  }
}
