// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
      channelName: json['channelName'] as String,
      channelId: json['channelId'] as String,
      adminId: json['adminId'] as String,
      lastMsg: json['lastMsg'] as String? ?? '',
      isPrivate: json['isPrivate'] as bool? ?? false,
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int?,
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'channelName': instance.channelName,
      'channelId': instance.channelId,
      'adminId': instance.adminId,
      'isPrivate': instance.isPrivate,
      'lastMsg': instance.lastMsg,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
