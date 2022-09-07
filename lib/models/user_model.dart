import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String fullname;
  String mob;
  String? whatsapp;
  String? uid;
  String fcmToken;
  List<String>? channelIds;
  @TimestampConvertDatetime()
  DateTime? createdAt;

  @TimestampConvertDatetime()
  DateTime? updatedAt;

  UserModel(
      {required this.fullname,
      required this.mob,
      this.whatsapp,
      required this.uid,
      this.channelIds,
      this.createdAt,
      this.fcmToken = '',
      this.updatedAt});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

class TimestampConvertDatetime implements JsonConverter<DateTime, Timestamp> {
  const TimestampConvertDatetime();
  @override
  DateTime fromJson(Timestamp json) {
    return json.toDate();
  }

  @override
  Timestamp toJson(DateTime object) {
    return Timestamp.fromDate(object);
  }
}
