// dart format width=80
// GENERATED CODE, DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
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
      $customConstraints: 'UNIQUE');
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
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, phone, businessName, businessType, city, plan, createdAt];
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
      context.handle(_cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('plan')) {
      context.handle(_planMeta, plan.isAcceptableOrUnknown(data['plan']!, _planMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _createdAtMeta,
          createdAt.isAcceptableOrUnknown(
              data['created_at']!, _createdAtMeta));
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
      businessName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}business_name'])!,
      businessType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}business_type'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      plan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan'])!,
      createdAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
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
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.phone,
      required this.businessName,
      required this.businessType,
      required this.city,
      required this.plan,
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
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        businessName: businessName ?? this.businessName,
        businessType: businessType ?? this.businessType,
        city: city ?? this.city,
        plan: plan ?? this.plan,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('businessName: $businessName, ')
          ..write('businessType: $businessType, ')
          ..write('city: $city, ')
          ..write('plan: $plan, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, phone, businessName, businessType, city, plan, createdAt);
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
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> phone;
  final Value<String> businessName;
  final Value<String> businessType;
  final Value<String> city;
  final Value<String> plan;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.businessName = const Value.absent(),
    this.businessType = const Value.absent(),
    this.city = const Value.absent(),
    this.plan = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String phone,
    required String businessName,
    required String businessType,
    required String city,
    this.plan = const Value.absent(),
    required DateTime createdAt,
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
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (businessName != null) 'business_name': businessName,
      if (businessType != null) 'business_type': businessType,
      if (city != null) 'city': city,
      if (plan != null) 'plan': plan,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? phone,
      Value<String>? businessName,
      Value<String>? businessType,
      Value<String>? city,
      Value<String>? plan,
      Value<DateTime>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      city: city ?? this.city,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (phone.present) map['phone'] = Variable<String>(phone.value);
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (businessType.present) {
      map['business_type'] = Variable<String>(businessType.value);
    }
    if (city.present) map['city'] = Variable<String>(city.value);
    if (plan.present) map['plan'] = Variable<String>(plan.value);
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
          ..write('createdAt: $createdAt')
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
  static const VerificationMeta _userIdMeta =
      const VerificationMeta('userId');
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
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
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
      context.handle(
          _sellPriceMeta,
          sellPrice.isAcceptableOrUnknown(
              data['sell_price']!, _sellPriceMeta));
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
      context.handle(
          _createdAtMeta,
          createdAt.isAcceptableOrUnknown(
              data['created_at']!, _createdAtMeta));
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
      createdAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
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
      Value<DateTime>? createdAt}) {
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
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (userId.present) map['user_id'] = Variable<String>(userId.value);
    if (name.present) map['name'] = Variable<String>(name.value);
    if (barcode.present) map['barcode'] = Variable<String>(barcode.value);
    if (buyPrice.present) map['buy_price'] = Variable<double>(buyPrice.value);
    if (sellPrice.present) {
      map['sell_price'] = Variable<double>(sellPrice.value);
    }
    if (stockQty.present) map['stock_qty'] = Variable<int>(stockQty.value);
    if (minStock.present) map['min_stock'] = Variable<int>(minStock.value);
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
          ..write('createdAt: $createdAt')
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
  static const VerificationMeta _userIdMeta =
      const VerificationMeta('userId');
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
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('total_debt')) {
      context.handle(
          _totalDebtMeta,
          totalDebt.isAcceptableOrUnknown(
              data['total_debt']!, _totalDebtMeta));
    }
    if (data.containsKey('last_payment_date')) {
      context.handle(
          _lastPaymentDateMeta,
          lastPaymentDate.isAcceptableOrUnknown(
              data['last_payment_date']!, _lastPaymentDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _createdAtMeta,
          createdAt.isAcceptableOrUnknown(
              data['created_at']!, _createdAtMeta));
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
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_payment_date']),
      createdAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
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
      lastPaymentDate:
          serializer.fromJson<DateTime?>(json['lastPaymentDate']),
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
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.totalDebt = const Value.absent(),
    this.lastPaymentDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.phone = const Value.absent(),
    this.totalDebt = const Value.absent(),
    this.lastPaymentDate = const Value.absent(),
    required DateTime createdAt,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (totalDebt != null) 'total_debt': totalDebt,
      if (lastPaymentDate != null) 'last_payment_date': lastPaymentDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String?>? phone,
      Value<double>? totalDebt,
      Value<DateTime?>? lastPaymentDate,
      Value<DateTime>? createdAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      totalDebt: totalDebt ?? this.totalDebt,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (userId.present) map['user_id'] = Variable<String>(userId.value);
    if (name.present) map['name'] = Variable<String>(name.value);
    if (phone.present) map['phone'] = Variable<String>(phone.value);
    if (totalDebt.present) {
      map['total_debt'] = Variable<double>(totalDebt.value);
    }
    if (lastPaymentDate.present) {
      map['last_payment_date'] = Variable<DateTime>(lastPaymentDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
          ..write('createdAt: $createdAt')
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
  static const VerificationMeta _userIdMeta =
      const VerificationMeta('userId');
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
  static const VerificationMeta _amountMeta =
      const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
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
  static const VerificationMeta _syncedMeta =
      const VerificationMeta('synced');
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
      context.handle(
          _productIdMeta,
          productId.isAcceptableOrUnknown(
              data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
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
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _createdAtMeta,
          createdAt.isAcceptableOrUnknown(
              data['created_at']!, _createdAtMeta));
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
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
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
        quantity: quantity ?? this.quantity,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
      );
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
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, customerId, productId, type,
      payment, amount, quantity, notes, createdAt, synced);
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
  final Value<int> quantity;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.productId = const Value.absent(),
    this.type = const Value.absent(),
    this.payment = const Value.absent(),
    this.amount = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String userId,
    this.customerId = const Value.absent(),
    this.productId = const Value.absent(),
    required String type,
    required String payment,
    required double amount,
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.synced = const Value.absent(),
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
    Expression<int>? quantity,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (customerId != null) 'customer_id': customerId,
      if (productId != null) 'product_id': productId,
      if (type != null) 'type': type,
      if (payment != null) 'payment': payment,
      if (amount != null) 'amount': amount,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
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
      Value<int>? quantity,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<bool>? synced}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      payment: payment ?? this.payment,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (userId.present) map['user_id'] = Variable<String>(userId.value);
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (type.present) map['type'] = Variable<String>(type.value);
    if (payment.present) map['payment'] = Variable<String>(payment.value);
    if (amount.present) map['amount'] = Variable<double>(amount.value);
    if (quantity.present) map['quantity'] = Variable<int>(quantity.value);
    if (notes.present) map['notes'] = Variable<String>(notes.value);
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) map['synced'] = Variable<bool>(synced.value);
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
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
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
  static const VerificationMeta _userIdMeta =
      const VerificationMeta('userId');
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
      context.handle(
          _updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(
              data['updated_at']!, _updatedAtMeta));
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
          DriftSqlType.double,
          data['${effectivePrefix}avg_monthly_revenue'])!,
      shareToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}share_token']),
      updatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
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
      avgMonthlyRevenue:
          serializer.fromJson<double>(json['avgMonthlyRevenue']),
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
  const CreditProfilesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.score = const Value.absent(),
    this.monthsActive = const Value.absent(),
    this.avgMonthlyRevenue = const Value.absent(),
    this.shareToken = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CreditProfilesCompanion.insert({
    required String id,
    required String userId,
    this.score = const Value.absent(),
    this.monthsActive = const Value.absent(),
    this.avgMonthlyRevenue = const Value.absent(),
    this.shareToken = const Value.absent(),
    required DateTime updatedAt,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (score != null) 'score': score,
      if (monthsActive != null) 'months_active': monthsActive,
      if (avgMonthlyRevenue != null)
        'avg_monthly_revenue': avgMonthlyRevenue,
      if (shareToken != null) 'share_token': shareToken,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CreditProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? score,
      Value<int>? monthsActive,
      Value<double>? avgMonthlyRevenue,
      Value<String?>? shareToken,
      Value<DateTime>? updatedAt}) {
    return CreditProfilesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      score: score ?? this.score,
      monthsActive: monthsActive ?? this.monthsActive,
      avgMonthlyRevenue: avgMonthlyRevenue ?? this.avgMonthlyRevenue,
      shareToken: shareToken ?? this.shareToken,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (userId.present) map['user_id'] = Variable<String>(userId.value);
    if (score.present) map['score'] = Variable<int>(score.value);
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
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $CreditProfilesTable creditProfiles =
      $CreditProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, products, customers, transactions, creditProfiles];
}
