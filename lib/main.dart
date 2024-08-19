import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/services/auth/auth_checker.dart';
import 'package:flutter_firebase_chat/theme/theme.dart';
import 'package:flutter_firebase_chat/theme/util.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/di/configure_providers.dart';
import 'firebase_options.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final data = await ConfigureProviders.createDependencyTree();

  runApp(AppRoot(data: data));
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.data});

  final ConfigureProviders data;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto Flex", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aula',
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: const AuthChecker(),
      ),
    );
  }
}
