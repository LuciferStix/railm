import 'package:flutter/material.dart';
import 'pages/train.dart';

void main() {
    runApp(const App());
}

class App extends StatefulWidget {
    const App({super.key});

    @override
    State<StatefulWidget> createState() => _App();
}

class _App extends State<App> {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            theme: .dark(),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                body: const TrainPage(),
            ),
        );
    }
}
