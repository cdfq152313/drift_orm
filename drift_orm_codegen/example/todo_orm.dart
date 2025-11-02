import 'package:drift/drift.dart';
import 'package:drift_orm/drift_orm.dart';

import 'drift_orm_codegen_example.dart';

part 'todo_orm.drift_orm.g.dart';
part 'todo_orm.g.dart';

mixin DeletedColumnMixin {
  @EntityColumn(defaultValue: false)
  bool isDeleted = false;
}

@Entity()
class TodoOrm
    with _$TodoOrmOrmRowMixin, $TodoOrmsTableToColumns, DeletedColumnMixin {
  @EntityPrimaryKey()
  String id;

  @EntityColumn(converter: MyConverter)
  DateTime? createdAt;

  @EntityColumn(defaultValue: false)
  bool isDone;

  @EntityToOne()
  Extra? extraField;

  TodoOrm({
    required this.id,
    this.createdAt,
    bool? isDone,
    this.extraField,
    bool? isDeleted,
  }) : isDone = isDone ?? false {
    this.isDeleted = isDeleted ?? false;
  }
}

@Entity()
class Extra with _$ExtraOrmRowMixin, $ExtrasTableToColumns {
  @EntityPrimaryKey()
  int id;

  @EntityColumn()
  String? info;
  Extra({required this.id, this.info});
}

class MyConverter extends TypeConverter<DateTime, int> {
  const MyConverter();

  @override
  DateTime fromSql(int fromDb) {
    return DateTime.fromMillisecondsSinceEpoch(fromDb);
  }

  @override
  int toSql(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

@DriftAccessor(tables: [TodoOrms])
class TodoOrmsDao extends DatabaseAccessor<AppDatabase>
    with _$TodoOrmsDaoMixin, _$TodoOrmsOrmMixin {
  TodoOrmsDao(super.db);
}

@DriftAccessor(tables: [Extras])
class ExtrasDao extends DatabaseAccessor<AppDatabase>
    with _$ExtrasDaoMixin, _$ExtrasOrmMixin {
  ExtrasDao(super.db);
}
