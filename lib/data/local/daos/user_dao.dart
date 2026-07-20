import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<int> insertUser(UsersCompanion entry) {
    return into(users).insert(entry);
  }

  Future<bool> updateUser(UsersCompanion entry) {
    return update(users).replace(entry);
  }

  Future<User?> getById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Future<User?> getByPhone(String phone) {
    return (select(users)..where((u) => u.phone.equals(phone)))
        .getSingleOrNull();
  }

  /// يحدّث بيانات النشاط التجاري — تُستخدم من شاشة الإعدادات لاحقاً
  Future<void> updateBusinessInfo({
    required String id,
    required String businessName,
    required String businessType,
    required String city,
  }) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(
        businessName: Value(businessName),
        businessType: Value(businessType),
        city: Value(city),
      ),
    );
  }
}
