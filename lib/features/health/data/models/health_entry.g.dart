// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthEntryAdapter extends TypeAdapter<HealthEntry> {
  @override
  final int typeId = 0;

  @override
  HealthEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthEntry(
      date: fields[0] as DateTime,
      mood: fields[1] as String,
      sleepHours: fields[2] as double,
      waterIntake: fields[3] as double,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.mood)
      ..writeByte(2)
      ..write(obj.sleepHours)
      ..writeByte(3)
      ..write(obj.waterIntake)
      ..writeByte(4)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
