import 'package:did/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'channel_model.g.dart';

@JsonSerializable()
class ChannelModel {
  String channelName;
  String channelId;
  String adminId;
  bool isPrivate;
  int memberCount;
  int createdAt;
  int? updatedAt;

  ChannelModel(
      {required this.channelName,
      required this.channelId,
      required this.adminId,
      this.memberCount = 0,
      this.isPrivate = false,
      required this.createdAt,
      this.updatedAt});
  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);
}
