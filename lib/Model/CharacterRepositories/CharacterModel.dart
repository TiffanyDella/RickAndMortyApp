import 'package:hive/hive.dart';

part 'CharacterModel.g.dart'; 

@HiveType(typeId: 0)
class CharacterModel{
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String imageUrl;
  
  @HiveField(3)
  final String status;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.status,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'status': status,
    };
  }
}