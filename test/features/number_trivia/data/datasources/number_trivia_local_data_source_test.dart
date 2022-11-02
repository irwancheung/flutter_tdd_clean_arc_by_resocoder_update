import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/error/exception.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(fixture('trivia_cached.json'));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in it',
        () async {
      // Arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      // Act
      final result = await dataSource.getLastNumberTrivia();

      // Assert
      verify(mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, tNumberTriviaModel);
    });

    test(
        'should throw CacheException when there is no cached data in SharedPreferences',
        () async {
      // Arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // Act
      final call = dataSource.getLastNumberTrivia;

      // Assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'Test Trivia');
    test('should call SharedPreferences to cache the data', () async {
      // Act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      // Assert
      final expectedJsonString = tNumberTriviaModel.toJson();
      verify(
        mockSharedPreferences.setString(
          cachedNumberTrivia,
          expectedJsonString,
        ),
      );
    });
  });
}
