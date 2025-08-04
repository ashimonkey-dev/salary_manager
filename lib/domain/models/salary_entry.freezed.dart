// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salary_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalaryEntry _$SalaryEntryFromJson(Map<String, dynamic> json) {
  return _SalaryEntry.fromJson(json);
}

/// @nodoc
mixin _$SalaryEntry {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  int get categoryId => throw _privateConstructorUsedError;
  @HiveField(2)
  double get amount => throw _privateConstructorUsedError;
  @HiveField(3)
  int get year => throw _privateConstructorUsedError;
  @HiveField(4)
  int get month => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SalaryEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalaryEntryCopyWith<SalaryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryEntryCopyWith<$Res> {
  factory $SalaryEntryCopyWith(
          SalaryEntry value, $Res Function(SalaryEntry) then) =
      _$SalaryEntryCopyWithImpl<$Res, SalaryEntry>;
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) int categoryId,
      @HiveField(2) double amount,
      @HiveField(3) int year,
      @HiveField(4) int month,
      @HiveField(5) DateTime createdAt});
}

/// @nodoc
class _$SalaryEntryCopyWithImpl<$Res, $Val extends SalaryEntry>
    implements $SalaryEntryCopyWith<$Res> {
  _$SalaryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? amount = null,
    Object? year = null,
    Object? month = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalaryEntryImplCopyWith<$Res>
    implements $SalaryEntryCopyWith<$Res> {
  factory _$$SalaryEntryImplCopyWith(
          _$SalaryEntryImpl value, $Res Function(_$SalaryEntryImpl) then) =
      __$$SalaryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) int categoryId,
      @HiveField(2) double amount,
      @HiveField(3) int year,
      @HiveField(4) int month,
      @HiveField(5) DateTime createdAt});
}

/// @nodoc
class __$$SalaryEntryImplCopyWithImpl<$Res>
    extends _$SalaryEntryCopyWithImpl<$Res, _$SalaryEntryImpl>
    implements _$$SalaryEntryImplCopyWith<$Res> {
  __$$SalaryEntryImplCopyWithImpl(
      _$SalaryEntryImpl _value, $Res Function(_$SalaryEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? amount = null,
    Object? year = null,
    Object? month = null,
    Object? createdAt = null,
  }) {
    return _then(_$SalaryEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalaryEntryImpl implements _SalaryEntry {
  const _$SalaryEntryImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.categoryId,
      @HiveField(2) required this.amount,
      @HiveField(3) required this.year,
      @HiveField(4) required this.month,
      @HiveField(5) required this.createdAt});

  factory _$SalaryEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalaryEntryImplFromJson(json);

  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final int categoryId;
  @override
  @HiveField(2)
  final double amount;
  @override
  @HiveField(3)
  final int year;
  @override
  @HiveField(4)
  final int month;
  @override
  @HiveField(5)
  final DateTime createdAt;

  @override
  String toString() {
    return 'SalaryEntry(id: $id, categoryId: $categoryId, amount: $amount, year: $year, month: $month, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, categoryId, amount, year, month, createdAt);

  /// Create a copy of SalaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryEntryImplCopyWith<_$SalaryEntryImpl> get copyWith =>
      __$$SalaryEntryImplCopyWithImpl<_$SalaryEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalaryEntryImplToJson(
      this,
    );
  }
}

abstract class _SalaryEntry implements SalaryEntry {
  const factory _SalaryEntry(
      {@HiveField(0) required final int id,
      @HiveField(1) required final int categoryId,
      @HiveField(2) required final double amount,
      @HiveField(3) required final int year,
      @HiveField(4) required final int month,
      @HiveField(5) required final DateTime createdAt}) = _$SalaryEntryImpl;

  factory _SalaryEntry.fromJson(Map<String, dynamic> json) =
      _$SalaryEntryImpl.fromJson;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  int get categoryId;
  @override
  @HiveField(2)
  double get amount;
  @override
  @HiveField(3)
  int get year;
  @override
  @HiveField(4)
  int get month;
  @override
  @HiveField(5)
  DateTime get createdAt;

  /// Create a copy of SalaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalaryEntryImplCopyWith<_$SalaryEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
