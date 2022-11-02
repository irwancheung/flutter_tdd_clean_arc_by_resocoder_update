import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/util/color_converter.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/injection_container.dart'
    as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch:
            di.sl<ColorConverter>().getMaterialColor(Colors.green.shade800),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
