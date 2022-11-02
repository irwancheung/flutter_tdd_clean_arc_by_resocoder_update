import 'dart:convert';

import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('tNumberTriviaModel should be a subclass of NumberTrivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('From JsonMap', () {
    test('should return a valid model number when the json is valid integer',
        () async {
      // Act
      final jsonMap =
          jsonDecode(fixture('trivia.json')) as Map<String, dynamic>;
      final result = NumberTriviaModel.fromMap(jsonMap);

      // Assert
      expect(result.runtimeType, NumberTriviaModel);
    });

    test('should return a valid model number when the json is valid double',
        () async {
      // Act
      final jsonMap =
          jsonDecode(fixture('trivia_double.json')) as Map<String, dynamic>;
      final result = NumberTriviaModel.fromMap(jsonMap);

      // Assert
      expect(result.runtimeType, NumberTriviaModel);
    });
  });

  group('To JsonMap', () {
    test('should return to map containing proper data', () async {
      // Act
      final result = tNumberTriviaModel.toMap();
      final expectedMap = {
        'text': 'Test Text',
        'number': 1,
      };

      // Assert
      expect(result, expectedMap);
    });
  });
}
