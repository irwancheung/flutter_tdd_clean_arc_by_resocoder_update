import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String str) {
    try {
      final number = int.parse(str);

      if (number < 0) throw const FormatException();

      return Right(number);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
