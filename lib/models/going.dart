import 'going_model.dart';

class Going {
  final String address;
  final String description;
  List<dynamic> liked = [];

  Going(this.address, this.description);

  Map<String, dynamic> toMap() =>
      {
        "address": this.address,
        "description": this.description,
        "liked": this.liked
      };

  Going.fromMap(Map<dynamic, dynamic> map)
      : address = map['address'],
        description = map['description'],
        liked = map['liked'].map((set) {
          return Set.fromMap(set);
        }).toList();
}