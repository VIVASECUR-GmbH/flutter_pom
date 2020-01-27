/*
BSD 2-Clause License

Copyright (c) 2020, VIVASECUR GmbH
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import 'package:flutter_pom/builder/query_builder.dart';
import 'package:flutter_pom/builder/selectors/sql_condition.dart';
import 'package:flutter_pom/builder/selectors/sql_where_selector.dart';
import 'package:flutter_pom/model/sql_types.dart';
import 'package:flutter_pom/model/table.dart';

class QueryCountBuilder extends QueryBuilder {
  SQLWhereSelector _whereSelector;

  QueryCountBuilder(Table table) : super(table);

  QueryCountBuilder where(SQLCondition condition) {
    if (_whereSelector != null)
      throw UnsupportedError("There is already a 'where' clause defined");

    _whereSelector = SQLWhereSelector(condition);
    return this;
  }

  String toSql() {
    var builder = <String>[];
    builder.addAll([
      SQLKeywords.select,
      SQLKeywords.count,
      SQLKeywords.allSelector.inBrackets(),
      SQLKeywords.from,
      table.tableName
    ]);

    if (_whereSelector != null) {
      builder.add(_whereSelector.toSql());
    }

    return builder.join(SQLTypes.separator);
  }
}
