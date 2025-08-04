import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    @HiveField(0)
    required int id,
    @HiveField(1)
    required String name,
    @HiveField(2)
    required int color,
    @HiveField(3)
    required String icon,
    @HiveField(4)
    required DateTime createdAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
} 