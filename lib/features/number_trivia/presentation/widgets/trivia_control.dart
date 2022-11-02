import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({super.key});

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  final controller = TextEditingController();

  void getConcreteNumberTrivia() {
    if (controller.text.isNotEmpty) {
      BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaFromConcreteNumber(controller.text));
    }

    controller.clear();
  }

  void getRandomNumberTrivia() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaFromRandomNumber());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: getConcreteNumberTrivia,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: getRandomNumberTrivia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Get Random Trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
