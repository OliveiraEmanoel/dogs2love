import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DogBreed {
String id;
String dogRace;
String dogImageUrl;
bool isFavorite;
String userName;
String userId;

DogBreed({this.id,this.dogRace,this.dogImageUrl,this.isFavorite,this.userName,this.userId});

//factory DogBreed.fromJson(Map<String, dynamic> json) => _$DogBreedFromJson(json);

//Map<String, dynamic> toJson() => _$DogBreedToJson(this);



}