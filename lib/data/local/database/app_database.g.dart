// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessTypeMeta =
      const VerificationMeta('businessType');
  @override
  late final GeneratedColumn<String> businessType = GeneratedColumn<String>(
      'business_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
      'plan', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('free'));
  static const VerificationMeta _baseCurrencyCodeMeta =
      const VerificationMeta('baseCurrencyCode');
  @override
  late final GeneratedColumn<String> baseCurrencyCode = GeneratedColumn<String>(
      'base_currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('YER'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        phone,
        businessName,
        businessType,
        city,
        plan,
        baseCurrencyCode,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('business_type')) {
      context.handle(
          _businessTypeMeta,
          businessType.isAcceptableOrUnknown(
              data['business_type']!, _businessTypeMeta));
    } else if (isInserting) {
      context.missing(_businessTypeMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('plan')) {
      context.handle(
          _planMeta, plan.isAcceptableOrUnknown(data['plan']!, _planMeta));
    }
    if (data.containsKey('base_currency_code')) {
      context.handle(
          _baseCurrencyCodeMeta,
          baseCurrencyCode.isAcceptableOrUnknown(
              data['base_currency_code']!, _baseCurrencyCodeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name'])!,
      businessType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_type'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      plan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan'])!,
      baseCurrencyCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}base_currency_code'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String phone;
  final String businessName;
  final String businessType;
  final String city;
  final String plan;
  final String baseCurrencyCode;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.phone,
      required this.businessName,
      required this.businessType,
      required this.city,
      required this.plan,
      required this.baseCurrencyCode,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone'] = Variable<String>(phone);
    map['business_name'] = Variable<String>(businessName);
    map['business_type'] = Variable<String>(businessType);
    map['city'] = Variable<String>(city);
    map['plan'] = Variable<String>(plan);
    map['base_currency_code'] = Variable<String>(baseCurrencyCode);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      phone: Value(phone),
      businessName: Value(businessName),
      businessType: Value(businessType),
      city: Value(city),
      plan: Value(plan),
      baseCurrencyCode: Value(baseCurrencyCode),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      businessName: serializer.fromJson<String>(json['businessName']),
      businessType: serializer.fromJson<String>(json['businessType']),
      city: serializer.fromJson<String>(json['city']),
      plan: serializer.fromJson<String>(json['plan']),
      baseCurrencyCode: serializer.fromJson<String>(json['baseCurrencyCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phone': serializer.toJson<String>(phone),
      'businessName': serializer.toJson<String>(businessName),
      'businessType': serializer.toJson<String>(businessType),
      'city': serializer.toJson<String>(city),
      'plan': serializer.toJson<String>(plan),
      'baseCurrencyCode': serializer.toJson<String>(baseCurrencyCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {String? id,
          String? phone,
          String? businessName,
          String? businessType,
          String? city,
          String? plan,
          String? baseCurrencyCode,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        businessName: businessName ?? this.businessName,
        businessType: businessType ?? this.businessType,
        city: city ?? this.city,
        plan: plan ?? this.plan,
        baseCurrencyCode: baseCurrencyCode ?? this.baseCurrencyCode,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      businessType: data.businessType.present
          ? data.businessType.value
          : this.businessType,
      city: data.city.present ? data.city.value : this.city,
      plan: data.plan.present ? data.plan.value : this.plan,
      baseCurrencyCode: data.baseCurrencyCode.present
          ? data.baseCurrencyCode.value
          : this.baseCurrencyCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('businessName: $businessName, ')
          ..write('businessType: $businessType, ')
          ..write('city: $city, ')
          ..write('plan: $plan, ')
          ..write('baseCurrencyCode: $baseCurrencyCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phone, businessName, businessType, city,
      plan, baseCurrencyCode, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.businessName == this.businessName &&
          other.businessType == this.businessType &&
          other.city == this.city &&
          other.plan == this.plan &&
          other.baseCurrencyCode == this.baseCurrencyCode &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> phone;
  final Value<String> businessName;
  final Value<String> businessType;
  final Value<String> city;
  final Value<String> plan;
  final Value<String> baseCurrencyCode;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.businessName = const Value.absent(),
    this.businessType = const Value.absent(),
    this.city = const Value.absent(),
    this.plan = const Value.absent(),
    this.baseCurrencyCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String phone,
    required String businessName,
    required String businessType,
    required String city,
    this.plan = const Value.absent(),
    this.baseCurrencyCode = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        phone = Value(phone),
        businessName = Value(businessName),
        businessType = Value(businessType),
        city = Value(city),
        createdAt = Value(createdAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? phone,
    Expression<String>? businessName,
    Expression<String>? businessType,
    Expression<String>? city,
    Expression<String>? plan,
    Expression<String>? baseCurrencyCode,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (businessName != null) 'business_name': businessName,
      if (businessType != null) 'business_type': businessType,
      if (city != null) 'city': city,
      if (plan != null) 'plan': plan,
      if (baseCurrencyCode != null) 'base_currency_code': baseCurrencyCode,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? phone,
      Value<String>? businessName,
      Value<String>? businessType,
      Value<String>? city,
      Value<String>? plan,
      Value<String>? baseCurrencyCode,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      city: city ?? this.city,
      plan: plan ?? this.plan,
      baseCurrencyCode: baseCurrencyCode ?? this.baseCurrencyCode,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (businessType.present) {
      map['business_type'] = Variable<String>(businessType.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (baseCurrencyCode.present) {
      map['base_currency_code'] = Variable<String>(baseCurrencyCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('businessName: $businessName, ')
          ..write('businessType: $businessType, ')
          ..write('city: $city, ')
          ..write('plan: $plan, ')
          ..write('baseCurrencyCode: $baseCurrencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buyPriceMeta =
      const VerificationMeta('buyPrice');
  @override
  late final GeneratedColumn<double> buyPrice = GeneratedColumn<double>(
      'buy_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sellPriceMeta =
      const VerificationMeta('sellPrice');
  @override
  late final GeneratedColumn<double> sellPrice = GeneratedColumn<double>(
      'sell_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stockQtyMeta =
      const VerificationMeta('stockQty');
  @override
  late final GeneratedColumn<int> stockQty = GeneratedColumn<int>(
      'stock_qty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minStockMeta =
      const VerificationMeta('minStock');
  @override
  late final GeneratedColumn<int> minStock = GeneratedColumn<int>(
      'min_stock', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        name,
        barcode,
        buyPrice,
        sellPrice,
        stockQty,
        minStock,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('buy_price')) {
      context.handle(_buyPriceMeta,
          buyPrice.isAcceptableOrUnknown(data['buy_price']!, _buyPriceMeta));
    } else if (isInserting) {
      context.missing(_buyPriceMeta);
    }
    if (data.containsKey('sell_price')) {
      context.handle(_sellPriceMeta,
          sellPrice.isAcceptableOrUnknown(data['sell_price']!, _sellPriceMeta));
    } else if (isInserting) {
      context.missing(_sellPriceMeta);
    }
    if (data.containsKey('stock_qty')) {
      context.handle(_stockQtyMeta,
          stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta));
    }
    if (data.containsKey('min_stock')) {
      context.handle(_minStockMeta,
          minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      buyPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}buy_price'])!,
      sellPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sell_price'])!,
      stockQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_qty'])!,
      minStock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}min_stock'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String userId;
  final String name;
  final String? barcode;
  final double buyPrice;
  final double sellPrice;
  final int stockQty;
  final int minStock;
  final DateTime createdAt;
  const Product(
      {required this.id,
      required this.userId,
      required this.name,
      this.barcode,
      required this.buyPrice,
      required this.sellPrice,
      required this.stockQty,
      required this.minStock,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['buy_price'] = Variable<double>(buyPrice);
    map['sell_price'] = Variable<double>(sellPrice);
    map['stock_qty'] = Variable<int>(stockQty);
    map['min_stock'] = Variable<int>(minStock);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      buyPrice: Value(buyPrice),
      sellPrice: Value(sellPrice),
      stockQty: Value(stockQty),
      minStock: Value(minStock),
      createdAt: Value(createdAt),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      buyPrice: serializer.fromJson<double>(json['buyPrice']),
      sellPrice: serializer.fromJson<double>(json['sellPrice']),
      stockQty: serializer.fromJson<int>(json['stockQty']),
      minStock: serializer.fromJson<int>(json['minStock']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'buyPrice': serializer.toJson<double>(buyPrice),
      'sellPrice': serializer.toJson<double>(sellPrice),
      'stockQty': serializer.toJson<int>(stockQty),
      'minStock': serializer.toJson<int>(minStock),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Product copyWith(
          {String? id,
          String? userId,
          String? name,
          Value<String?> barcode = const Value.absent(),
          double? buyPrice,
          double? sellPrice,
          int? stockQty,
          int? minStock,
          DateTime? createdAt}) =>
      Product(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        barcode: barcode.present ? barcode.value : this.barcode,
        buyPrice: buyPrice ?? this.buyPrice,
        sellPrice: sellPrice ?? this.sellPrice,
        stockQty: stockQty ?? this.stockQty,
        minStock: minStock ?? this.minStock,
        createdAt: createdAt ?? this.createdAt,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      buyPrice: data.buyPrice.present ? data.buyPrice.value : this.buyPrice,
      sellPrice: data.sellPrice.present ? data.sellPrice.value : this.sellPrice,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('buyPrice: $buyPrice, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('minStock: $minStock, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, name, barcode, buyPrice,
      sellPrice, stockQty, minStock, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.buyPrice == this.buyPrice &&
          other.sellPrice == this.sellPrice &&
          other.stockQty == this.stockQty &&
          other.minStock == this.minStock &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<double> buyPrice;
  final Value<double> sellPrice;
  final Value<int> stockQty;
  final Value<int> minStock;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.buyPrice = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.minStock = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.barcode = const Value.absent(),
    required double buyPrice,
    required double sellPrice,
    this.stockQty = const Value.absent(),
    this.minStock = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        buyPrice = Value(buyPrice),
        sellPrice = Value(sellPrice),
        createdAt = Value(createdAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<double>? buyPrice,
    Expression<double>? sellPrice,
    Expression<int>? stockQty,
    Expression<int>? minStock,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (buyPrice != null) 'buy_price': buyPrice,
      if (sellPrice != null) 'sell_price': sellPrice,
      if (stockQty != null) 'stock_qty': stockQty,
      if (minStock != null) 'min_stock': minStock,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String?>? barcode,
      Value<double>? buyPrice,
      Value<double>? sellPrice,
      Value<int>? stockQty,
      Value<int>? minStock,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ProductsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      stockQty: stockQty ?? this.stockQty,
      minStock: minStock ?? this.minStock,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (buyPrice.present) {
      map['buy_price'] = Variable<double>(buyPrice.value);
    }
    if (sellPrice.present) {
      map['sell_price'] = Variable<double>(sellPrice.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<int>(stockQty.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<int>(minStock.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('buyPrice: $buyPrice, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('minStock: $minStock, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalDebtMeta =
      const VerificationMeta('totalDebt');
  @override
  late final GeneratedColumn<double> totalDebt = GeneratedColumn<double>(
      'total_debt', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastPaymentDateMeta =
      const VerificationMeta('lastPaymentDate');
  @override
  late final GeneratedColumn<DateTime> lastPaymentDate =
      GeneratedColumn<DateTime>('last_payment_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, name, phone, totalDebt, lastPaymentDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('total_debt')) {
      context.handle(_totalDebtMeta,
          totalDebt.isAcceptableOrUnknown(data['total_debt']!, _totalDebtMeta));
    }
    if (data.containsKey('last_payment_date')) {
      context.handle(
          _lastPaymentDateMeta,
          lastPaymentDate.isAcceptableOrUnknown(
              data['last_payment_date']!, _lastPaymentDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      totalDebt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_debt'])!,
      lastPaymentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_payment_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String userId;
  final String name;
  final String? phone;
  final double totalDebt;
  final DateTime? lastPaymentDate;
  final DateTime createdAt;
  const Customer(
      {required this.id,
      required this.userId,
      required this.name,
      this.phone,
      required this.totalDebt,
      this.lastPaymentDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['total_debt'] = Variable<double>(totalDebt);
    if (!nullToAbsent || lastPaymentDate != null) {
      map['last_payment_date'] = Variable<DateTime>(lastPaymentDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      totalDebt: Value(totalDebt),
      lastPaymentDate: lastPaymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPaymentDate),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      totalDebt: serializer.fromJson<double>(json['totalDebt']),
      lastPaymentDate: serializer.fromJson<DateTime?>(json['lastPaymentDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'totalDebt': serializer.toJson<double>(totalDebt),
      'lastPaymentDate': serializer.toJson<DateTime?>(lastPaymentDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Customer copyWith(
          {String? id,
          String? userId,
          String? name,
          Value<String?> phone = const Value.absent(),
          double? totalDebt,
          Value<DateTime?> lastPaymentDate = const Value.absent(),
          DateTime? createdAt}) =>
      Customer(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        totalDebt: totalDebt ?? this.totalDebt,
        lastPaymentDate: lastPaymentDate.present
            ? lastPaymentDate.value
            : this.lastPaymentDate,
        createdAt: createdAt ?? this.createdAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      totalDebt: data.totalDebt.present ? data.totalDebt.value : this.totalDebt,
      lastPaymentDate: data.lastPaymentDate.present
          ? data.lastPaymentDate.value
          : this.lastPaymentDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('totalDebt: $totalDebt, ')
          ..write('lastPaymentDate: $lastPaymentDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, name, phone, totalDebt, lastPaymentDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.totalDebt == this.totalDebt &&
          other.lastPaymentDate == this.lastPaymentDate &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<double> totalDebt;
  final Value<DateTime?> lastPaymentDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.totalDebt = const Value.absent(),
    this.lastPaymentDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.phone = const Value.absent(),
    this.totalDebt = const Value.absent(),
    this.lastPaymentDate = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<double>? totalDebt,
    Expression<DateTime>? lastPaymentDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (totalDebt != null) 'total_debt': totalDebt,
      if (lastPaymentDate != null) 'last_payment_date': lastPaymentDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String?>? phone,
      Value<double>? totalDebt,
      Value<DateTime?>? lastPaymentDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CustomersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      totalDebt: totalDebt ?? this.totalDebt,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (totalDebt.present) {
      map['total_debt'] = Variable<double>(totalDebt.value);
    }
    if (lastPaymentDate.present) {
      map['last_payment_date'] = Variable<DateTime>(lastPaymentDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('totalDebt: $totalDebt, ')
          ..write('lastPaymentDate: $lastPaymentDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentMeta =
      const VerificationMeta('payment');
  @override
  late final GeneratedColumn<String> payment = GeneratedColumn<String>(
      'payment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('YER'));
  static const VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _baseAmountMeta =
      const VerificationMeta('baseAmount');
  @override
  late final GeneratedColumn<double> baseAmount = GeneratedColumn<double>(
      'base_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        customerId,
        productId,
        type,
        payment,
        amount,
        currencyCode,
        exchangeRate,
        baseAmount,
        quantity,
        notes,
        createdAt,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payment')) {
      context.handle(_paymentMeta,
          payment.isAcceptableOrUnknown(data['payment']!, _paymentMeta));
    } else if (isInserting) {
      context.missing(_paymentMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate']!, _exchangeRateMeta));
    }
    if (data.containsKey('base_amount')) {
      context.handle(
          _baseAmountMeta,
          baseAmount.isAcceptableOrUnknown(
              data['base_amount']!, _baseAmountMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id']),
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      payment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate'])!,
      baseAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_amount']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String userId;
  final String? customerId;
  final String? productId;
  final String type;
  final String payment;
  final double amount;
  final String currencyCode;
  final double exchangeRate;
  final double? baseAmount;
  final int quantity;
  final String? notes;
  final DateTime createdAt;
  final bool synced;
  const Transaction(
      {required this.id,
      required this.userId,
      this.customerId,
      this.productId,
      required this.type,
      required this.payment,
      required this.amount,
      required this.currencyCode,
      required this.exchangeRate,
      this.baseAmount,
      required this.quantity,
      this.notes,
      required this.createdAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['type'] = Variable<String>(type);
    map['payment'] = Variable<String>(payment);
    map['amount'] = Variable<double>(amount);
    map['currency_code'] = Variable<String>(currencyCode);
    map['exchange_rate'] = Variable<double>(exchangeRate);
    if (!nullToAbsent || baseAmount != null) {
      map['base_amount'] = Variable<double>(baseAmount);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      userId: Value(userId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      type: Value(type),
      payment: Value(payment),
      amount: Value(amount),
      currencyCode: Value(currencyCode),
      exchangeRate: Value(exchangeRate),
      baseAmount: baseAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(baseAmount),
      quantity: Value(quantity),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      productId: serializer.fromJson<String?>(json['productId']),
      type: serializer.fromJson<String>(json['type']),
      payment: serializer.fromJson<String>(json['payment']),
      amount: serializer.fromJson<double>(json['amount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      baseAmount: serializer.fromJson<double?>(json['baseAmount']),
      quantity: serializer.fromJson<int>(json['quantity']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'customerId': serializer.toJson<String?>(customerId),
      'productId': serializer.toJson<String?>(productId),
      'type': serializer.toJson<String>(type),
      'payment': serializer.toJson<String>(payment),
      'amount': serializer.toJson<double>(amount),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'baseAmount': serializer.toJson<double?>(baseAmount),
      'quantity': serializer.toJson<int>(quantity),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Transaction copyWith(
          {String? id,
          String? userId,
          Value<String?> customerId = const Value.absent(),
          Value<String?> productId = const Value.absent(),
          String? type,
          String? payment,
          double? amount,
          String? currencyCode,
          double? exchangeRate,
          Value<double?> baseAmount = const Value.absent(),
          int? quantity,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          bool? synced}) =>
      Transaction(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        customerId: customerId.present ? customerId.value : this.customerId,
        productId: productId.present ? productId.value : this.productId,
        type: type ?? this.type,
        payment: payment ?? this.payment,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        baseAmount: baseAmount.present ? baseAmount.value : this.baseAmount,
        quantity: quantity ?? this.quantity,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      productId: data.productId.present ? data.productId.value : this.productId,
      type: data.type.present ? data.type.value : this.type,
      payment: data.payment.present ? data.payment.value : this.payment,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      baseAmount:
          data.baseAmount.present ? data.baseAmount.value : this.baseAmount,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('customerId: $customerId, ')
          ..write('productId: $productId, ')
          ..write('type: $type, ')
          ..write('payment: $payment, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('baseAmount: $baseAmount, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      customerId,
      productId,
      type,
      payment,
      amount,
      currencyCode,
      exchangeRate,
      baseAmount,
      quantity,
      notes,
      createdAt,
      synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.customerId == this.customerId &&
          other.productId == this.productId &&
          other.type == this.type &&
          other.payment == this.payment &&
          other.amount == this.amount &&
          other.currencyCode == this.currencyCode &&
          other.exchangeRate == this.exchangeRate &&
          other.baseAmount == this.baseAmount &&
          other.quantity == this.quantity &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> customerId;
  final Value<String?> productId;
  final Value<String> type;
  final Value<String> payment;
  final Value<double> amount;
  final Value<String> currencyCode;
  final Value<double> exchangeRate;
  final Value<double?> baseAmount;
  final Value<int> quantity;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.productId = const Value.absent(),
    this.type = const Value.absent(),
    this.payment = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.baseAmount = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String userId,
    this.customerId = const Value.absent(),
    this.productId = const Value.absent(),
    required String type,
    required String payment,
    required double amount,
    this.currencyCode = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.baseAmount = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        type = Value(type),
        payment = Value(payment),
        amount = Value(amount),
        createdAt = Value(createdAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? customerId,
    Expression<String>? productId,
    Expression<String>? type,
    Expression<String>? payment,
    Expression<double>? amount,
    Expression<String>? currencyCode,
    Expression<double>? exchangeRate,
    Expression<double>? baseAmount,
    Expression<int>? quantity,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (customerId != null) 'customer_id': customerId,
      if (productId != null) 'product_id': productId,
      if (type != null) 'type': type,
      if (payment != null) 'payment': payment,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (baseAmount != null) 'base_amount': baseAmount,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String?>? customerId,
      Value<String?>? productId,
      Value<String>? type,
      Value<String>? payment,
      Value<double>? amount,
      Value<String>? currencyCode,
      Value<double>? exchangeRate,
      Value<double?>? baseAmount,
      Value<int>? quantity,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      payment: payment ?? this.payment,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      baseAmount: baseAmount ?? this.baseAmount,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payment.present) {
      map['payment'] = Variable<String>(payment.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (baseAmount.present) {
      map['base_amount'] = Variable<double>(baseAmount.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('customerId: $customerId, ')
          ..write('productId: $productId, ')
          ..write('type: $type, ')
          ..write('payment: $payment, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('baseAmount: $baseAmount, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromCurrencyMeta =
      const VerificationMeta('fromCurrency');
  @override
  late final GeneratedColumn<String> fromCurrency = GeneratedColumn<String>(
      'from_currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toCurrencyMeta =
      const VerificationMeta('toCurrency');
  @override
  late final GeneratedColumn<String> toCurrency = GeneratedColumn<String>(
      'to_currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _effectiveAtMeta =
      const VerificationMeta('effectiveAt');
  @override
  late final GeneratedColumn<DateTime> effectiveAt = GeneratedColumn<DateTime>(
      'effective_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, fromCurrency, toCurrency, rate, effectiveAt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(Insertable<ExchangeRate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('from_currency')) {
      context.handle(
          _fromCurrencyMeta,
          fromCurrency.isAcceptableOrUnknown(
              data['from_currency']!, _fromCurrencyMeta));
    } else if (isInserting) {
      context.missing(_fromCurrencyMeta);
    }
    if (data.containsKey('to_currency')) {
      context.handle(
          _toCurrencyMeta,
          toCurrency.isAcceptableOrUnknown(
              data['to_currency']!, _toCurrencyMeta));
    } else if (isInserting) {
      context.missing(_toCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('effective_at')) {
      context.handle(
          _effectiveAtMeta,
          effectiveAt.isAcceptableOrUnknown(
              data['effective_at']!, _effectiveAtMeta));
    } else if (isInserting) {
      context.missing(_effectiveAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      fromCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_currency'])!,
      toCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_currency'])!,
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate'])!,
      effectiveAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}effective_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final String id;
  final String userId;
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime effectiveAt;
  final DateTime createdAt;
  const ExchangeRate(
      {required this.id,
      required this.userId,
      required this.fromCurrency,
      required this.toCurrency,
      required this.rate,
      required this.effectiveAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['from_currency'] = Variable<String>(fromCurrency);
    map['to_currency'] = Variable<String>(toCurrency);
    map['rate'] = Variable<double>(rate);
    map['effective_at'] = Variable<DateTime>(effectiveAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      userId: Value(userId),
      fromCurrency: Value(fromCurrency),
      toCurrency: Value(toCurrency),
      rate: Value(rate),
      effectiveAt: Value(effectiveAt),
      createdAt: Value(createdAt),
    );
  }

  factory ExchangeRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      fromCurrency: serializer.fromJson<String>(json['fromCurrency']),
      toCurrency: serializer.fromJson<String>(json['toCurrency']),
      rate: serializer.fromJson<double>(json['rate']),
      effectiveAt: serializer.fromJson<DateTime>(json['effectiveAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'fromCurrency': serializer.toJson<String>(fromCurrency),
      'toCurrency': serializer.toJson<String>(toCurrency),
      'rate': serializer.toJson<double>(rate),
      'effectiveAt': serializer.toJson<DateTime>(effectiveAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExchangeRate copyWith(
          {String? id,
          String? userId,
          String? fromCurrency,
          String? toCurrency,
          double? rate,
          DateTime? effectiveAt,
          DateTime? createdAt}) =>
      ExchangeRate(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        fromCurrency: fromCurrency ?? this.fromCurrency,
        toCurrency: toCurrency ?? this.toCurrency,
        rate: rate ?? this.rate,
        effectiveAt: effectiveAt ?? this.effectiveAt,
        createdAt: createdAt ?? this.createdAt,
      );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      fromCurrency: data.fromCurrency.present
          ? data.fromCurrency.value
          : this.fromCurrency,
      toCurrency:
          data.toCurrency.present ? data.toCurrency.value : this.toCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      effectiveAt:
          data.effectiveAt.present ? data.effectiveAt.value : this.effectiveAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, fromCurrency, toCurrency, rate, effectiveAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.fromCurrency == this.fromCurrency &&
          other.toCurrency == this.toCurrency &&
          other.rate == this.rate &&
          other.effectiveAt == this.effectiveAt &&
          other.createdAt == this.createdAt);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> fromCurrency;
  final Value<String> toCurrency;
  final Value<double> rate;
  final Value<DateTime> effectiveAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.fromCurrency = const Value.absent(),
    this.toCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.effectiveAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    required String id,
    required String userId,
    required String fromCurrency,
    required String toCurrency,
    required double rate,
    required DateTime effectiveAt,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        fromCurrency = Value(fromCurrency),
        toCurrency = Value(toCurrency),
        rate = Value(rate),
        effectiveAt = Value(effectiveAt),
        createdAt = Value(createdAt);
  static Insertable<ExchangeRate> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? fromCurrency,
    Expression<String>? toCurrency,
    Expression<double>? rate,
    Expression<DateTime>? effectiveAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (fromCurrency != null) 'from_currency': fromCurrency,
      if (toCurrency != null) 'to_currency': toCurrency,
      if (rate != null) 'rate': rate,
      if (effectiveAt != null) 'effective_at': effectiveAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? fromCurrency,
      Value<String>? toCurrency,
      Value<double>? rate,
      Value<DateTime>? effectiveAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      effectiveAt: effectiveAt ?? this.effectiveAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (fromCurrency.present) {
      map['from_currency'] = Variable<String>(fromCurrency.value);
    }
    if (toCurrency.present) {
      map['to_currency'] = Variable<String>(toCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (effectiveAt.present) {
      map['effective_at'] = Variable<DateTime>(effectiveAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditProfilesTable extends CreditProfiles
    with TableInfo<$CreditProfilesTable, CreditProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _monthsActiveMeta =
      const VerificationMeta('monthsActive');
  @override
  late final GeneratedColumn<int> monthsActive = GeneratedColumn<int>(
      'months_active', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _avgMonthlyRevenueMeta =
      const VerificationMeta('avgMonthlyRevenue');
  @override
  late final GeneratedColumn<double> avgMonthlyRevenue =
      GeneratedColumn<double>('avg_monthly_revenue', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _shareTokenMeta =
      const VerificationMeta('shareToken');
  @override
  late final GeneratedColumn<String> shareToken = GeneratedColumn<String>(
      'share_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        score,
        monthsActive,
        avgMonthlyRevenue,
        shareToken,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<CreditProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('months_active')) {
      context.handle(
          _monthsActiveMeta,
          monthsActive.isAcceptableOrUnknown(
              data['months_active']!, _monthsActiveMeta));
    }
    if (data.containsKey('avg_monthly_revenue')) {
      context.handle(
          _avgMonthlyRevenueMeta,
          avgMonthlyRevenue.isAcceptableOrUnknown(
              data['avg_monthly_revenue']!, _avgMonthlyRevenueMeta));
    }
    if (data.containsKey('share_token')) {
      context.handle(
          _shareTokenMeta,
          shareToken.isAcceptableOrUnknown(
              data['share_token']!, _shareTokenMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      monthsActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}months_active'])!,
      avgMonthlyRevenue: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}avg_monthly_revenue'])!,
      shareToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}share_token']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CreditProfilesTable createAlias(String alias) {
    return $CreditProfilesTable(attachedDatabase, alias);
  }
}

class CreditProfile extends DataClass implements Insertable<CreditProfile> {
  final String id;
  final String userId;
  final int score;
  final int monthsActive;
  final double avgMonthlyRevenue;
  final String? shareToken;
  final DateTime updatedAt;
  const CreditProfile(
      {required this.id,
      required this.userId,
      required this.score,
      required this.monthsActive,
      required this.avgMonthlyRevenue,
      this.shareToken,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['score'] = Variable<int>(score);
    map['months_active'] = Variable<int>(monthsActive);
    map['avg_monthly_revenue'] = Variable<double>(avgMonthlyRevenue);
    if (!nullToAbsent || shareToken != null) {
      map['share_token'] = Variable<String>(shareToken);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CreditProfilesCompanion toCompanion(bool nullToAbsent) {
    return CreditProfilesCompanion(
      id: Value(id),
      userId: Value(userId),
      score: Value(score),
      monthsActive: Value(monthsActive),
      avgMonthlyRevenue: Value(avgMonthlyRevenue),
      shareToken: shareToken == null && nullToAbsent
          ? const Value.absent()
          : Value(shareToken),
      updatedAt: Value(updatedAt),
    );
  }

  factory CreditProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditProfile(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      score: serializer.fromJson<int>(json['score']),
      monthsActive: serializer.fromJson<int>(json['monthsActive']),
      avgMonthlyRevenue: serializer.fromJson<double>(json['avgMonthlyRevenue']),
      shareToken: serializer.fromJson<String?>(json['shareToken']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'score': serializer.toJson<int>(score),
      'monthsActive': serializer.toJson<int>(monthsActive),
      'avgMonthlyRevenue': serializer.toJson<double>(avgMonthlyRevenue),
      'shareToken': serializer.toJson<String?>(shareToken),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CreditProfile copyWith(
          {String? id,
          String? userId,
          int? score,
          int? monthsActive,
          double? avgMonthlyRevenue,
          Value<String?> shareToken = const Value.absent(),
          DateTime? updatedAt}) =>
      CreditProfile(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        score: score ?? this.score,
        monthsActive: monthsActive ?? this.monthsActive,
        avgMonthlyRevenue: avgMonthlyRevenue ?? this.avgMonthlyRevenue,
        shareToken: shareToken.present ? shareToken.value : this.shareToken,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CreditProfile copyWithCompanion(CreditProfilesCompanion data) {
    return CreditProfile(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      score: data.score.present ? data.score.value : this.score,
      monthsActive: data.monthsActive.present
          ? data.monthsActive.value
          : this.monthsActive,
      avgMonthlyRevenue: data.avgMonthlyRevenue.present
          ? data.avgMonthlyRevenue.value
          : this.avgMonthlyRevenue,
      shareToken:
          data.shareToken.present ? data.shareToken.value : this.shareToken,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditProfile(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('score: $score, ')
          ..write('monthsActive: $monthsActive, ')
          ..write('avgMonthlyRevenue: $avgMonthlyRevenue, ')
          ..write('shareToken: $shareToken, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, score, monthsActive,
      avgMonthlyRevenue, shareToken, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditProfile &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.score == this.score &&
          other.monthsActive == this.monthsActive &&
          other.avgMonthlyRevenue == this.avgMonthlyRevenue &&
          other.shareToken == this.shareToken &&
          other.updatedAt == this.updatedAt);
}

class CreditProfilesCompanion extends UpdateCompanion<CreditProfile> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> score;
  final Value<int> monthsActive;
  final Value<double> avgMonthlyRevenue;
  final Value<String?> shareToken;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CreditProfilesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.score = const Value.absent(),
    this.monthsActive = const Value.absent(),
    this.avgMonthlyRevenue = const Value.absent(),
    this.shareToken = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditProfilesCompanion.insert({
    required String id,
    required String userId,
    this.score = const Value.absent(),
    this.monthsActive = const Value.absent(),
    this.avgMonthlyRevenue = const Value.absent(),
    this.shareToken = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        updatedAt = Value(updatedAt);
  static Insertable<CreditProfile> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? score,
    Expression<int>? monthsActive,
    Expression<double>? avgMonthlyRevenue,
    Expression<String>? shareToken,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (score != null) 'score': score,
      if (monthsActive != null) 'months_active': monthsActive,
      if (avgMonthlyRevenue != null) 'avg_monthly_revenue': avgMonthlyRevenue,
      if (shareToken != null) 'share_token': shareToken,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? score,
      Value<int>? monthsActive,
      Value<double>? avgMonthlyRevenue,
      Value<String?>? shareToken,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CreditProfilesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      score: score ?? this.score,
      monthsActive: monthsActive ?? this.monthsActive,
      avgMonthlyRevenue: avgMonthlyRevenue ?? this.avgMonthlyRevenue,
      shareToken: shareToken ?? this.shareToken,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (monthsActive.present) {
      map['months_active'] = Variable<int>(monthsActive.value);
    }
    if (avgMonthlyRevenue.present) {
      map['avg_monthly_revenue'] = Variable<double>(avgMonthlyRevenue.value);
    }
    if (shareToken.present) {
      map['share_token'] = Variable<String>(shareToken.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditProfilesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('score: $score, ')
          ..write('monthsActive: $monthsActive, ')
          ..write('avgMonthlyRevenue: $avgMonthlyRevenue, ')
          ..write('shareToken: $shareToken, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncScopesTable extends SyncScopes
    with TableInfo<$SyncScopesTable, SyncScope> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncScopesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastPullCursorMeta =
      const VerificationMeta('lastPullCursor');
  @override
  late final GeneratedColumn<String> lastPullCursor = GeneratedColumn<String>(
      'last_pull_cursor', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _bootstrapStateMeta =
      const VerificationMeta('bootstrapState');
  @override
  late final GeneratedColumn<String> bootstrapState = GeneratedColumn<String>(
      'bootstrap_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('idle'));
  static const VerificationMeta _lastSuccessAtMeta =
      const VerificationMeta('lastSuccessAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessAt =
      GeneratedColumn<DateTime>('last_success_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        organizationId,
        deviceId,
        lastPullCursor,
        bootstrapState,
        lastSuccessAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_scopes';
  @override
  VerificationContext validateIntegrity(Insertable<SyncScope> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('last_pull_cursor')) {
      context.handle(
          _lastPullCursorMeta,
          lastPullCursor.isAcceptableOrUnknown(
              data['last_pull_cursor']!, _lastPullCursorMeta));
    }
    if (data.containsKey('bootstrap_state')) {
      context.handle(
          _bootstrapStateMeta,
          bootstrapState.isAcceptableOrUnknown(
              data['bootstrap_state']!, _bootstrapStateMeta));
    }
    if (data.containsKey('last_success_at')) {
      context.handle(
          _lastSuccessAtMeta,
          lastSuccessAt.isAcceptableOrUnknown(
              data['last_success_at']!, _lastSuccessAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {organizationId};
  @override
  SyncScope map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncScope(
      organizationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      lastPullCursor: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_pull_cursor'])!,
      bootstrapState: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}bootstrap_state'])!,
      lastSuccessAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_success_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncScopesTable createAlias(String alias) {
    return $SyncScopesTable(attachedDatabase, alias);
  }
}

class SyncScope extends DataClass implements Insertable<SyncScope> {
  final String organizationId;
  final String deviceId;
  final String lastPullCursor;
  final String bootstrapState;
  final DateTime? lastSuccessAt;
  final DateTime updatedAt;
  const SyncScope(
      {required this.organizationId,
      required this.deviceId,
      required this.lastPullCursor,
      required this.bootstrapState,
      this.lastSuccessAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['organization_id'] = Variable<String>(organizationId);
    map['device_id'] = Variable<String>(deviceId);
    map['last_pull_cursor'] = Variable<String>(lastPullCursor);
    map['bootstrap_state'] = Variable<String>(bootstrapState);
    if (!nullToAbsent || lastSuccessAt != null) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncScopesCompanion toCompanion(bool nullToAbsent) {
    return SyncScopesCompanion(
      organizationId: Value(organizationId),
      deviceId: Value(deviceId),
      lastPullCursor: Value(lastPullCursor),
      bootstrapState: Value(bootstrapState),
      lastSuccessAt: lastSuccessAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncScope.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncScope(
      organizationId: serializer.fromJson<String>(json['organizationId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      lastPullCursor: serializer.fromJson<String>(json['lastPullCursor']),
      bootstrapState: serializer.fromJson<String>(json['bootstrapState']),
      lastSuccessAt: serializer.fromJson<DateTime?>(json['lastSuccessAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'organizationId': serializer.toJson<String>(organizationId),
      'deviceId': serializer.toJson<String>(deviceId),
      'lastPullCursor': serializer.toJson<String>(lastPullCursor),
      'bootstrapState': serializer.toJson<String>(bootstrapState),
      'lastSuccessAt': serializer.toJson<DateTime?>(lastSuccessAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncScope copyWith(
          {String? organizationId,
          String? deviceId,
          String? lastPullCursor,
          String? bootstrapState,
          Value<DateTime?> lastSuccessAt = const Value.absent(),
          DateTime? updatedAt}) =>
      SyncScope(
        organizationId: organizationId ?? this.organizationId,
        deviceId: deviceId ?? this.deviceId,
        lastPullCursor: lastPullCursor ?? this.lastPullCursor,
        bootstrapState: bootstrapState ?? this.bootstrapState,
        lastSuccessAt:
            lastSuccessAt.present ? lastSuccessAt.value : this.lastSuccessAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncScope copyWithCompanion(SyncScopesCompanion data) {
    return SyncScope(
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      lastPullCursor: data.lastPullCursor.present
          ? data.lastPullCursor.value
          : this.lastPullCursor,
      bootstrapState: data.bootstrapState.present
          ? data.bootstrapState.value
          : this.bootstrapState,
      lastSuccessAt: data.lastSuccessAt.present
          ? data.lastSuccessAt.value
          : this.lastSuccessAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncScope(')
          ..write('organizationId: $organizationId, ')
          ..write('deviceId: $deviceId, ')
          ..write('lastPullCursor: $lastPullCursor, ')
          ..write('bootstrapState: $bootstrapState, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(organizationId, deviceId, lastPullCursor,
      bootstrapState, lastSuccessAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncScope &&
          other.organizationId == this.organizationId &&
          other.deviceId == this.deviceId &&
          other.lastPullCursor == this.lastPullCursor &&
          other.bootstrapState == this.bootstrapState &&
          other.lastSuccessAt == this.lastSuccessAt &&
          other.updatedAt == this.updatedAt);
}

class SyncScopesCompanion extends UpdateCompanion<SyncScope> {
  final Value<String> organizationId;
  final Value<String> deviceId;
  final Value<String> lastPullCursor;
  final Value<String> bootstrapState;
  final Value<DateTime?> lastSuccessAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncScopesCompanion({
    this.organizationId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.lastPullCursor = const Value.absent(),
    this.bootstrapState = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncScopesCompanion.insert({
    required String organizationId,
    required String deviceId,
    this.lastPullCursor = const Value.absent(),
    this.bootstrapState = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : organizationId = Value(organizationId),
        deviceId = Value(deviceId),
        updatedAt = Value(updatedAt);
  static Insertable<SyncScope> custom({
    Expression<String>? organizationId,
    Expression<String>? deviceId,
    Expression<String>? lastPullCursor,
    Expression<String>? bootstrapState,
    Expression<DateTime>? lastSuccessAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (organizationId != null) 'organization_id': organizationId,
      if (deviceId != null) 'device_id': deviceId,
      if (lastPullCursor != null) 'last_pull_cursor': lastPullCursor,
      if (bootstrapState != null) 'bootstrap_state': bootstrapState,
      if (lastSuccessAt != null) 'last_success_at': lastSuccessAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncScopesCompanion copyWith(
      {Value<String>? organizationId,
      Value<String>? deviceId,
      Value<String>? lastPullCursor,
      Value<String>? bootstrapState,
      Value<DateTime?>? lastSuccessAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncScopesCompanion(
      organizationId: organizationId ?? this.organizationId,
      deviceId: deviceId ?? this.deviceId,
      lastPullCursor: lastPullCursor ?? this.lastPullCursor,
      bootstrapState: bootstrapState ?? this.bootstrapState,
      lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (lastPullCursor.present) {
      map['last_pull_cursor'] = Variable<String>(lastPullCursor.value);
    }
    if (bootstrapState.present) {
      map['bootstrap_state'] = Variable<String>(bootstrapState.value);
    }
    if (lastSuccessAt.present) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncScopesCompanion(')
          ..write('organizationId: $organizationId, ')
          ..write('deviceId: $deviceId, ')
          ..write('lastPullCursor: $lastPullCursor, ')
          ..write('bootstrapState: $bootstrapState, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mutationIdMeta =
      const VerificationMeta('mutationId');
  @override
  late final GeneratedColumn<String> mutationId = GeneratedColumn<String>(
      'mutation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _attemptCountMeta =
      const VerificationMeta('attemptCount');
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
      'attempt_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextAttemptAtMeta =
      const VerificationMeta('nextAttemptAt');
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>('next_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        mutationId,
        organizationId,
        entityType,
        operation,
        entityId,
        payloadJson,
        status,
        attemptCount,
        nextAttemptAt,
        lastError,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(Insertable<SyncOutboxData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mutation_id')) {
      context.handle(
          _mutationIdMeta,
          mutationId.isAcceptableOrUnknown(
              data['mutation_id']!, _mutationIdMeta));
    } else if (isInserting) {
      context.missing(_mutationIdMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
          _attemptCountMeta,
          attemptCount.isAcceptableOrUnknown(
              data['attempt_count']!, _attemptCountMeta));
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
          _nextAttemptAtMeta,
          nextAttemptAt.isAcceptableOrUnknown(
              data['next_attempt_at']!, _nextAttemptAtMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mutationId};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      mutationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mutation_id'])!,
      organizationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      attemptCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempt_count'])!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_attempt_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String mutationId;
  final String organizationId;
  final String entityType;
  final String operation;
  final String entityId;
  final String payloadJson;
  final String status;
  final int attemptCount;
  final DateTime? nextAttemptAt;
  final String? lastError;
  final DateTime createdAt;
  const SyncOutboxData(
      {required this.mutationId,
      required this.organizationId,
      required this.entityType,
      required this.operation,
      required this.entityId,
      required this.payloadJson,
      required this.status,
      required this.attemptCount,
      this.nextAttemptAt,
      this.lastError,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mutation_id'] = Variable<String>(mutationId);
    map['organization_id'] = Variable<String>(organizationId);
    map['entity_type'] = Variable<String>(entityType);
    map['operation'] = Variable<String>(operation);
    map['entity_id'] = Variable<String>(entityId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      mutationId: Value(mutationId),
      organizationId: Value(organizationId),
      entityType: Value(entityType),
      operation: Value(operation),
      entityId: Value(entityId),
      payloadJson: Value(payloadJson),
      status: Value(status),
      attemptCount: Value(attemptCount),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOutboxData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      mutationId: serializer.fromJson<String>(json['mutationId']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      operation: serializer.fromJson<String>(json['operation']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mutationId': serializer.toJson<String>(mutationId),
      'organizationId': serializer.toJson<String>(organizationId),
      'entityType': serializer.toJson<String>(entityType),
      'operation': serializer.toJson<String>(operation),
      'entityId': serializer.toJson<String>(entityId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOutboxData copyWith(
          {String? mutationId,
          String? organizationId,
          String? entityType,
          String? operation,
          String? entityId,
          String? payloadJson,
          String? status,
          int? attemptCount,
          Value<DateTime?> nextAttemptAt = const Value.absent(),
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt}) =>
      SyncOutboxData(
        mutationId: mutationId ?? this.mutationId,
        organizationId: organizationId ?? this.organizationId,
        entityType: entityType ?? this.entityType,
        operation: operation ?? this.operation,
        entityId: entityId ?? this.entityId,
        payloadJson: payloadJson ?? this.payloadJson,
        status: status ?? this.status,
        attemptCount: attemptCount ?? this.attemptCount,
        nextAttemptAt:
            nextAttemptAt.present ? nextAttemptAt.value : this.nextAttemptAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      mutationId:
          data.mutationId.present ? data.mutationId.value : this.mutationId,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      operation: data.operation.present ? data.operation.value : this.operation,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('mutationId: $mutationId, ')
          ..write('organizationId: $organizationId, ')
          ..write('entityType: $entityType, ')
          ..write('operation: $operation, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      mutationId,
      organizationId,
      entityType,
      operation,
      entityId,
      payloadJson,
      status,
      attemptCount,
      nextAttemptAt,
      lastError,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.mutationId == this.mutationId &&
          other.organizationId == this.organizationId &&
          other.entityType == this.entityType &&
          other.operation == this.operation &&
          other.entityId == this.entityId &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> mutationId;
  final Value<String> organizationId;
  final Value<String> entityType;
  final Value<String> operation;
  final Value<String> entityId;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> attemptCount;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.mutationId = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.operation = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String mutationId,
    required String organizationId,
    required String entityType,
    required String operation,
    required String entityId,
    required String payloadJson,
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : mutationId = Value(mutationId),
        organizationId = Value(organizationId),
        entityType = Value(entityType),
        operation = Value(operation),
        entityId = Value(entityId),
        payloadJson = Value(payloadJson),
        createdAt = Value(createdAt);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? mutationId,
    Expression<String>? organizationId,
    Expression<String>? entityType,
    Expression<String>? operation,
    Expression<String>? entityId,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mutationId != null) 'mutation_id': mutationId,
      if (organizationId != null) 'organization_id': organizationId,
      if (entityType != null) 'entity_type': entityType,
      if (operation != null) 'operation': operation,
      if (entityId != null) 'entity_id': entityId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith(
      {Value<String>? mutationId,
      Value<String>? organizationId,
      Value<String>? entityType,
      Value<String>? operation,
      Value<String>? entityId,
      Value<String>? payloadJson,
      Value<String>? status,
      Value<int>? attemptCount,
      Value<DateTime?>? nextAttemptAt,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SyncOutboxCompanion(
      mutationId: mutationId ?? this.mutationId,
      organizationId: organizationId ?? this.organizationId,
      entityType: entityType ?? this.entityType,
      operation: operation ?? this.operation,
      entityId: entityId ?? this.entityId,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mutationId.present) {
      map['mutation_id'] = Variable<String>(mutationId.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('mutationId: $mutationId, ')
          ..write('organizationId: $organizationId, ')
          ..write('entityType: $entityType, ')
          ..write('operation: $operation, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflict> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mutationIdMeta =
      const VerificationMeta('mutationId');
  @override
  late final GeneratedColumn<String> mutationId = GeneratedColumn<String>(
      'mutation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPayloadJsonMeta =
      const VerificationMeta('localPayloadJson');
  @override
  late final GeneratedColumn<String> localPayloadJson = GeneratedColumn<String>(
      'local_payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverPayloadJsonMeta =
      const VerificationMeta('serverPayloadJson');
  @override
  late final GeneratedColumn<String> serverPayloadJson =
      GeneratedColumn<String>('server_payload_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        mutationId,
        entityId,
        localPayloadJson,
        serverPayloadJson,
        reason,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(Insertable<SyncConflict> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mutation_id')) {
      context.handle(
          _mutationIdMeta,
          mutationId.isAcceptableOrUnknown(
              data['mutation_id']!, _mutationIdMeta));
    } else if (isInserting) {
      context.missing(_mutationIdMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('local_payload_json')) {
      context.handle(
          _localPayloadJsonMeta,
          localPayloadJson.isAcceptableOrUnknown(
              data['local_payload_json']!, _localPayloadJsonMeta));
    } else if (isInserting) {
      context.missing(_localPayloadJsonMeta);
    }
    if (data.containsKey('server_payload_json')) {
      context.handle(
          _serverPayloadJsonMeta,
          serverPayloadJson.isAcceptableOrUnknown(
              data['server_payload_json']!, _serverPayloadJsonMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mutationId};
  @override
  SyncConflict map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflict(
      mutationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mutation_id'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      localPayloadJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_payload_json'])!,
      serverPayloadJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}server_payload_json']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflict extends DataClass implements Insertable<SyncConflict> {
  final String mutationId;
  final String entityId;
  final String localPayloadJson;
  final String? serverPayloadJson;
  final String reason;
  final String status;
  final DateTime createdAt;
  const SyncConflict(
      {required this.mutationId,
      required this.entityId,
      required this.localPayloadJson,
      this.serverPayloadJson,
      required this.reason,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mutation_id'] = Variable<String>(mutationId);
    map['entity_id'] = Variable<String>(entityId);
    map['local_payload_json'] = Variable<String>(localPayloadJson);
    if (!nullToAbsent || serverPayloadJson != null) {
      map['server_payload_json'] = Variable<String>(serverPayloadJson);
    }
    map['reason'] = Variable<String>(reason);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      mutationId: Value(mutationId),
      entityId: Value(entityId),
      localPayloadJson: Value(localPayloadJson),
      serverPayloadJson: serverPayloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(serverPayloadJson),
      reason: Value(reason),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory SyncConflict.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflict(
      mutationId: serializer.fromJson<String>(json['mutationId']),
      entityId: serializer.fromJson<String>(json['entityId']),
      localPayloadJson: serializer.fromJson<String>(json['localPayloadJson']),
      serverPayloadJson:
          serializer.fromJson<String?>(json['serverPayloadJson']),
      reason: serializer.fromJson<String>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mutationId': serializer.toJson<String>(mutationId),
      'entityId': serializer.toJson<String>(entityId),
      'localPayloadJson': serializer.toJson<String>(localPayloadJson),
      'serverPayloadJson': serializer.toJson<String?>(serverPayloadJson),
      'reason': serializer.toJson<String>(reason),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncConflict copyWith(
          {String? mutationId,
          String? entityId,
          String? localPayloadJson,
          Value<String?> serverPayloadJson = const Value.absent(),
          String? reason,
          String? status,
          DateTime? createdAt}) =>
      SyncConflict(
        mutationId: mutationId ?? this.mutationId,
        entityId: entityId ?? this.entityId,
        localPayloadJson: localPayloadJson ?? this.localPayloadJson,
        serverPayloadJson: serverPayloadJson.present
            ? serverPayloadJson.value
            : this.serverPayloadJson,
        reason: reason ?? this.reason,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncConflict copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflict(
      mutationId:
          data.mutationId.present ? data.mutationId.value : this.mutationId,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      localPayloadJson: data.localPayloadJson.present
          ? data.localPayloadJson.value
          : this.localPayloadJson,
      serverPayloadJson: data.serverPayloadJson.present
          ? data.serverPayloadJson.value
          : this.serverPayloadJson,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflict(')
          ..write('mutationId: $mutationId, ')
          ..write('entityId: $entityId, ')
          ..write('localPayloadJson: $localPayloadJson, ')
          ..write('serverPayloadJson: $serverPayloadJson, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mutationId, entityId, localPayloadJson,
      serverPayloadJson, reason, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflict &&
          other.mutationId == this.mutationId &&
          other.entityId == this.entityId &&
          other.localPayloadJson == this.localPayloadJson &&
          other.serverPayloadJson == this.serverPayloadJson &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflict> {
  final Value<String> mutationId;
  final Value<String> entityId;
  final Value<String> localPayloadJson;
  final Value<String?> serverPayloadJson;
  final Value<String> reason;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncConflictsCompanion({
    this.mutationId = const Value.absent(),
    this.entityId = const Value.absent(),
    this.localPayloadJson = const Value.absent(),
    this.serverPayloadJson = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    required String mutationId,
    required String entityId,
    required String localPayloadJson,
    this.serverPayloadJson = const Value.absent(),
    required String reason,
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : mutationId = Value(mutationId),
        entityId = Value(entityId),
        localPayloadJson = Value(localPayloadJson),
        reason = Value(reason),
        createdAt = Value(createdAt);
  static Insertable<SyncConflict> custom({
    Expression<String>? mutationId,
    Expression<String>? entityId,
    Expression<String>? localPayloadJson,
    Expression<String>? serverPayloadJson,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mutationId != null) 'mutation_id': mutationId,
      if (entityId != null) 'entity_id': entityId,
      if (localPayloadJson != null) 'local_payload_json': localPayloadJson,
      if (serverPayloadJson != null) 'server_payload_json': serverPayloadJson,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncConflictsCompanion copyWith(
      {Value<String>? mutationId,
      Value<String>? entityId,
      Value<String>? localPayloadJson,
      Value<String?>? serverPayloadJson,
      Value<String>? reason,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SyncConflictsCompanion(
      mutationId: mutationId ?? this.mutationId,
      entityId: entityId ?? this.entityId,
      localPayloadJson: localPayloadJson ?? this.localPayloadJson,
      serverPayloadJson: serverPayloadJson ?? this.serverPayloadJson,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mutationId.present) {
      map['mutation_id'] = Variable<String>(mutationId.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (localPayloadJson.present) {
      map['local_payload_json'] = Variable<String>(localPayloadJson.value);
    }
    if (serverPayloadJson.present) {
      map['server_payload_json'] = Variable<String>(serverPayloadJson.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('mutationId: $mutationId, ')
          ..write('entityId: $entityId, ')
          ..write('localPayloadJson: $localPayloadJson, ')
          ..write('serverPayloadJson: $serverPayloadJson, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final $CreditProfilesTable creditProfiles = $CreditProfilesTable(this);
  late final $SyncScopesTable syncScopes = $SyncScopesTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        products,
        customers,
        transactions,
        exchangeRates,
        creditProfiles,
        syncScopes,
        syncOutbox,
        syncConflicts
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String phone,
  required String businessName,
  required String businessType,
  required String city,
  Value<String> plan,
  Value<String> baseCurrencyCode,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> phone,
  Value<String> businessName,
  Value<String> businessType,
  Value<String> city,
  Value<String> plan,
  Value<String> baseCurrencyCode,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessType => $composableBuilder(
      column: $table.businessType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plan => $composableBuilder(
      column: $table.plan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseCurrencyCode => $composableBuilder(
      column: $table.baseCurrencyCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessName => $composableBuilder(
      column: $table.businessName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessType => $composableBuilder(
      column: $table.businessType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plan => $composableBuilder(
      column: $table.plan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseCurrencyCode => $composableBuilder(
      column: $table.baseCurrencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => column);

  GeneratedColumn<String> get businessType => $composableBuilder(
      column: $table.businessType, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<String> get baseCurrencyCode => $composableBuilder(
      column: $table.baseCurrencyCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String> businessType = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<String> plan = const Value.absent(),
            Value<String> baseCurrencyCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            phone: phone,
            businessName: businessName,
            businessType: businessType,
            city: city,
            plan: plan,
            baseCurrencyCode: baseCurrencyCode,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String phone,
            required String businessName,
            required String businessType,
            required String city,
            Value<String> plan = const Value.absent(),
            Value<String> baseCurrencyCode = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            phone: phone,
            businessName: businessName,
            businessType: businessType,
            city: city,
            plan: plan,
            baseCurrencyCode: baseCurrencyCode,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  required String id,
  required String userId,
  required String name,
  Value<String?> barcode,
  required double buyPrice,
  required double sellPrice,
  Value<int> stockQty,
  Value<int> minStock,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> name,
  Value<String?> barcode,
  Value<double> buyPrice,
  Value<double> sellPrice,
  Value<int> stockQty,
  Value<int> minStock,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get buyPrice => $composableBuilder(
      column: $table.buyPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellPrice => $composableBuilder(
      column: $table.sellPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockQty => $composableBuilder(
      column: $table.stockQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minStock => $composableBuilder(
      column: $table.minStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get buyPrice => $composableBuilder(
      column: $table.buyPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellPrice => $composableBuilder(
      column: $table.sellPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockQty => $composableBuilder(
      column: $table.stockQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minStock => $composableBuilder(
      column: $table.minStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get buyPrice =>
      $composableBuilder(column: $table.buyPrice, builder: (column) => column);

  GeneratedColumn<double> get sellPrice =>
      $composableBuilder(column: $table.sellPrice, builder: (column) => column);

  GeneratedColumn<int> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<int> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
    Product,
    PrefetchHooks Function()> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double> buyPrice = const Value.absent(),
            Value<double> sellPrice = const Value.absent(),
            Value<int> stockQty = const Value.absent(),
            Value<int> minStock = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            userId: userId,
            name: name,
            barcode: barcode,
            buyPrice: buyPrice,
            sellPrice: sellPrice,
            stockQty: stockQty,
            minStock: minStock,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String name,
            Value<String?> barcode = const Value.absent(),
            required double buyPrice,
            required double sellPrice,
            Value<int> stockQty = const Value.absent(),
            Value<int> minStock = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            barcode: barcode,
            buyPrice: buyPrice,
            sellPrice: sellPrice,
            stockQty: stockQty,
            minStock: minStock,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
    Product,
    PrefetchHooks Function()>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  required String id,
  required String userId,
  required String name,
  Value<String?> phone,
  Value<double> totalDebt,
  Value<DateTime?> lastPaymentDate,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> name,
  Value<String?> phone,
  Value<double> totalDebt,
  Value<DateTime?> lastPaymentDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalDebt => $composableBuilder(
      column: $table.totalDebt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPaymentDate => $composableBuilder(
      column: $table.lastPaymentDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalDebt => $composableBuilder(
      column: $table.totalDebt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPaymentDate => $composableBuilder(
      column: $table.lastPaymentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get totalDebt =>
      $composableBuilder(column: $table.totalDebt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPaymentDate => $composableBuilder(
      column: $table.lastPaymentDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double> totalDebt = const Value.absent(),
            Value<DateTime?> lastPaymentDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            userId: userId,
            name: name,
            phone: phone,
            totalDebt: totalDebt,
            lastPaymentDate: lastPaymentDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<double> totalDebt = const Value.absent(),
            Value<DateTime?> lastPaymentDate = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            phone: phone,
            totalDebt: totalDebt,
            lastPaymentDate: lastPaymentDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required String userId,
  Value<String?> customerId,
  Value<String?> productId,
  required String type,
  required String payment,
  required double amount,
  Value<String> currencyCode,
  Value<double> exchangeRate,
  Value<double?> baseAmount,
  Value<int> quantity,
  Value<String?> notes,
  required DateTime createdAt,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String?> customerId,
  Value<String?> productId,
  Value<String> type,
  Value<String> payment,
  Value<double> amount,
  Value<String> currencyCode,
  Value<double> exchangeRate,
  Value<double?> baseAmount,
  Value<int> quantity,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<bool> synced,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payment => $composableBuilder(
      column: $table.payment, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseAmount => $composableBuilder(
      column: $table.baseAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payment => $composableBuilder(
      column: $table.payment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseAmount => $composableBuilder(
      column: $table.baseAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payment =>
      $composableBuilder(column: $table.payment, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => column);

  GeneratedColumn<double> get baseAmount => $composableBuilder(
      column: $table.baseAmount, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> payment = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<double> exchangeRate = const Value.absent(),
            Value<double?> baseAmount = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            userId: userId,
            customerId: customerId,
            productId: productId,
            type: type,
            payment: payment,
            amount: amount,
            currencyCode: currencyCode,
            exchangeRate: exchangeRate,
            baseAmount: baseAmount,
            quantity: quantity,
            notes: notes,
            createdAt: createdAt,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<String?> customerId = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            required String type,
            required String payment,
            required double amount,
            Value<String> currencyCode = const Value.absent(),
            Value<double> exchangeRate = const Value.absent(),
            Value<double?> baseAmount = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            userId: userId,
            customerId: customerId,
            productId: productId,
            type: type,
            payment: payment,
            amount: amount,
            currencyCode: currencyCode,
            exchangeRate: exchangeRate,
            baseAmount: baseAmount,
            quantity: quantity,
            notes: notes,
            createdAt: createdAt,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;
typedef $$ExchangeRatesTableCreateCompanionBuilder = ExchangeRatesCompanion
    Function({
  required String id,
  required String userId,
  required String fromCurrency,
  required String toCurrency,
  required double rate,
  required DateTime effectiveAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ExchangeRatesTableUpdateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> fromCurrency,
  Value<String> toCurrency,
  Value<double> rate,
  Value<DateTime> effectiveAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromCurrency => $composableBuilder(
      column: $table.fromCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toCurrency => $composableBuilder(
      column: $table.toCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get effectiveAt => $composableBuilder(
      column: $table.effectiveAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromCurrency => $composableBuilder(
      column: $table.fromCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toCurrency => $composableBuilder(
      column: $table.toCurrency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get effectiveAt => $composableBuilder(
      column: $table.effectiveAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get fromCurrency => $composableBuilder(
      column: $table.fromCurrency, builder: (column) => column);

  GeneratedColumn<String> get toCurrency => $composableBuilder(
      column: $table.toCurrency, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveAt => $composableBuilder(
      column: $table.effectiveAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRate,
      BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>
    ),
    ExchangeRate,
    PrefetchHooks Function()> {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> fromCurrency = const Value.absent(),
            Value<String> toCurrency = const Value.absent(),
            Value<double> rate = const Value.absent(),
            Value<DateTime> effectiveAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion(
            id: id,
            userId: userId,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            rate: rate,
            effectiveAt: effectiveAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String fromCurrency,
            required String toCurrency,
            required double rate,
            required DateTime effectiveAt,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion.insert(
            id: id,
            userId: userId,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            rate: rate,
            effectiveAt: effectiveAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExchangeRatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRate,
      BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>
    ),
    ExchangeRate,
    PrefetchHooks Function()>;
typedef $$CreditProfilesTableCreateCompanionBuilder = CreditProfilesCompanion
    Function({
  required String id,
  required String userId,
  Value<int> score,
  Value<int> monthsActive,
  Value<double> avgMonthlyRevenue,
  Value<String?> shareToken,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CreditProfilesTableUpdateCompanionBuilder = CreditProfilesCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<int> score,
  Value<int> monthsActive,
  Value<double> avgMonthlyRevenue,
  Value<String?> shareToken,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CreditProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CreditProfilesTable> {
  $$CreditProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthsActive => $composableBuilder(
      column: $table.monthsActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgMonthlyRevenue => $composableBuilder(
      column: $table.avgMonthlyRevenue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shareToken => $composableBuilder(
      column: $table.shareToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CreditProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditProfilesTable> {
  $$CreditProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthsActive => $composableBuilder(
      column: $table.monthsActive,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgMonthlyRevenue => $composableBuilder(
      column: $table.avgMonthlyRevenue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shareToken => $composableBuilder(
      column: $table.shareToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CreditProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditProfilesTable> {
  $$CreditProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get monthsActive => $composableBuilder(
      column: $table.monthsActive, builder: (column) => column);

  GeneratedColumn<double> get avgMonthlyRevenue => $composableBuilder(
      column: $table.avgMonthlyRevenue, builder: (column) => column);

  GeneratedColumn<String> get shareToken => $composableBuilder(
      column: $table.shareToken, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CreditProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditProfilesTable,
    CreditProfile,
    $$CreditProfilesTableFilterComposer,
    $$CreditProfilesTableOrderingComposer,
    $$CreditProfilesTableAnnotationComposer,
    $$CreditProfilesTableCreateCompanionBuilder,
    $$CreditProfilesTableUpdateCompanionBuilder,
    (
      CreditProfile,
      BaseReferences<_$AppDatabase, $CreditProfilesTable, CreditProfile>
    ),
    CreditProfile,
    PrefetchHooks Function()> {
  $$CreditProfilesTableTableManager(
      _$AppDatabase db, $CreditProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<int> monthsActive = const Value.absent(),
            Value<double> avgMonthlyRevenue = const Value.absent(),
            Value<String?> shareToken = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditProfilesCompanion(
            id: id,
            userId: userId,
            score: score,
            monthsActive: monthsActive,
            avgMonthlyRevenue: avgMonthlyRevenue,
            shareToken: shareToken,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<int> score = const Value.absent(),
            Value<int> monthsActive = const Value.absent(),
            Value<double> avgMonthlyRevenue = const Value.absent(),
            Value<String?> shareToken = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditProfilesCompanion.insert(
            id: id,
            userId: userId,
            score: score,
            monthsActive: monthsActive,
            avgMonthlyRevenue: avgMonthlyRevenue,
            shareToken: shareToken,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CreditProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CreditProfilesTable,
    CreditProfile,
    $$CreditProfilesTableFilterComposer,
    $$CreditProfilesTableOrderingComposer,
    $$CreditProfilesTableAnnotationComposer,
    $$CreditProfilesTableCreateCompanionBuilder,
    $$CreditProfilesTableUpdateCompanionBuilder,
    (
      CreditProfile,
      BaseReferences<_$AppDatabase, $CreditProfilesTable, CreditProfile>
    ),
    CreditProfile,
    PrefetchHooks Function()>;
typedef $$SyncScopesTableCreateCompanionBuilder = SyncScopesCompanion Function({
  required String organizationId,
  required String deviceId,
  Value<String> lastPullCursor,
  Value<String> bootstrapState,
  Value<DateTime?> lastSuccessAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SyncScopesTableUpdateCompanionBuilder = SyncScopesCompanion Function({
  Value<String> organizationId,
  Value<String> deviceId,
  Value<String> lastPullCursor,
  Value<String> bootstrapState,
  Value<DateTime?> lastSuccessAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncScopesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncScopesTable> {
  $$SyncScopesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastPullCursor => $composableBuilder(
      column: $table.lastPullCursor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bootstrapState => $composableBuilder(
      column: $table.bootstrapState,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSuccessAt => $composableBuilder(
      column: $table.lastSuccessAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncScopesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncScopesTable> {
  $$SyncScopesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastPullCursor => $composableBuilder(
      column: $table.lastPullCursor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bootstrapState => $composableBuilder(
      column: $table.bootstrapState,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSuccessAt => $composableBuilder(
      column: $table.lastSuccessAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncScopesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncScopesTable> {
  $$SyncScopesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get lastPullCursor => $composableBuilder(
      column: $table.lastPullCursor, builder: (column) => column);

  GeneratedColumn<String> get bootstrapState => $composableBuilder(
      column: $table.bootstrapState, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessAt => $composableBuilder(
      column: $table.lastSuccessAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncScopesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncScopesTable,
    SyncScope,
    $$SyncScopesTableFilterComposer,
    $$SyncScopesTableOrderingComposer,
    $$SyncScopesTableAnnotationComposer,
    $$SyncScopesTableCreateCompanionBuilder,
    $$SyncScopesTableUpdateCompanionBuilder,
    (SyncScope, BaseReferences<_$AppDatabase, $SyncScopesTable, SyncScope>),
    SyncScope,
    PrefetchHooks Function()> {
  $$SyncScopesTableTableManager(_$AppDatabase db, $SyncScopesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncScopesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncScopesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncScopesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> organizationId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> lastPullCursor = const Value.absent(),
            Value<String> bootstrapState = const Value.absent(),
            Value<DateTime?> lastSuccessAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncScopesCompanion(
            organizationId: organizationId,
            deviceId: deviceId,
            lastPullCursor: lastPullCursor,
            bootstrapState: bootstrapState,
            lastSuccessAt: lastSuccessAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String organizationId,
            required String deviceId,
            Value<String> lastPullCursor = const Value.absent(),
            Value<String> bootstrapState = const Value.absent(),
            Value<DateTime?> lastSuccessAt = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncScopesCompanion.insert(
            organizationId: organizationId,
            deviceId: deviceId,
            lastPullCursor: lastPullCursor,
            bootstrapState: bootstrapState,
            lastSuccessAt: lastSuccessAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncScopesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncScopesTable,
    SyncScope,
    $$SyncScopesTableFilterComposer,
    $$SyncScopesTableOrderingComposer,
    $$SyncScopesTableAnnotationComposer,
    $$SyncScopesTableCreateCompanionBuilder,
    $$SyncScopesTableUpdateCompanionBuilder,
    (SyncScope, BaseReferences<_$AppDatabase, $SyncScopesTable, SyncScope>),
    SyncScope,
    PrefetchHooks Function()>;
typedef $$SyncOutboxTableCreateCompanionBuilder = SyncOutboxCompanion Function({
  required String mutationId,
  required String organizationId,
  required String entityType,
  required String operation,
  required String entityId,
  required String payloadJson,
  Value<String> status,
  Value<int> attemptCount,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SyncOutboxTableUpdateCompanionBuilder = SyncOutboxCompanion Function({
  Value<String> mutationId,
  Value<String> organizationId,
  Value<String> entityType,
  Value<String> operation,
  Value<String> entityId,
  Value<String> payloadJson,
  Value<String> status,
  Value<int> attemptCount,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mutationId => $composableBuilder(
      column: $table.mutationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mutationId => $composableBuilder(
      column: $table.mutationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mutationId => $composableBuilder(
      column: $table.mutationId, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOutboxTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncOutboxTable,
    SyncOutboxData,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxData,
      BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>
    ),
    SyncOutboxData,
    PrefetchHooks Function()> {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> mutationId = const Value.absent(),
            Value<String> organizationId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> attemptCount = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxCompanion(
            mutationId: mutationId,
            organizationId: organizationId,
            entityType: entityType,
            operation: operation,
            entityId: entityId,
            payloadJson: payloadJson,
            status: status,
            attemptCount: attemptCount,
            nextAttemptAt: nextAttemptAt,
            lastError: lastError,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String mutationId,
            required String organizationId,
            required String entityType,
            required String operation,
            required String entityId,
            required String payloadJson,
            Value<String> status = const Value.absent(),
            Value<int> attemptCount = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxCompanion.insert(
            mutationId: mutationId,
            organizationId: organizationId,
            entityType: entityType,
            operation: operation,
            entityId: entityId,
            payloadJson: payloadJson,
            status: status,
            attemptCount: attemptCount,
            nextAttemptAt: nextAttemptAt,
            lastError: lastError,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncOutboxTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncOutboxTable,
    SyncOutboxData,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxData,
      BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>
    ),
    SyncOutboxData,
    PrefetchHooks Function()>;
typedef $$SyncConflictsTableCreateCompanionBuilder = SyncConflictsCompanion
    Function({
  required String mutationId,
  required String entityId,
  required String localPayloadJson,
  Value<String?> serverPayloadJson,
  required String reason,
  Value<String> status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SyncConflictsTableUpdateCompanionBuilder = SyncConflictsCompanion
    Function({
  Value<String> mutationId,
  Value<String> entityId,
  Value<String> localPayloadJson,
  Value<String?> serverPayloadJson,
  Value<String> reason,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SyncConflictsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mutationId => $composableBuilder(
      column: $table.mutationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPayloadJson => $composableBuilder(
      column: $table.localPayloadJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverPayloadJson => $composableBuilder(
      column: $table.serverPayloadJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mutationId => $composableBuilder(
      column: $table.mutationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPayloadJson => $composableBuilder(
      column: $table.localPayloadJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverPayloadJson => $composableBuilder(
      column: $table.serverPayloadJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mutationId => $composableBuilder(
      column: $table.mutationId, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get localPayloadJson => $composableBuilder(
      column: $table.localPayloadJson, builder: (column) => column);

  GeneratedColumn<String> get serverPayloadJson => $composableBuilder(
      column: $table.serverPayloadJson, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncConflictsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncConflictsTable,
    SyncConflict,
    $$SyncConflictsTableFilterComposer,
    $$SyncConflictsTableOrderingComposer,
    $$SyncConflictsTableAnnotationComposer,
    $$SyncConflictsTableCreateCompanionBuilder,
    $$SyncConflictsTableUpdateCompanionBuilder,
    (
      SyncConflict,
      BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflict>
    ),
    SyncConflict,
    PrefetchHooks Function()> {
  $$SyncConflictsTableTableManager(_$AppDatabase db, $SyncConflictsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> mutationId = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> localPayloadJson = const Value.absent(),
            Value<String?> serverPayloadJson = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncConflictsCompanion(
            mutationId: mutationId,
            entityId: entityId,
            localPayloadJson: localPayloadJson,
            serverPayloadJson: serverPayloadJson,
            reason: reason,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String mutationId,
            required String entityId,
            required String localPayloadJson,
            Value<String?> serverPayloadJson = const Value.absent(),
            required String reason,
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncConflictsCompanion.insert(
            mutationId: mutationId,
            entityId: entityId,
            localPayloadJson: localPayloadJson,
            serverPayloadJson: serverPayloadJson,
            reason: reason,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncConflictsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncConflictsTable,
    SyncConflict,
    $$SyncConflictsTableFilterComposer,
    $$SyncConflictsTableOrderingComposer,
    $$SyncConflictsTableAnnotationComposer,
    $$SyncConflictsTableCreateCompanionBuilder,
    $$SyncConflictsTableUpdateCompanionBuilder,
    (
      SyncConflict,
      BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflict>
    ),
    SyncConflict,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
  $$CreditProfilesTableTableManager get creditProfiles =>
      $$CreditProfilesTableTableManager(_db, _db.creditProfiles);
  $$SyncScopesTableTableManager get syncScopes =>
      $$SyncScopesTableTableManager(_db, _db.syncScopes);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
}
