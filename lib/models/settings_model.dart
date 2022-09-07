import 'package:did/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'settings_model.g.dart';

// enum Status { process, done, due }

@JsonSerializable()
class SettingsModel {
  List<String> alladmins;

  SettingsModel({required this.alladmins});
  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}
