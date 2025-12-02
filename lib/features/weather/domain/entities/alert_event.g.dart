// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlertEventAdapter extends TypeAdapter<AlertEvent> {
  @override
  final int typeId = 5;

  @override
  AlertEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlertEvent(
      id: fields[0] as String,
      ruleId: fields[1] as String,
      ruleName: fields[2] as String,
      message: fields[3] as String,
      timestamp: fields[4] as int,
      triggeredValue: fields[5] as double,
      notified: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AlertEvent obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ruleId)
      ..writeByte(2)
      ..write(obj.ruleName)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.triggeredValue)
      ..writeByte(6)
      ..write(obj.notified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
