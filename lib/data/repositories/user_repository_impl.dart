import 'package:drift/drift.dart';
import '../../domain/entities/app_user.dart' as entity;
import '../../domain/repositories/user_repository.dart';
import '../local/daos/user_dao.dart';
import '../local/database/app_database.dart';

/// قيم افتراضية مؤقتة لحساب جديد — لا توجد شاشة onboarding بعد.
/// المستخدم يستطيع تعديلها من الإعدادات عبر [updateBusinessInfo].
const _defaultBusinessName = 'متجري';
const _defaultBusinessType = 'عام';
const _defaultCity = '—';

class UserRepositoryImpl implements UserRepository {
  final UserDao dao;
  UserRepositoryImpl(this.dao);

  entity.AppUser _toEntity(User row) {
    return entity.AppUser(
      id: row.id,
      phone: row.phone,
      businessName: row.businessName,
      businessType: row.businessType,
      city: row.city,
      plan: row.plan,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<entity.AppUser> ensureExists(String phone) async {
    final existing = await dao.getByPhone(phone);
    if (existing != null) return _toEntity(existing);

    // id = رقم الهاتف — يطابق افتراض userId المستخدم في بقية التطبيق
    // (راجع .ai/STATE.md: "userId = phone number string")
    final companion = UsersCompanion.insert(
      id: phone,
      phone: phone,
      businessName: _defaultBusinessName,
      businessType: _defaultBusinessType,
      city: _defaultCity,
      createdAt: DateTime.now(),
    );
    await dao.insertUser(companion);

    final created = await dao.getByPhone(phone);
    return _toEntity(created!);
  }

  @override
  Future<entity.AppUser?> getById(String id) async {
    final row = await dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> updateBusinessInfo({
    required String id,
    required String businessName,
    required String businessType,
    required String city,
  }) {
    return dao.updateBusinessInfo(
      id: id,
      businessName: businessName,
      businessType: businessType,
      city: city,
    );
  }
}
