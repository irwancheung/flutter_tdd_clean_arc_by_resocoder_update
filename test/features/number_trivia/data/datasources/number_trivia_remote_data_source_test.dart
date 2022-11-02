import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/error/exception.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(fixture('trivia.json'));

    test('''
should perform GET request on a URL with number
    on the endpoint and with application/json header''', () async {
      // Arrange
      setUpMockHttpClientSuccess();

      // Act
      dataSource.getConcreteNumberTrivia(tNumber);

      // Assert
      verify(
        mockHttpClient.get(
          Uri(scheme: 'http', host: 'numbersapi.com', path: '/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTrivia when the response code is 200', () async {
      // Arrange
      setUpMockHttpClientSuccess();

      // Act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // Assert
      expect(result, tNumberTriviaModel);
    });

    test(
        'should throw ServerException when the response code is other than 200',
        () async {
      // Arrange
      setUpMockHttpClientFailure();

      // Act
      final call = dataSource.getConcreteNumberTrivia;

      // Assert
      expect(call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(fixture('trivia.json'));

    test('''
should perform GET request on a URL with random path
    on the endpoint and with application/json header''', () async {
      // Arrange
      setUpMockHttpClientSuccess();

      // Act
      dataSource.getRandomNumberTrivia();

      // Assert
      verify(
        mockHttpClient.get(
          Uri(scheme: 'http', host: 'numbersapi.com', path: '/random'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTrivia when the response code is 200', () async {
      // Arrange
      setUpMockHttpClientSuccess();

      // Act
      final result = await dataSource.getRandomNumberTrivia();

      // Assert
      expect(result, tNumberTriviaModel);
    });

    test(
        'should throw ServerException when the response code is other than 200',
        () async {
      // Arrange
      setUpMockHttpClientFailure();

      // Act
      final call = dataSource.getRandomNumberTrivia;

      // Assert
      expect(call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
