// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      fullname: json['fullname'] as String,
      mob: json['mob'] as String,
      whatsapp: json['whatsapp'] as String?,
      uid: json['uid'] as String?,
      channelIds: (json['channelIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      fcmToken: json['fcmToken'] as String? ?? '',
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'fullname': instance.fullname,
      'mob': instance.mob,
      'whatsapp': instance.whatsapp,
      'uid': instance.uid,
      'fcmToken': instance.fcmToken,
      'channelIds': instance.channelIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
