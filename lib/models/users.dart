import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get email => text().unique()();

  TextColumn get password => text().withLength(min: 6)();

  TextColumn get refreshtoken => text().unique()();

  TextColumn get activationLink => text()();

  BoolColumn get isActivated => boolean().withDefault(const Constant(false))();

  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
