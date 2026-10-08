import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/screens/archive_page.dart';
import 'package:keeps_note_clone/screens/help_feedback_page.dart';
import 'package:keeps_note_clone/screens/home_page.dart';
import 'package:keeps_note_clone/screens/label_notes_page.dart';
import 'package:keeps_note_clone/screens/login_page.dart';
import 'package:keeps_note_clone/screens/reminder_page.dart';
import 'package:keeps_note_clone/screens/settings_page.dart';
import 'package:keeps_note_clone/screens/side_menu.dart';
import 'package:keeps_note_clone/screens/splash_screen.dart';
import 'package:keeps_note_clone/screens/trash_page.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:keeps_note_clone/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';


// Future<void> initFirebase() async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform, // Ensure firebase_options.dart is generated and imported
//   );
//   if (kDebugMode) {
//     await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);  // Disable Crashlytics in debug mode
//   }
//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;  // Capture Flutter errors in Crashlytics
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure all bindings are initialized before Firebase
  // await initFirebase();  // Initialize Firebase

  runApp(
    ChangeNotifierProvider(
      create: (context) => LabelsProvider(),  // Initialize your provider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Screens.login:
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case Screens.home:
            return MaterialPageRoute(builder: (_) => const HomePage());
          case Screens.reminder:
            return MaterialPageRoute(builder: (_) => const ReminderPage());
          case Screens.labelPage:
            if (settings.arguments != null) {
              final label = settings.arguments as Label;
              return MaterialPageRoute(builder: (_) => LabelNotesPage(label: label));
            } else {
              logPrint('Warning: No label title provided for /label-page route.');
              return MaterialPageRoute(builder: (_) => const LabelNotesPage());
            }
          case Screens.archive:
            return MaterialPageRoute(builder: (_) => const ArchivePage());
          case Screens.trash:
            return MaterialPageRoute(builder: (_) => const TrashPage());
          case Screens.settings:
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          case Screens.helpPage:
            return MaterialPageRoute(builder: (_) => const HelpFeedbackPage());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
      routes: {
        Screens.splash: (BuildContext context) => const SplashScreen(), // Initial route
        Screens.home: (BuildContext context) => const HomePage(),
        Screens.reminder: (BuildContext context) => const ReminderPage(),
        // '/label-page': (BuildContext context) => const LabelNotesPage(),
        Screens.trash: (BuildContext context) => const TrashPage(),
        Screens.archive: (BuildContext context) => const ArchivePage(),
        Screens.settings: (BuildContext context) => const SettingsPage(),
        Screens.helpPage: (BuildContext context) => const HelpFeedbackPage(),
      },
      initialRoute: Screens.splash
    );
  }
}

