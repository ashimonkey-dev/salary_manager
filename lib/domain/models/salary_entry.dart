import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'salary_entry.freezed.dart';
part 'salary_entry.g.dart';

@freezed
class SalaryEntry with _$SalaryEntry {
  const factory SalaryEntry({
    @HiveField(0)
    required int id,
    @HiveField(1)
    required int categoryId,
    @HiveField(2)
    required double amount,
    @HiveField(3)
    required int year,
    @HiveField(4)
    required int month,
    @HiveField(5)
    required DateTime createdAt,
  }) = _SalaryEntry;

  factory SalaryEntry.fromJson(Map<String, dynamic> json) =>
      _$SalaryEntryFromJson(json);
} 