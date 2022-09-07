// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      task: json['task'] as String,
      assignTo: json['assignTo'] as String,
      assignBy: json['assignBy'] as String,
      assignToName: json['assignToName'] as String?,
      taskId: json['taskId'] as String?,
      assignTime: json['assignTime'] as int,
      completionDate: json['completionDate'] as int,
      taskStatus:
          $enumDecodeNullable(_$TaskStatusEnumMap, json['taskStatus']) ??
              TaskStatus.process,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'task': instance.task,
      'assignTo': instance.assignTo,
      'assignBy': instance.assignBy,
      'taskId': instance.taskId,
      'assignToName': instance.assignToName,
      'assignTime': instance.assignTime,
      'completionDate': instance.completionDate,
      'taskStatus': _$TaskStatusEnumMap[instance.taskStatus],
    };

const _$TaskStatusEnumMap = {
  TaskStatus.process: 'process',
  TaskStatus.done: 'done',
  TaskStatus.due: 'due',
};
