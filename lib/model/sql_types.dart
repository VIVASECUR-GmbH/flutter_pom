import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/table.dart';


class SQLTypes {
  static final String text = "TEXT";
  static final String double = "DOUBLE";
  static final String integer = "INTEGER";
  static final String boolean = integer;
  static final String dateTime = "DATETIME";

  static final String primaryKey = "PRIMARY KEY";
  static final String autoIncrement = "AUTOINCREMENT";

  static final String nullValue = "NULL";
  static final String notNull = "NOT $nullValue";

  static final String stringIdentifier = "'";
  static final String separator = " ";

  static final String eq = "=";
  static final String like = "LIKE";
  static final String not = "!";
  static final String gt = ">";
  static final String lt = "<";
  static final String wildcard = "%";
  static final String comma = ",";
  static final String bracketOpen = "(";
  static final String bracketClose = ")";

  static String toSqlString(String value) {
    if (value == null) {
      return nullValue;
    } else {
      return "$stringIdentifier$value$stringIdentifier";
    }
  }
}

class SQLKeywords {
  static final String select = "SELECT";
  static final String insert = "INSERT INTO";
  static final String from = "FROM";
  static final String or = "OR";
  static final String and = "AND";
  static final String allSelector = "*";
  static final String drop = "DROP";
  static final String table = "TABLE";
  static final String where = "WHERE";
  static final String ascending = "ASC";
  static final String descending = "DESC";
  static final String orderBy = "ORDER${SQLTypes.separator}BY";
  static final String update = "UPDATE";
  static final String set = "SET";
  static final String delete = "DELETE";
  static final String values = "VALUES";
  static final String count = "COUNT";
  static final String limit = "LIMIT";
  static final String offset = "OFFSET";
  static final String dropTable =
      "DROP${SQLTypes.separator}${SQLKeywords.table}${SQLTypes.separator}IF${SQLTypes.separator}NOT${SQLTypes.separator}EXISTS";
}

extension TableHelper on Table {
  String count() {
    var builder = <String>[];
    builder.addAll(
        [SQLKeywords.select, SQLKeywords.count, SQLKeywords.allSelector.inBrackets(), SQLKeywords.from, this.tableName]);
    return builder.join(SQLTypes.separator);
  }

  String select(String expression) {
    var builder = <String>[];
    builder.addAll(
        [SQLKeywords.select, expression, SQLKeywords.from, this.tableName]);
    return builder.join(SQLTypes.separator);
  }

  String update(List<String> setter) {
    var builder = <String>[];
    builder.addAll([
      SQLKeywords.update,
      this.tableName,
      SQLKeywords.set,
      setter.join(SQLTypes.comma)
    ]);
    return builder.join(SQLTypes.separator);
  }

  String delete() {
    var builder = <String>[];
    builder.addAll([SQLKeywords.delete, SQLKeywords.from, this.tableName]);
    return builder.join(SQLTypes.separator);
  }

  String insert(List<String> fields, List<String> values) {
    var builder = <String>[];
    builder.addAll([
      SQLKeywords.insert,
      this.tableName,
      fields.join(SQLTypes.comma).inBrackets(),
      SQLKeywords.values,
      values.join(SQLTypes.comma).inBrackets()
    ]);
    return builder.join(SQLTypes.separator);
  }

  String drop() {
    return SQLKeywords.dropTable + SQLTypes.separator + this.tableName;
  }
}

extension SQLHelper on String {
  String where(String expression) {
    var builder = <String>[this];
    if (expression != null && expression.isNotEmpty) {
      builder.addAll([SQLKeywords.where, expression]);
    }
    return builder.join(SQLTypes.separator);
  }

  String orderBy(List<Field> fields, SQLSortOrder order) {
    var builder = <String>[this];
    var sortOrder = (order == SQLSortOrder.Ascending)
        ? SQLKeywords.ascending
        : SQLKeywords.descending;
    if (fields != null &&
        fields.length != null &&
        fields.any((f) => f != null)) {
      builder.addAll(
          [SQLKeywords.orderBy, fields.map((f) => f.name).join(SQLTypes.comma), sortOrder]);
    }
    return builder.join(SQLTypes.separator);
  }

  String orderByAsc(List<Field> fields) {
    return orderBy(fields, SQLSortOrder.Ascending);
  }

  String orderByDesc(List<Field> fields) {
    return orderBy(fields, SQLSortOrder.Descending);
  }

  String inBrackets() {
    return SQLTypes.bracketOpen + this + SQLTypes.bracketClose;
  }

  String group(String expression) {
    return this + SQLTypes.separator + expression.inBrackets();
  }

  String or(String expression) {
    return this + SQLTypes.separator + SQLKeywords.or + SQLTypes.separator + expression;
  }

  String and(String expression) {
    return this + SQLTypes.separator + SQLKeywords.and + SQLTypes.separator + expression;
  }

  String limit(int maxValues) {
    return this + SQLTypes.separator + SQLKeywords.limit + SQLTypes.separator + maxValues.toString();
  }

  String offset(int start) {
    return this + SQLTypes.separator + SQLKeywords.offset + SQLTypes.separator + start.toString();
  }
}

extension FieldHelper on Field {
  String compare(dynamic value, SQLComparators comparator) {
    String comparatorValue;

    switch (comparator) {
      case SQLComparators.Equals:
        comparatorValue = SQLTypes.eq;
        break;
      case SQLComparators.Greater:
        comparatorValue = SQLTypes.gt;
        break;
      case SQLComparators.Lower:
        comparatorValue = SQLTypes.lt;
        break;
      case SQLComparators.GreaterOrEqual:
        comparatorValue = SQLTypes.gt + SQLTypes.eq;
        break;
      case SQLComparators.LowerOrEqual:
        comparatorValue = SQLTypes.lt + SQLTypes.eq;
        break;
      case SQLComparators.Like:
        comparatorValue = SQLTypes.like;
        break;
      case SQLComparators.NotEquals:
        comparatorValue = SQLTypes.not + SQLTypes.eq;
    }

    var builder = <String>[];
    builder.addAll([this.name, comparatorValue, this.toSql(value)]);
    return builder.join(SQLTypes.separator);
  }

  String compareField(Field field, SQLComparators comparator) {
    return this.compare(field.toSqlCompatibleValue(), comparator);
  }

  String equals(dynamic value) {
    return compare(value, SQLComparators.Equals);
  }

  String equalsField(Field value) {
    return compare(value.toSqlCompatibleValue(), SQLComparators.Equals);
  }

  String notEquals(dynamic value) {
    return compare(value, SQLComparators.NotEquals);
  }

  String notEqualsField(Field field) {
    return compare(field.toSqlCompatibleValue(), SQLComparators.NotEquals);
  }

  String gt(dynamic value) {
    return compare(value, SQLComparators.Greater);
  }

  String gte(dynamic value) {
    return compare(value, SQLComparators.GreaterOrEqual);
  }

  String lt(dynamic value) {
    return compare(value, SQLComparators.Lower);
  }

  String lte(dynamic value) {
    return compare(value, SQLComparators.LowerOrEqual);
  }
}

enum SQLSortOrder { Ascending, Descending }

enum SQLComparators {
  Equals,
  Greater,
  Lower,
  Like,
  GreaterOrEqual,
  LowerOrEqual,
  NotEquals
}
