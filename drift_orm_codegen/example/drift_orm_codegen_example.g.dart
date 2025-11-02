// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_orm_codegen_example.dart';

// ignore_for_file: type=lint
mixin $TodoAutosTableToColumns implements Insertable<TodoAuto> {
  int get id;
  String get title;
  String get content;
  DateTime? get createdAt;
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(content);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }
}

class $TodoAutosTable extends TodoAutos
    with TableInfo<$TodoAutosTable, TodoAuto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoAutosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, title, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_autos';
  @override
  VerificationContext validateIntegrity(Insertable<TodoAuto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['body']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoAuto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoAuto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $TodoAutosTable createAlias(String alias) {
    return $TodoAutosTable(attachedDatabase, alias);
  }
}

class TodoAuto extends DataClass with $TodoAutosTableToColumns {
  @override
  final int id;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime? createdAt;
  const TodoAuto(
      {required this.id,
      required this.title,
      required this.content,
      this.createdAt});
  TodoAutosCompanion toCompanion(bool nullToAbsent) {
    return TodoAutosCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory TodoAuto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoAuto(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  TodoAuto copyWith(
          {int? id,
          String? title,
          String? content,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      TodoAuto(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  TodoAuto copyWithCompanion(TodoAutosCompanion data) {
    return TodoAuto(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoAuto(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoAuto &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class TodoAutosCompanion extends UpdateCompanion<TodoAuto> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime?> createdAt;
  const TodoAutosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TodoAutosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    this.createdAt = const Value.absent(),
  })  : title = Value(title),
        content = Value(content);
  static Insertable<TodoAuto> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'body': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TodoAutosCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? content,
      Value<DateTime?>? createdAt}) {
    return TodoAutosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['body'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoAutosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

mixin $TodoCustomsTableToColumns implements Insertable<TodoCustom> {
  int get id;
  String get title;
  String get content;
  DateTime? get createdAt;
  Duration? get duration;
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(content);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] =
          Variable<int>($TodoCustomsTable.$converterdurationn.toSql(duration));
    }
    return map;
  }
}

class $TodoCustomsTable extends TodoCustoms
    with TableInfo<$TodoCustomsTable, TodoCustom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoCustomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Duration?, int> duration =
      GeneratedColumn<int>('duration', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<Duration?>($TodoCustomsTable.$converterdurationn);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, content, createdAt, duration];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_customs';
  @override
  VerificationContext validateIntegrity(Insertable<TodoCustom> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['body']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoCustom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoCustom(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $TodoCustomsTable createAlias(String alias) {
    return $TodoCustomsTable(attachedDatabase, alias);
  }

  static TypeConverter<Duration, int> $converterduration =
      const DurationConverter();
  static TypeConverter<Duration?, int?> $converterdurationn =
      NullAwareTypeConverter.wrap($converterduration);
}

class TodoCustomsCompanion extends UpdateCompanion<TodoCustom> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime?> createdAt;
  final Value<Duration?> duration;
  const TodoCustomsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.duration = const Value.absent(),
  });
  TodoCustomsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    this.createdAt = const Value.absent(),
    this.duration = const Value.absent(),
  })  : title = Value(title),
        content = Value(content);
  static Insertable<TodoCustom> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? duration,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'body': content,
      if (createdAt != null) 'created_at': createdAt,
      if (duration != null) 'duration': duration,
    });
  }

  TodoCustomsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? content,
      Value<DateTime?>? createdAt,
      Value<Duration?>? duration}) {
    return TodoCustomsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['body'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(
          $TodoCustomsTable.$converterdurationn.toSql(duration.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoCustomsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }
}

mixin $ExtrasTableToColumns implements Insertable<Extra> {
  int get id;
  String? get info;
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    return map;
  }
}

class $ExtrasTable extends Extras with TableInfo<$ExtrasTable, Extra> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtrasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _infoMeta = const VerificationMeta('info');
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, info];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extras';
  @override
  VerificationContext validateIntegrity(Insertable<Extra> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('info')) {
      context.handle(
          _infoMeta, info.isAcceptableOrUnknown(data['info']!, _infoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Extra map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Extra(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
    );
  }

  @override
  $ExtrasTable createAlias(String alias) {
    return $ExtrasTable(attachedDatabase, alias);
  }
}

class ExtrasCompanion extends UpdateCompanion<Extra> {
  final Value<int> id;
  final Value<String?> info;
  const ExtrasCompanion({
    this.id = const Value.absent(),
    this.info = const Value.absent(),
  });
  ExtrasCompanion.insert({
    this.id = const Value.absent(),
    this.info = const Value.absent(),
  });
  static Insertable<Extra> custom({
    Expression<int>? id,
    Expression<String>? info,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (info != null) 'info': info,
    });
  }

  ExtrasCompanion copyWith({Value<int>? id, Value<String?>? info}) {
    return ExtrasCompanion(
      id: id ?? this.id,
      info: info ?? this.info,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtrasCompanion(')
          ..write('id: $id, ')
          ..write('info: $info')
          ..write(')'))
        .toString();
  }
}

mixin $TodoOrmsTableToColumns implements Insertable<TodoOrm> {
  String get id;
  DateTime? get createdAt;
  bool? get isDone;
  int? get extraFieldId;
  bool? get isDeleted;
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] =
          Variable<int>($TodoOrmsTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || isDone != null) {
      map['is_done'] = Variable<bool>(isDone);
    }
    if (!nullToAbsent || extraFieldId != null) {
      map['extra_field_id'] = Variable<int>(extraFieldId);
    }
    if (!nullToAbsent || isDeleted != null) {
      map['is_deleted'] = Variable<bool>(isDeleted);
    }
    return map;
  }
}

class $TodoOrmsTable extends TodoOrms with TableInfo<$TodoOrmsTable, TodoOrm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoOrmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($TodoOrmsTable.$convertercreatedAtn);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'is_done', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_done" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _extraFieldIdMeta =
      const VerificationMeta('extraFieldId');
  @override
  late final GeneratedColumn<int> extraFieldId = GeneratedColumn<int>(
      'extra_field_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES extras (id)'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, isDone, extraFieldId, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_orms';
  @override
  VerificationContext validateIntegrity(Insertable<TodoOrm> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta));
    }
    if (data.containsKey('extra_field_id')) {
      context.handle(
          _extraFieldIdMeta,
          extraFieldId.isAcceptableOrUnknown(
              data['extra_field_id']!, _extraFieldIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoOrm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoOrm(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: $TodoOrmsTable.$convertercreatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_done']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted']),
    );
  }

  @override
  $TodoOrmsTable createAlias(String alias) {
    return $TodoOrmsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt = const MyConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
}

class TodoOrmsCompanion extends UpdateCompanion<TodoOrm> {
  final Value<String> id;
  final Value<DateTime?> createdAt;
  final Value<bool?> isDone;
  final Value<int?> extraFieldId;
  final Value<bool?> isDeleted;
  final Value<int> rowid;
  const TodoOrmsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDone = const Value.absent(),
    this.extraFieldId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodoOrmsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.isDone = const Value.absent(),
    this.extraFieldId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<TodoOrm> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<bool>? isDone,
    Expression<int>? extraFieldId,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (isDone != null) 'is_done': isDone,
      if (extraFieldId != null) 'extra_field_id': extraFieldId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodoOrmsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime?>? createdAt,
      Value<bool?>? isDone,
      Value<int?>? extraFieldId,
      Value<bool?>? isDeleted,
      Value<int>? rowid}) {
    return TodoOrmsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
      extraFieldId: extraFieldId ?? this.extraFieldId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $TodoOrmsTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (extraFieldId.present) {
      map['extra_field_id'] = Variable<int>(extraFieldId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoOrmsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDone: $isDone, ')
          ..write('extraFieldId: $extraFieldId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodoAutosTable todoAutos = $TodoAutosTable(this);
  late final $TodoCustomsTable todoCustoms = $TodoCustomsTable(this);
  late final $ExtrasTable extras = $ExtrasTable(this);
  late final $TodoOrmsTable todoOrms = $TodoOrmsTable(this);
  late final TodoAutosDao todoAutosDao = TodoAutosDao(this as AppDatabase);
  late final TodoCustomsDao todoCustomsDao =
      TodoCustomsDao(this as AppDatabase);
  late final TodoOrmsDao todoOrmsDao = TodoOrmsDao(this as AppDatabase);
  late final ExtrasDao extrasDao = ExtrasDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [todoAutos, todoCustoms, extras, todoOrms];
}

typedef $$TodoAutosTableCreateCompanionBuilder = TodoAutosCompanion Function({
  Value<int> id,
  required String title,
  required String content,
  Value<DateTime?> createdAt,
});
typedef $$TodoAutosTableUpdateCompanionBuilder = TodoAutosCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> content,
  Value<DateTime?> createdAt,
});

class $$TodoAutosTableFilterComposer
    extends Composer<_$AppDatabase, $TodoAutosTable> {
  $$TodoAutosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TodoAutosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoAutosTable> {
  $$TodoAutosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TodoAutosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoAutosTable> {
  $$TodoAutosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TodoAutosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoAutosTable,
    TodoAuto,
    $$TodoAutosTableFilterComposer,
    $$TodoAutosTableOrderingComposer,
    $$TodoAutosTableAnnotationComposer,
    $$TodoAutosTableCreateCompanionBuilder,
    $$TodoAutosTableUpdateCompanionBuilder,
    (TodoAuto, BaseReferences<_$AppDatabase, $TodoAutosTable, TodoAuto>),
    TodoAuto,
    PrefetchHooks Function()> {
  $$TodoAutosTableTableManager(_$AppDatabase db, $TodoAutosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoAutosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoAutosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoAutosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              TodoAutosCompanion(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String content,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              TodoAutosCompanion.insert(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodoAutosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoAutosTable,
    TodoAuto,
    $$TodoAutosTableFilterComposer,
    $$TodoAutosTableOrderingComposer,
    $$TodoAutosTableAnnotationComposer,
    $$TodoAutosTableCreateCompanionBuilder,
    $$TodoAutosTableUpdateCompanionBuilder,
    (TodoAuto, BaseReferences<_$AppDatabase, $TodoAutosTable, TodoAuto>),
    TodoAuto,
    PrefetchHooks Function()>;
typedef $$TodoCustomsTableCreateCompanionBuilder = TodoCustomsCompanion
    Function({
  Value<int> id,
  required String title,
  required String content,
  Value<DateTime?> createdAt,
  Value<Duration?> duration,
});
typedef $$TodoCustomsTableUpdateCompanionBuilder = TodoCustomsCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> content,
  Value<DateTime?> createdAt,
  Value<Duration?> duration,
});

class $$TodoCustomsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoCustomsTable> {
  $$TodoCustomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Duration?, Duration, int> get duration =>
      $composableBuilder(
          column: $table.duration,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$TodoCustomsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoCustomsTable> {
  $$TodoCustomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));
}

class $$TodoCustomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoCustomsTable> {
  $$TodoCustomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Duration?, int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);
}

class $$TodoCustomsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoCustomsTable,
    TodoCustom,
    $$TodoCustomsTableFilterComposer,
    $$TodoCustomsTableOrderingComposer,
    $$TodoCustomsTableAnnotationComposer,
    $$TodoCustomsTableCreateCompanionBuilder,
    $$TodoCustomsTableUpdateCompanionBuilder,
    (TodoCustom, BaseReferences<_$AppDatabase, $TodoCustomsTable, TodoCustom>),
    TodoCustom,
    PrefetchHooks Function()> {
  $$TodoCustomsTableTableManager(_$AppDatabase db, $TodoCustomsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoCustomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoCustomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoCustomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<Duration?> duration = const Value.absent(),
          }) =>
              TodoCustomsCompanion(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            duration: duration,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String content,
            Value<DateTime?> createdAt = const Value.absent(),
            Value<Duration?> duration = const Value.absent(),
          }) =>
              TodoCustomsCompanion.insert(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            duration: duration,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodoCustomsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoCustomsTable,
    TodoCustom,
    $$TodoCustomsTableFilterComposer,
    $$TodoCustomsTableOrderingComposer,
    $$TodoCustomsTableAnnotationComposer,
    $$TodoCustomsTableCreateCompanionBuilder,
    $$TodoCustomsTableUpdateCompanionBuilder,
    (TodoCustom, BaseReferences<_$AppDatabase, $TodoCustomsTable, TodoCustom>),
    TodoCustom,
    PrefetchHooks Function()>;
typedef $$ExtrasTableCreateCompanionBuilder = ExtrasCompanion Function({
  Value<int> id,
  Value<String?> info,
});
typedef $$ExtrasTableUpdateCompanionBuilder = ExtrasCompanion Function({
  Value<int> id,
  Value<String?> info,
});

final class $$ExtrasTableReferences
    extends BaseReferences<_$AppDatabase, $ExtrasTable, Extra> {
  $$ExtrasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TodoOrmsTable, List<TodoOrm>> _todoOrmsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.todoOrms,
          aliasName:
              $_aliasNameGenerator(db.extras.id, db.todoOrms.extraFieldId));

  $$TodoOrmsTableProcessedTableManager get todoOrmsRefs {
    final manager = $$TodoOrmsTableTableManager($_db, $_db.todoOrms)
        .filter((f) => f.extraFieldId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_todoOrmsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExtrasTableFilterComposer
    extends Composer<_$AppDatabase, $ExtrasTable> {
  $$ExtrasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get info => $composableBuilder(
      column: $table.info, builder: (column) => ColumnFilters(column));

  Expression<bool> todoOrmsRefs(
      Expression<bool> Function($$TodoOrmsTableFilterComposer f) f) {
    final $$TodoOrmsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.todoOrms,
        getReferencedColumn: (t) => t.extraFieldId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodoOrmsTableFilterComposer(
              $db: $db,
              $table: $db.todoOrms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExtrasTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtrasTable> {
  $$ExtrasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get info => $composableBuilder(
      column: $table.info, builder: (column) => ColumnOrderings(column));
}

class $$ExtrasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtrasTable> {
  $$ExtrasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get info =>
      $composableBuilder(column: $table.info, builder: (column) => column);

  Expression<T> todoOrmsRefs<T extends Object>(
      Expression<T> Function($$TodoOrmsTableAnnotationComposer a) f) {
    final $$TodoOrmsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.todoOrms,
        getReferencedColumn: (t) => t.extraFieldId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodoOrmsTableAnnotationComposer(
              $db: $db,
              $table: $db.todoOrms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExtrasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExtrasTable,
    Extra,
    $$ExtrasTableFilterComposer,
    $$ExtrasTableOrderingComposer,
    $$ExtrasTableAnnotationComposer,
    $$ExtrasTableCreateCompanionBuilder,
    $$ExtrasTableUpdateCompanionBuilder,
    (Extra, $$ExtrasTableReferences),
    Extra,
    PrefetchHooks Function({bool todoOrmsRefs})> {
  $$ExtrasTableTableManager(_$AppDatabase db, $ExtrasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtrasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtrasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExtrasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> info = const Value.absent(),
          }) =>
              ExtrasCompanion(
            id: id,
            info: info,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> info = const Value.absent(),
          }) =>
              ExtrasCompanion.insert(
            id: id,
            info: info,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ExtrasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({todoOrmsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (todoOrmsRefs) db.todoOrms],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (todoOrmsRefs)
                    await $_getPrefetchedData<Extra, $ExtrasTable, TodoOrm>(
                        currentTable: table,
                        referencedTable:
                            $$ExtrasTableReferences._todoOrmsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExtrasTableReferences(db, table, p0).todoOrmsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.extraFieldId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExtrasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExtrasTable,
    Extra,
    $$ExtrasTableFilterComposer,
    $$ExtrasTableOrderingComposer,
    $$ExtrasTableAnnotationComposer,
    $$ExtrasTableCreateCompanionBuilder,
    $$ExtrasTableUpdateCompanionBuilder,
    (Extra, $$ExtrasTableReferences),
    Extra,
    PrefetchHooks Function({bool todoOrmsRefs})>;
typedef $$TodoOrmsTableCreateCompanionBuilder = TodoOrmsCompanion Function({
  required String id,
  Value<DateTime?> createdAt,
  Value<bool?> isDone,
  Value<int?> extraFieldId,
  Value<bool?> isDeleted,
  Value<int> rowid,
});
typedef $$TodoOrmsTableUpdateCompanionBuilder = TodoOrmsCompanion Function({
  Value<String> id,
  Value<DateTime?> createdAt,
  Value<bool?> isDone,
  Value<int?> extraFieldId,
  Value<bool?> isDeleted,
  Value<int> rowid,
});

final class $$TodoOrmsTableReferences
    extends BaseReferences<_$AppDatabase, $TodoOrmsTable, TodoOrm> {
  $$TodoOrmsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExtrasTable _extraFieldIdTable(_$AppDatabase db) =>
      db.extras.createAlias(
          $_aliasNameGenerator(db.todoOrms.extraFieldId, db.extras.id));

  $$ExtrasTableProcessedTableManager? get extraFieldId {
    final $_column = $_itemColumn<int>('extra_field_id');
    if ($_column == null) return null;
    final manager = $$ExtrasTableTableManager($_db, $_db.extras)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_extraFieldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TodoOrmsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoOrmsTable> {
  $$TodoOrmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  $$ExtrasTableFilterComposer get extraFieldId {
    final $$ExtrasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.extraFieldId,
        referencedTable: $db.extras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasTableFilterComposer(
              $db: $db,
              $table: $db.extras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TodoOrmsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoOrmsTable> {
  $$TodoOrmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  $$ExtrasTableOrderingComposer get extraFieldId {
    final $$ExtrasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.extraFieldId,
        referencedTable: $db.extras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasTableOrderingComposer(
              $db: $db,
              $table: $db.extras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TodoOrmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoOrmsTable> {
  $$TodoOrmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$ExtrasTableAnnotationComposer get extraFieldId {
    final $$ExtrasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.extraFieldId,
        referencedTable: $db.extras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasTableAnnotationComposer(
              $db: $db,
              $table: $db.extras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TodoOrmsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoOrmsTable,
    TodoOrm,
    $$TodoOrmsTableFilterComposer,
    $$TodoOrmsTableOrderingComposer,
    $$TodoOrmsTableAnnotationComposer,
    $$TodoOrmsTableCreateCompanionBuilder,
    $$TodoOrmsTableUpdateCompanionBuilder,
    (TodoOrm, $$TodoOrmsTableReferences),
    TodoOrm,
    PrefetchHooks Function({bool extraFieldId})> {
  $$TodoOrmsTableTableManager(_$AppDatabase db, $TodoOrmsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoOrmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoOrmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoOrmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<bool?> isDone = const Value.absent(),
            Value<int?> extraFieldId = const Value.absent(),
            Value<bool?> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodoOrmsCompanion(
            id: id,
            createdAt: createdAt,
            isDone: isDone,
            extraFieldId: extraFieldId,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime?> createdAt = const Value.absent(),
            Value<bool?> isDone = const Value.absent(),
            Value<int?> extraFieldId = const Value.absent(),
            Value<bool?> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodoOrmsCompanion.insert(
            id: id,
            createdAt: createdAt,
            isDone: isDone,
            extraFieldId: extraFieldId,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TodoOrmsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({extraFieldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (extraFieldId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.extraFieldId,
                    referencedTable:
                        $$TodoOrmsTableReferences._extraFieldIdTable(db),
                    referencedColumn:
                        $$TodoOrmsTableReferences._extraFieldIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TodoOrmsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoOrmsTable,
    TodoOrm,
    $$TodoOrmsTableFilterComposer,
    $$TodoOrmsTableOrderingComposer,
    $$TodoOrmsTableAnnotationComposer,
    $$TodoOrmsTableCreateCompanionBuilder,
    $$TodoOrmsTableUpdateCompanionBuilder,
    (TodoOrm, $$TodoOrmsTableReferences),
    TodoOrm,
    PrefetchHooks Function({bool extraFieldId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodoAutosTableTableManager get todoAutos =>
      $$TodoAutosTableTableManager(_db, _db.todoAutos);
  $$TodoCustomsTableTableManager get todoCustoms =>
      $$TodoCustomsTableTableManager(_db, _db.todoCustoms);
  $$ExtrasTableTableManager get extras =>
      $$ExtrasTableTableManager(_db, _db.extras);
  $$TodoOrmsTableTableManager get todoOrms =>
      $$TodoOrmsTableTableManager(_db, _db.todoOrms);
}
