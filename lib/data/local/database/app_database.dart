import 'package:drift/drift.dart';
import 'connection.dart' if (dart.library.html) 'connection_web.dart';

part 'app_database.g.dart';

// ===== جدول المستخدمين =====
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get phone => text().unique()();
  TextColumn get businessName => text()();
  TextColumn get businessType => text()();
  TextColumn get city => text()();
  TextColumn get plan => text().withDefault(const Constant('free'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ===== جدول المنتجات =====
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get barcode => text().nullable()();
  RealColumn get buyPrice => real()();
  RealColumn get sellPrice => real()();
  IntColumn get stockQty => integer().withDefault(const Constant(0))();
  IntColumn get minStock => integer().withDefault(const Constant(5))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ===== جدول الزبائن =====
class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  RealColumn get totalDebt => real().withDefault(const Constant(0))();
  DateTimeColumn get lastPaymentDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ===== جدول المعاملات =====
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get customerId => text().nullable()();
  TextColumn get productId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get payment => text()();
  RealColumn get amount => real()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// ===== جدول السجل الائتماني =====
class CreditProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get score => integer().withDefault(const Constant(0))();
  IntColumn get monthsActive => integer().withDefault(const Constant(0))();
  RealColumn get avgMonthlyRevenue => real().withDefault(const Constant(0))();
  TextColumn get shareToken => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Users, Products, Customers, Transactions, CreditProfiles],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
