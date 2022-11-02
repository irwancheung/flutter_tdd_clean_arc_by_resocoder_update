import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/presentation/widgets/trivia_control.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: const SingleChildScrollView(child: Body()),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaLoading) {
                    return const LoadingDisplay();
                  }

                  if (state is NumberTriviaLoaded) {
                    return InitialAndErrorDisplay(
                      message: state.trivia.text,
                    );
                  }

                  if (state is NumberTriviaError) {
                    return InitialAndErrorDisplay(
                      message: state.message,
                    );
                  }

                  return const InitialAndErrorDisplay(
                    message: 'Start searching!',
                  );
                },
              ),
              const SizedBox(height: 20),
              const TriviaControl(),
            ],
          ),
        ),
      ),
    );
  }
}
