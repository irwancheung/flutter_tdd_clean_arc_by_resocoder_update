import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/error/failure.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid input - The number must be positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaFromConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInt(event.numberString);

        await inputEither.fold(
          (failure) {
            emit(const NumberTriviaError(message: invalidInputFailureMessage));
          },
          (number) async {
            emit(NumberTriviaLoading());

            final resultEither =
                await getConcreteNumberTrivia(Params(number: number));

            emit(_eitherLoadedOrError(resultEither));
          },
        );

        return;
      }

      if (event is GetTriviaFromRandomNumber) {
        emit(NumberTriviaLoading());

        final resultEither = await getRandomNumberTrivia(NoParams());

        emit(_eitherLoadedOrError(resultEither));
      }
    });
  }

  NumberTriviaState _eitherLoadedOrError(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) {
    return failureOrTrivia.fold((failure) {
      return NumberTriviaError(message: _mapFailureToMessage(failure));
    }, (numberTrivia) {
      return NumberTriviaLoaded(trivia: numberTrivia);
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
