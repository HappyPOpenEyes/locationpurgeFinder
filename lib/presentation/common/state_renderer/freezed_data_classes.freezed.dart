// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freezed_data_classes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LoginObject {
  String get uMAID => throw _privateConstructorUsedError;
  String get uEmail => throw _privateConstructorUsedError;
  String get uName => throw _privateConstructorUsedError;
  String get uOS => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoginObjectCopyWith<LoginObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginObjectCopyWith<$Res> {
  factory $LoginObjectCopyWith(
          LoginObject value, $Res Function(LoginObject) then) =
      _$LoginObjectCopyWithImpl<$Res, LoginObject>;
  @useResult
  $Res call({String uMAID, String uEmail, String uName, String uOS});
}

/// @nodoc
class _$LoginObjectCopyWithImpl<$Res, $Val extends LoginObject>
    implements $LoginObjectCopyWith<$Res> {
  _$LoginObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uMAID = null,
    Object? uEmail = null,
    Object? uName = null,
    Object? uOS = null,
  }) {
    return _then(_value.copyWith(
      uMAID: null == uMAID
          ? _value.uMAID
          : uMAID // ignore: cast_nullable_to_non_nullable
              as String,
      uEmail: null == uEmail
          ? _value.uEmail
          : uEmail // ignore: cast_nullable_to_non_nullable
              as String,
      uName: null == uName
          ? _value.uName
          : uName // ignore: cast_nullable_to_non_nullable
              as String,
      uOS: null == uOS
          ? _value.uOS
          : uOS // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LoginObjectCopyWith<$Res>
    implements $LoginObjectCopyWith<$Res> {
  factory _$$_LoginObjectCopyWith(
          _$_LoginObject value, $Res Function(_$_LoginObject) then) =
      __$$_LoginObjectCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uMAID, String uEmail, String uName, String uOS});
}

/// @nodoc
class __$$_LoginObjectCopyWithImpl<$Res>
    extends _$LoginObjectCopyWithImpl<$Res, _$_LoginObject>
    implements _$$_LoginObjectCopyWith<$Res> {
  __$$_LoginObjectCopyWithImpl(
      _$_LoginObject _value, $Res Function(_$_LoginObject) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uMAID = null,
    Object? uEmail = null,
    Object? uName = null,
    Object? uOS = null,
  }) {
    return _then(_$_LoginObject(
      null == uMAID
          ? _value.uMAID
          : uMAID // ignore: cast_nullable_to_non_nullable
              as String,
      null == uEmail
          ? _value.uEmail
          : uEmail // ignore: cast_nullable_to_non_nullable
              as String,
      null == uName
          ? _value.uName
          : uName // ignore: cast_nullable_to_non_nullable
              as String,
      null == uOS
          ? _value.uOS
          : uOS // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LoginObject implements _LoginObject {
  _$_LoginObject(this.uMAID, this.uEmail, this.uName, this.uOS);

  @override
  final String uMAID;
  @override
  final String uEmail;
  @override
  final String uName;
  @override
  final String uOS;

  @override
  String toString() {
    return 'LoginObject(uMAID: $uMAID, uEmail: $uEmail, uName: $uName, uOS: $uOS)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoginObject &&
            (identical(other.uMAID, uMAID) || other.uMAID == uMAID) &&
            (identical(other.uEmail, uEmail) || other.uEmail == uEmail) &&
            (identical(other.uName, uName) || other.uName == uName) &&
            (identical(other.uOS, uOS) || other.uOS == uOS));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uMAID, uEmail, uName, uOS);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LoginObjectCopyWith<_$_LoginObject> get copyWith =>
      __$$_LoginObjectCopyWithImpl<_$_LoginObject>(this, _$identity);
}

abstract class _LoginObject implements LoginObject {
  factory _LoginObject(final String uMAID, final String uEmail,
      final String uName, final String uOS) = _$_LoginObject;

  @override
  String get uMAID;
  @override
  String get uEmail;
  @override
  String get uName;
  @override
  String get uOS;
  @override
  @JsonKey(ignore: true)
  _$$_LoginObjectCopyWith<_$_LoginObject> get copyWith =>
      throw _privateConstructorUsedError;
}
