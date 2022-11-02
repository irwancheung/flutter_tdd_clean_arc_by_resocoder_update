import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/error/exception.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls http://numbersapi.com/{number}?json endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls http://numbersapi.com/random?json endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTriviaFromPath(number.toString());
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromPath('random');
  }

  Future<NumberTriviaModel> _getTriviaFromPath(String path) async {
    final uri = Uri(scheme: 'http', host: 'numbersapi.com', path: path);

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(response.body);
    }

    throw ServerException();
  }
}
