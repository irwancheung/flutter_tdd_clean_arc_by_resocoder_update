import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an int when the string represent unsigned int',
        () async {
      // Arrange
      const str = '123';

      // Act
      final result = inputConverter.stringToUnsignedInt(str);

      // Assert
      expect(result, const Right(123));
    });

    test('should return Error when the string is not an int', () async {
      // Arrange
      const str = 'abc';

      // Act
      final result = inputConverter.stringToUnsignedInt(str);

      // Assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return Error when the string is a negative int', () async {
      // Arrange
      const str = '-123';

      // Act
      final result = inputConverter.stringToUnsignedInt(str);

      // Assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
