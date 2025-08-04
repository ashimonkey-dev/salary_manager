import 'package:hive/hive.dart';
import '../../domain/models/salary_entry.dart';

class SalaryEntryAdapter extends TypeAdapter<SalaryEntry> {
  @override
  final int typeId = 1;

  @override
  SalaryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalaryEntry(
      id: fields[0] as int,
      categoryId: fields[1] as int,
      amount: fields[2] as double,
      year: fields[3] as int,
      month: fields[4] as int,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SalaryEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.month)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalaryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
} 