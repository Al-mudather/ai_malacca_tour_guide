import 'place_model.dart';

class QnAModel {
  final int? id;
  final String question;
  final String answer;
  final int placeId;
  final Place? place;

  QnAModel({
    this.id,
    required this.question,
    required this.answer,
    required this.placeId,
    this.place,
  });

  factory QnAModel.fromJson(Map<String, dynamic> json) {
    return QnAModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      placeId: json['place_id'],
      place: json['Place'] != null ? Place.fromJson(json['Place']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'place_id': placeId,
    };
  }

  QnAModel copyWith({
    int? id,
    String? question,
    String? answer,
    int? placeId,
    Place? place,
  }) {
    return QnAModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      placeId: placeId ?? this.placeId,
      place: place ?? this.place,
    );
  }
}
