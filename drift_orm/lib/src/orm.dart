import 'package:drift/drift.dart';

typedef WhereFilter<T extends Table> = Expression<bool> Function(T table);
