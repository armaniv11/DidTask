import 'package:did/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'task_model.g.dart';

enum TaskStatus { process, done, due }

@JsonSerializable()
class TaskModel {
  String task;
  String assignTo;
  String assignBy;
  String? taskId;
  String? assignToName;
  int assignTime;
  int completionDate;
  TaskStatus taskStatus;

  TaskModel(
      {required this.task,
      required this.assignTo,
      required this.assignBy,
      this.assignToName,
      required this.taskId,
      required this.assignTime,
      required this.completionDate,
      this.taskStatus = TaskStatus.process});
  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
