// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalaryEntryImpl _$$SalaryEntryImplFromJson(Map<String, dynamic> json) =>
    _$SalaryEntryImpl(
      id: (json['id'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SalaryEntryImplToJson(_$SalaryEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'year': instance.year,
      'month': instance.month,
      'createdAt': instance.createdAt.toIso8601String(),
    };
