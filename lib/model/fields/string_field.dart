import 'package:flutter_pom/model/field.dart';

class StringField extends Field<String> {
  StringField(String name) : super(name) {
    if (isNotNull) {
      init("");
    }
  }

  @override
  void fromSqlCompatibleValue(dynamic value) {
    this.value = value;
  }

  @override
  String toSqlCompatibleValue() {
    return "'$value'";
  }

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  String get sqlType => "TEXT";

  @override
  bool get supportsPrimaryKey => true;

  @override
  String get defaultValue => "";

}