// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_rule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlertRuleAdapter extends TypeAdapter<AlertRule> {
  @override
  final int typeId = 4;

  @override
  AlertRule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlertRule(
      id: fields[0] as String,
      name: fields[1] as String,
      ruleType: fields[2] as String,
      operator: fields[3] as String,
      threshold: fields[4] as double,
      isEnabled: fields[5] as bool,
      notifyOnTrigger: fields[6] as bool,
      createdAt: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AlertRule obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ruleType)
      ..writeByte(3)
      ..write(obj.operator)
      ..writeByte(4)
      ..write(obj.threshold)
      ..writeByte(5)
      ..write(obj.isEnabled)
      ..writeByte(6)
      ..write(obj.notifyOnTrigger)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertRuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
