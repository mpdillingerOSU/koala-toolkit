import 'package:flutter/material.dart';
import 'package:gaming_toolkit/pages/home_page.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/projects_page.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/settings_page.dart';
import 'package:gaming_toolkit/pages/profile_page.dart';
import 'package:gaming_toolkit/pages/quiz_creation_page.dart';
import 'package:flutter/services.dart';
import 'package:gaming_toolkit/user_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  await UserPreferences.init();
  runApp(const GamingToolkit());
}

class GamingToolkit extends StatelessWidget {
  const GamingToolkit({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.lightBlue[500],
      ),
      home: const ProjectsPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage('Pengy'),
        '/quiz': (context) => const QuizCreationPage(),
        '/projects': (context) => const ProjectsPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
