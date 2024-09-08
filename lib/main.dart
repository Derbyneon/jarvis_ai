import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jarvis_ai/firebase_options.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import 'discussion_provider.dart';
import 'current_discussion_provider.dart'; // Import du CurrentDiscussionIdProvider

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DiscussionProvider()),
        ChangeNotifierProvider(create: (_) => CurrentDiscussionIdProvider()), // Ajout du provider
      ],
      child: const MyApp(),
    ),
  );
}
