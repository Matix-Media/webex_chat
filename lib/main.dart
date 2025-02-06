import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:webex_chat/src/core/webex_sdk/auth/webex_auth.dart';
import 'package:webex_chat/src/core/webex_sdk/webex_config.dart';
import 'package:webex_chat/src/ui/screens/loading.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
      '${record.time} -- [${record.loggerName}] ${record.level.name}: ${record.message}',
    );
  });

  runApp(ProviderScope(child: const WebexChatApp()));
}

class WebexChatApp extends StatelessWidget {
  const WebexChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webex Chat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0071cf)),
        useMaterial3: true,
      ),
      home: LoadingScreen(),
    );
  }
}
