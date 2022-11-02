import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/error/failure.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
