// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PostsTable extends Posts with TableInfo<$PostsTable, Post> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _subjectMeta =
      const VerificationMeta('subject');
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
      'subject', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, subject, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posts';
  @override
  VerificationContext validateIntegrity(Insertable<Post> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta));
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Post map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Post(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      subject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $PostsTable createAlias(String alias) {
    return $PostsTable(attachedDatabase, alias);
  }
}

class Post extends DataClass implements Insertable<Post> {
  final int id;
  final String subject;
  final String content;
  const Post({required this.id, required this.subject, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject'] = Variable<String>(subject);
    map['content'] = Variable<String>(content);
    return map;
  }

  PostsCompanion toCompanion(bool nullToAbsent) {
    return PostsCompanion(
      id: Value(id),
      subject: Value(subject),
      content: Value(content),
    );
  }

  factory Post.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Post(
      id: serializer.fromJson<int>(json['id']),
      subject: serializer.fromJson<String>(json['subject']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subject': serializer.toJson<String>(subject),
      'content': serializer.toJson<String>(content),
    };
  }

  Post copyWith({int? id, String? subject, String? content}) => Post(
        id: id ?? this.id,
        subject: subject ?? this.subject,
        content: content ?? this.content,
      );
  @override
  String toString() {
    return (StringBuffer('Post(')
          ..write('id: $id, ')
          ..write('subject: $subject, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subject, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          other.id == this.id &&
          other.subject == this.subject &&
          other.content == this.content);
}

class PostsCompanion extends UpdateCompanion<Post> {
  final Value<int> id;
  final Value<String> subject;
  final Value<String> content;
  const PostsCompanion({
    this.id = const Value.absent(),
    this.subject = const Value.absent(),
    this.content = const Value.absent(),
  });
  PostsCompanion.insert({
    this.id = const Value.absent(),
    required String subject,
    required String content,
  })  : subject = Value(subject),
        content = Value(content);
  static Insertable<Post> custom({
    Expression<int>? id,
    Expression<String>? subject,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subject != null) 'subject': subject,
      if (content != null) 'content': content,
    });
  }

  PostsCompanion copyWith(
      {Value<int>? id, Value<String>? subject, Value<String>? content}) {
    return PostsCompanion(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostsCompanion(')
          ..write('id: $id, ')
          ..write('subject: $subject, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password =
      GeneratedColumn<String>('password', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 6,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _refreshTokenMeta =
      const VerificationMeta('refreshToken');
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
      'refresh_token', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _activationMeta =
      const VerificationMeta('activation');
  @override
  late final GeneratedColumn<String> activation = GeneratedColumn<String>(
      'activation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _isActivatedMeta =
      const VerificationMeta('isActivated');
  @override
  late final GeneratedColumn<bool> isActivated = GeneratedColumn<bool>(
      'is_activated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>('created_at', aliasedName, false,
          type: PgTypes.timestampWithTimezone,
          requiredDuringInsert: false,
          defaultValue: const FunctionCallExpression('now', []));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        email,
        password,
        refreshToken,
        activation,
        isActivated,
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
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
          _refreshTokenMeta,
          refreshToken.isAcceptableOrUnknown(
              data['refresh_token']!, _refreshTokenMeta));
    } else if (isInserting) {
      context.missing(_refreshTokenMeta);
    }
    if (data.containsKey('activation')) {
      context.handle(
          _activationMeta,
          activation.isAcceptableOrUnknown(
              data['activation']!, _activationMeta));
    } else if (isInserting) {
      context.missing(_activationMeta);
    }
    if (data.containsKey('is_activated')) {
      context.handle(
          _isActivatedMeta,
          isActivated.isAcceptableOrUnknown(
              data['is_activated']!, _isActivatedMeta));
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
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      refreshToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}refresh_token'])!,
      activation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activation'])!,
      isActivated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_activated'])!,
      createdAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampWithTimezone, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String email;
  final String password;
  final String refreshToken;
  final String activation;
  final bool isActivated;
  final PgDateTime createdAt;
  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.refreshToken,
      required this.activation,
      required this.isActivated,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    map['refresh_token'] = Variable<String>(refreshToken);
    map['activation'] = Variable<String>(activation);
    map['is_activated'] = Variable<bool>(isActivated);
    map['created_at'] =
        Variable<PgDateTime>(createdAt, PgTypes.timestampWithTimezone);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      password: Value(password),
      refreshToken: Value(refreshToken),
      activation: Value(activation),
      isActivated: Value(isActivated),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      refreshToken: serializer.fromJson<String>(json['refreshToken']),
      activation: serializer.fromJson<String>(json['activation']),
      isActivated: serializer.fromJson<bool>(json['isActivated']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'refreshToken': serializer.toJson<String>(refreshToken),
      'activation': serializer.toJson<String>(activation),
      'isActivated': serializer.toJson<bool>(isActivated),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          String? email,
          String? password,
          String? refreshToken,
          String? activation,
          bool? isActivated,
          PgDateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        refreshToken: refreshToken ?? this.refreshToken,
        activation: activation ?? this.activation,
        isActivated: isActivated ?? this.isActivated,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('activation: $activation, ')
          ..write('isActivated: $isActivated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, password, refreshToken,
      activation, isActivated, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.password == this.password &&
          other.refreshToken == this.refreshToken &&
          other.activation == this.activation &&
          other.isActivated == this.isActivated &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> password;
  final Value<String> refreshToken;
  final Value<String> activation;
  final Value<bool> isActivated;
  final Value<PgDateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.activation = const Value.absent(),
    this.isActivated = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    required String password,
    required String refreshToken,
    required String activation,
    this.isActivated = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        email = Value(email),
        password = Value(password),
        refreshToken = Value(refreshToken),
        activation = Value(activation);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? refreshToken,
    Expression<String>? activation,
    Expression<bool>? isActivated,
    Expression<PgDateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (activation != null) 'activation': activation,
      if (isActivated != null) 'is_activated': isActivated,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? password,
      Value<String>? refreshToken,
      Value<String>? activation,
      Value<bool>? isActivated,
      Value<PgDateTime>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      refreshToken: refreshToken ?? this.refreshToken,
      activation: activation ?? this.activation,
      isActivated: isActivated ?? this.isActivated,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (activation.present) {
      map['activation'] = Variable<String>(activation.value);
    }
    if (isActivated.present) {
      map['is_activated'] = Variable<bool>(isActivated.value);
    }
    if (createdAt.present) {
      map['created_at'] =
          Variable<PgDateTime>(createdAt.value, PgTypes.timestampWithTimezone);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('activation: $activation, ')
          ..write('isActivated: $isActivated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<ChatType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<ChatType>($ChatsTable.$convertertype);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>('created_at', aliasedName, false,
          type: PgTypes.timestampWithTimezone,
          requiredDuringInsert: false,
          defaultValue: const FunctionCallExpression('now', []));
  @override
  List<GeneratedColumn> get $columns => [id, ownerId, type, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner_id'])!,
      type: $ChatsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      createdAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampWithTimezone, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChatType, String, String> $convertertype =
      const EnumNameConverter<ChatType>(ChatType.values);
}

class Chat extends DataClass implements Insertable<Chat> {
  final int id;
  final int ownerId;
  final ChatType type;
  final PgDateTime createdAt;
  const Chat(
      {required this.id,
      required this.ownerId,
      required this.type,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_id'] = Variable<int>(ownerId);
    {
      map['type'] = Variable<String>($ChatsTable.$convertertype.toSql(type));
    }
    map['created_at'] =
        Variable<PgDateTime>(createdAt, PgTypes.timestampWithTimezone);
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<int>(json['id']),
      ownerId: serializer.fromJson<int>(json['ownerId']),
      type: $ChatsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerId': serializer.toJson<int>(ownerId),
      'type':
          serializer.toJson<String>($ChatsTable.$convertertype.toJson(type)),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  Chat copyWith(
          {int? id, int? ownerId, ChatType? type, PgDateTime? createdAt}) =>
      Chat(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<int> id;
  final Value<int> ownerId;
  final Value<ChatType> type;
  final Value<PgDateTime> createdAt;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    required int ownerId,
    required ChatType type,
    this.createdAt = const Value.absent(),
  })  : ownerId = Value(ownerId),
        type = Value(type);
  static Insertable<Chat> custom({
    Expression<int>? id,
    Expression<int>? ownerId,
    Expression<String>? type,
    Expression<PgDateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChatsCompanion copyWith(
      {Value<int>? id,
      Value<int>? ownerId,
      Value<ChatType>? type,
      Value<PgDateTime>? createdAt}) {
    return ChatsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($ChatsTable.$convertertype.toSql(type.value));
    }
    if (createdAt.present) {
      map['created_at'] =
          Variable<PgDateTime>(createdAt.value, PgTypes.timestampWithTimezone);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _contactUserIdMeta =
      const VerificationMeta('contactUserId');
  @override
  late final GeneratedColumn<int> contactUserId = GeneratedColumn<int>(
      'contact_user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<PgDateTime> addedAt = GeneratedColumn<PgDateTime>(
      'added_at', aliasedName, false,
      type: PgTypes.timestampWithTimezone,
      requiredDuringInsert: false,
      defaultValue: const FunctionCallExpression('now', []));
  @override
  List<GeneratedColumn> get $columns => [userId, contactUserId, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(Insertable<Contact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('contact_user_id')) {
      context.handle(
          _contactUserIdMeta,
          contactUserId.isAcceptableOrUnknown(
              data['contact_user_id']!, _contactUserIdMeta));
    } else if (isInserting) {
      context.missing(_contactUserIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, contactUserId};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      contactUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}contact_user_id'])!,
      addedAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampWithTimezone, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final int userId;
  final int contactUserId;
  final PgDateTime addedAt;
  const Contact(
      {required this.userId,
      required this.contactUserId,
      required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['contact_user_id'] = Variable<int>(contactUserId);
    map['added_at'] =
        Variable<PgDateTime>(addedAt, PgTypes.timestampWithTimezone);
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      userId: Value(userId),
      contactUserId: Value(contactUserId),
      addedAt: Value(addedAt),
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      userId: serializer.fromJson<int>(json['userId']),
      contactUserId: serializer.fromJson<int>(json['contactUserId']),
      addedAt: serializer.fromJson<PgDateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'contactUserId': serializer.toJson<int>(contactUserId),
      'addedAt': serializer.toJson<PgDateTime>(addedAt),
    };
  }

  Contact copyWith({int? userId, int? contactUserId, PgDateTime? addedAt}) =>
      Contact(
        userId: userId ?? this.userId,
        contactUserId: contactUserId ?? this.contactUserId,
        addedAt: addedAt ?? this.addedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('userId: $userId, ')
          ..write('contactUserId: $contactUserId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, contactUserId, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.userId == this.userId &&
          other.contactUserId == this.contactUserId &&
          other.addedAt == this.addedAt);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<int> userId;
  final Value<int> contactUserId;
  final Value<PgDateTime> addedAt;
  final Value<int> rowid;
  const ContactsCompanion({
    this.userId = const Value.absent(),
    this.contactUserId = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsCompanion.insert({
    required int userId,
    required int contactUserId,
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        contactUserId = Value(contactUserId);
  static Insertable<Contact> custom({
    Expression<int>? userId,
    Expression<int>? contactUserId,
    Expression<PgDateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (contactUserId != null) 'contact_user_id': contactUserId,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsCompanion copyWith(
      {Value<int>? userId,
      Value<int>? contactUserId,
      Value<PgDateTime>? addedAt,
      Value<int>? rowid}) {
    return ContactsCompanion(
      userId: userId ?? this.userId,
      contactUserId: contactUserId ?? this.contactUserId,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (contactUserId.present) {
      map['contact_user_id'] = Variable<int>(contactUserId.value);
    }
    if (addedAt.present) {
      map['added_at'] =
          Variable<PgDateTime>(addedAt.value, PgTypes.timestampWithTimezone);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('userId: $userId, ')
          ..write('contactUserId: $contactUserId, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  _$DatabaseManager get managers => _$DatabaseManager(this);
  late final $PostsTable posts = $PostsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [posts, users, chats, contacts];
}

typedef $$PostsTableInsertCompanionBuilder = PostsCompanion Function({
  Value<int> id,
  required String subject,
  required String content,
});
typedef $$PostsTableUpdateCompanionBuilder = PostsCompanion Function({
  Value<int> id,
  Value<String> subject,
  Value<String> content,
});

class $$PostsTableTableManager extends RootTableManager<
    _$Database,
    $PostsTable,
    Post,
    $$PostsTableFilterComposer,
    $$PostsTableOrderingComposer,
    $$PostsTableProcessedTableManager,
    $$PostsTableInsertCompanionBuilder,
    $$PostsTableUpdateCompanionBuilder> {
  $$PostsTableTableManager(_$Database db, $PostsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PostsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PostsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$PostsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> subject = const Value.absent(),
            Value<String> content = const Value.absent(),
          }) =>
              PostsCompanion(
            id: id,
            subject: subject,
            content: content,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String subject,
            required String content,
          }) =>
              PostsCompanion.insert(
            id: id,
            subject: subject,
            content: content,
          ),
        ));
}

class $$PostsTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $PostsTable,
    Post,
    $$PostsTableFilterComposer,
    $$PostsTableOrderingComposer,
    $$PostsTableProcessedTableManager,
    $$PostsTableInsertCompanionBuilder,
    $$PostsTableUpdateCompanionBuilder> {
  $$PostsTableProcessedTableManager(super.$state);
}

class $$PostsTableFilterComposer
    extends FilterComposer<_$Database, $PostsTable> {
  $$PostsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get subject => $state.composableBuilder(
      column: $state.table.subject,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PostsTableOrderingComposer
    extends OrderingComposer<_$Database, $PostsTable> {
  $$PostsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get subject => $state.composableBuilder(
      column: $state.table.subject,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$UsersTableInsertCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String name,
  required String email,
  required String password,
  required String refreshToken,
  required String activation,
  Value<bool> isActivated,
  Value<PgDateTime> createdAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
  Value<String> password,
  Value<String> refreshToken,
  Value<String> activation,
  Value<bool> isActivated,
  Value<PgDateTime> createdAt,
});

class $$UsersTableTableManager extends RootTableManager<
    _$Database,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableProcessedTableManager,
    $$UsersTableInsertCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder> {
  $$UsersTableTableManager(_$Database db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UsersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UsersTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$UsersTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> refreshToken = const Value.absent(),
            Value<String> activation = const Value.absent(),
            Value<bool> isActivated = const Value.absent(),
            Value<PgDateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            email: email,
            password: password,
            refreshToken: refreshToken,
            activation: activation,
            isActivated: isActivated,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String email,
            required String password,
            required String refreshToken,
            required String activation,
            Value<bool> isActivated = const Value.absent(),
            Value<PgDateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            email: email,
            password: password,
            refreshToken: refreshToken,
            activation: activation,
            isActivated: isActivated,
            createdAt: createdAt,
          ),
        ));
}

class $$UsersTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableProcessedTableManager,
    $$UsersTableInsertCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder> {
  $$UsersTableProcessedTableManager(super.$state);
}

class $$UsersTableFilterComposer
    extends FilterComposer<_$Database, $UsersTable> {
  $$UsersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get password => $state.composableBuilder(
      column: $state.table.password,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get refreshToken => $state.composableBuilder(
      column: $state.table.refreshToken,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get activation => $state.composableBuilder(
      column: $state.table.activation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActivated => $state.composableBuilder(
      column: $state.table.isActivated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter chatOwners(
      ComposableFilter Function($$ChatsTableFilterComposer f) f) {
    final $$ChatsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.chats,
        getReferencedColumn: (t) => t.ownerId,
        builder: (joinBuilder, parentComposers) => $$ChatsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.chats, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter contactOwners(
      ComposableFilter Function($$ContactsTableFilterComposer f) f) {
    final $$ContactsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.contacts,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder, parentComposers) =>
            $$ContactsTableFilterComposer(ComposerState(
                $state.db, $state.db.contacts, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter contactTargets(
      ComposableFilter Function($$ContactsTableFilterComposer f) f) {
    final $$ContactsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.contacts,
        getReferencedColumn: (t) => t.contactUserId,
        builder: (joinBuilder, parentComposers) =>
            $$ContactsTableFilterComposer(ComposerState(
                $state.db, $state.db.contacts, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends OrderingComposer<_$Database, $UsersTable> {
  $$UsersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get password => $state.composableBuilder(
      column: $state.table.password,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get refreshToken => $state.composableBuilder(
      column: $state.table.refreshToken,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get activation => $state.composableBuilder(
      column: $state.table.activation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActivated => $state.composableBuilder(
      column: $state.table.isActivated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ChatsTableInsertCompanionBuilder = ChatsCompanion Function({
  Value<int> id,
  required int ownerId,
  required ChatType type,
  Value<PgDateTime> createdAt,
});
typedef $$ChatsTableUpdateCompanionBuilder = ChatsCompanion Function({
  Value<int> id,
  Value<int> ownerId,
  Value<ChatType> type,
  Value<PgDateTime> createdAt,
});

class $$ChatsTableTableManager extends RootTableManager<
    _$Database,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableProcessedTableManager,
    $$ChatsTableInsertCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder> {
  $$ChatsTableTableManager(_$Database db, $ChatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ChatsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ChatsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$ChatsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> ownerId = const Value.absent(),
            Value<ChatType> type = const Value.absent(),
            Value<PgDateTime> createdAt = const Value.absent(),
          }) =>
              ChatsCompanion(
            id: id,
            ownerId: ownerId,
            type: type,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int ownerId,
            required ChatType type,
            Value<PgDateTime> createdAt = const Value.absent(),
          }) =>
              ChatsCompanion.insert(
            id: id,
            ownerId: ownerId,
            type: type,
            createdAt: createdAt,
          ),
        ));
}

class $$ChatsTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableProcessedTableManager,
    $$ChatsTableInsertCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder> {
  $$ChatsTableProcessedTableManager(super.$state);
}

class $$ChatsTableFilterComposer
    extends FilterComposer<_$Database, $ChatsTable> {
  $$ChatsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<ChatType, ChatType, String> get type =>
      $state.composableBuilder(
          column: $state.table.type,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$UsersTableFilterComposer get ownerId {
    final $$UsersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ownerId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableFilterComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ChatsTableOrderingComposer
    extends OrderingComposer<_$Database, $ChatsTable> {
  $$ChatsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$UsersTableOrderingComposer get ownerId {
    final $$UsersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ownerId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ContactsTableInsertCompanionBuilder = ContactsCompanion Function({
  required int userId,
  required int contactUserId,
  Value<PgDateTime> addedAt,
  Value<int> rowid,
});
typedef $$ContactsTableUpdateCompanionBuilder = ContactsCompanion Function({
  Value<int> userId,
  Value<int> contactUserId,
  Value<PgDateTime> addedAt,
  Value<int> rowid,
});

class $$ContactsTableTableManager extends RootTableManager<
    _$Database,
    $ContactsTable,
    Contact,
    $$ContactsTableFilterComposer,
    $$ContactsTableOrderingComposer,
    $$ContactsTableProcessedTableManager,
    $$ContactsTableInsertCompanionBuilder,
    $$ContactsTableUpdateCompanionBuilder> {
  $$ContactsTableTableManager(_$Database db, $ContactsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ContactsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ContactsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ContactsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> userId = const Value.absent(),
            Value<int> contactUserId = const Value.absent(),
            Value<PgDateTime> addedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContactsCompanion(
            userId: userId,
            contactUserId: contactUserId,
            addedAt: addedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required int userId,
            required int contactUserId,
            Value<PgDateTime> addedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContactsCompanion.insert(
            userId: userId,
            contactUserId: contactUserId,
            addedAt: addedAt,
            rowid: rowid,
          ),
        ));
}

class $$ContactsTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $ContactsTable,
    Contact,
    $$ContactsTableFilterComposer,
    $$ContactsTableOrderingComposer,
    $$ContactsTableProcessedTableManager,
    $$ContactsTableInsertCompanionBuilder,
    $$ContactsTableUpdateCompanionBuilder> {
  $$ContactsTableProcessedTableManager(super.$state);
}

class $$ContactsTableFilterComposer
    extends FilterComposer<_$Database, $ContactsTable> {
  $$ContactsTableFilterComposer(super.$state);
  ColumnFilters<PgDateTime> get addedAt => $state.composableBuilder(
      column: $state.table.addedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableFilterComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }

  $$UsersTableFilterComposer get contactUserId {
    final $$UsersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contactUserId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableFilterComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ContactsTableOrderingComposer
    extends OrderingComposer<_$Database, $ContactsTable> {
  $$ContactsTableOrderingComposer(super.$state);
  ColumnOrderings<PgDateTime> get addedAt => $state.composableBuilder(
      column: $state.table.addedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }

  $$UsersTableOrderingComposer get contactUserId {
    final $$UsersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contactUserId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

class _$DatabaseManager {
  final _$Database _db;
  _$DatabaseManager(this._db);
  $$PostsTableTableManager get posts =>
      $$PostsTableTableManager(_db, _db.posts);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
}
