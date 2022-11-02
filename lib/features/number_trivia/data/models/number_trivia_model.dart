import 'dart:convert';

import 'package:flutter_tdd_clean_arc_by_resocoder_update/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required super.number,
    required super.text,
  });

  NumberTriviaModel copyWith({
    int? number,
    String? text,
  }) {
    return NumberTriviaModel(
      number: number ?? this.number,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'text': text,
    };
  }

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      number: (map['number'] as num).toInt(),
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NumberTriviaModel.fromJson(String source) =>
      NumberTriviaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NumberTriviaModel(number: $number, text: $text)';
}
