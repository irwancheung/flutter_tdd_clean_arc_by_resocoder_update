import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/error/failure.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>(),
])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('InitialState should be NumberTriviaInitial', () async {
    // Assert
    expect(bloc.state, NumberTriviaInitial());
  });

  group('GetTriviaFromConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInt(any))
          .thenReturn(const Right(tNumberParsed));
    }

    test(
        'should call the InputConverter to validate and convert the string to unsigned integer',
        () async {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // Act
      bloc.add(const GetTriviaFromConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInt(any));

      // Assert
      verify(mockInputConverter.stringToUnsignedInt(tNumberString));
    });

    test('should emit [NumberTriviaError] when the input is invalid', () async {
      // Arrange
      when(mockInputConverter.stringToUnsignedInt(any))
          .thenReturn(Left(InvalidInputFailure()));

      // Assert
      final expected = [
        const NumberTriviaError(message: invalidInputFailureMessage)
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      // Act
      bloc.add(const GetTriviaFromConcreteNumber(tNumberString));
    });

    test('should get data from concrete usecase', () async {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // Act
      bloc.add(const GetTriviaFromConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      // Assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaLoaded] when get data successfully',
        () async {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // Assert
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaLoaded(trivia: tNumberTrivia),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      // Act
      bloc.add(const GetTriviaFromConcreteNumber(tNumberString));
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaError] when getting data is failed',
        () async {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Assert
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaError(message: serverFailureMessage),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      // Act
      bloc.add(const GetTriviaFromConcreteNumber(tNumberString));
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaError] with proper error message when getting data is failed',
        () async {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // Assert
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaError(message: cacheFailureMessage),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      // Act
      bloc.add(const GetTriviaFromConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaFromRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from random usecase', () async {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // Act
      bloc.add(GetTriviaFromRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      // Assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaLoaded] when get data successfully',
        () async {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // Assert
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaLoaded(trivia: tNumberTrivia),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      // Act
      bloc.add(GetTriviaFromRandomNumber());
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaError] when getting data is failed',
        () async {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Assert
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaError(message: serverFailureMessage),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      // Act
      bloc.add(GetTriviaFromRandomNumber());
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaError] with proper error message when getting data is failed',
        () async {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // Assert
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaError(message: cacheFailureMessage),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      // Act
      bloc.add(GetTriviaFromRandomNumber());
    });
  });
}
