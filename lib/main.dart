import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibdaa_app/ui/introPage/introPage.dart';
import 'package:ibdaa_app/ui/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // localizationsDelegates: [
        //   // ... app-specific localization delegate[s] here
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   const Locale('ar', ''), // English, no country code
        //   // ... other locales the app supports
        // ],
        debugShowCheckedModeBanner: false,
        title: 'Ibdaa',
        theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: Colors.white,
          accentColor: AppColors.dodgerBlue,
          scaffoldBackgroundColor: Colors.white,
          // fontFamily: ArabicFonts.Cairo,
          fontFamily: GoogleFonts.oxygen().fontFamily,
          primarySwatch: Colors.blue,
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: IntroPage(),
        ));
  }
}
