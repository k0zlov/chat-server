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
  /// Unique identifier for each post.
  final int id;

  /// Subject of the post.
  final String subject;

  /// Content of the post.
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
  static const VerificationMeta _lastActivityAtMeta =
      const VerificationMeta('lastActivityAt');
  @override
  late final GeneratedColumn<PgDateTime> lastActivityAt =
      GeneratedColumn<PgDateTime>('last_activity_at', aliasedName, false,
          type: PgTypes.timestampWithTimezone,
          requiredDuringInsert: false,
          defaultValue: const FunctionCallExpression('now', []));
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
        lastActivityAt,
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
    if (data.containsKey('last_activity_at')) {
      context.handle(
          _lastActivityAtMeta,
          lastActivityAt.isAcceptableOrUnknown(
              data['last_activity_at']!, _lastActivityAtMeta));
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
      lastActivityAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampWithTimezone,
          data['${effectivePrefix}last_activity_at'])!,
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
  /// Unique identifier for each user.
  final int id;

  /// Name of the user.
  final String name;

  /// Email of the user, must be unique.
  final String email;

  /// Password of the user, with a minimum length constraint.
  final String password;

  /// Refresh token of the user, must be unique.
  final String refreshToken;

  /// Activation code for the user, must be unique.
  final String activation;

  /// Indicates whether the user is activated, with a default value of false.
  final bool isActivated;

  /// Timestamp when the user had last activity, with a default value of the current timestamp.
  final PgDateTime lastActivityAt;

  /// Timestamp when the user was created, with a default value of the current timestamp.
  final PgDateTime createdAt;
  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.refreshToken,
      required this.activation,
      required this.isActivated,
      required this.lastActivityAt,
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
    map['last_activity_at'] =
        Variable<PgDateTime>(lastActivityAt, PgTypes.timestampWithTimezone);
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
      lastActivityAt: Value(lastActivityAt),
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
      lastActivityAt: serializer.fromJson<PgDateTime>(json['lastActivityAt']),
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
      'lastActivityAt': serializer.toJson<PgDateTime>(lastActivityAt),
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
          PgDateTime? lastActivityAt,
          PgDateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        refreshToken: refreshToken ?? this.refreshToken,
        activation: activation ?? this.activation,
        isActivated: isActivated ?? this.isActivated,
        lastActivityAt: lastActivityAt ?? this.lastActivityAt,
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
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, password, refreshToken,
      activation, isActivated, lastActivityAt, createdAt);
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
          other.lastActivityAt == this.lastActivityAt &&
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
  final Value<PgDateTime> lastActivityAt;
  final Value<PgDateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.activation = const Value.absent(),
    this.isActivated = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
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
    this.lastActivityAt = const Value.absent(),
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
    Expression<PgDateTime>? lastActivityAt,
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
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
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
      Value<PgDateTime>? lastActivityAt,
      Value<PgDateTime>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      refreshToken: refreshToken ?? this.refreshToken,
      activation: activation ?? this.activation,
      isActivated: isActivated ?? this.isActivated,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
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
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<PgDateTime>(
          lastActivityAt.value, PgTypes.timestampWithTimezone);
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
          ..write('lastActivityAt: $lastActivityAt, ')
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<ChatType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(ChatType.group.name))
          .withConverter<ChatType>($ChatsTable.$convertertype);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>('created_at', aliasedName, false,
          type: PgTypes.timestampWithTimezone,
          requiredDuringInsert: false,
          defaultValue: const FunctionCallExpression('now', []));
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, title, description, createdAt];
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
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
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
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: $ChatsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
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
  /// Unique identifier for each chat.
  final int id;

  /// Type of the chat, with a default value of 'group'.
  final ChatType type;

  /// Title of the chat.
  final String title;

  /// Description of the chat, which can be nullable.
  final String? description;

  /// Timestamp when the chat was created, with a default value of the current timestamp.
  final PgDateTime createdAt;
  const Chat(
      {required this.id,
      required this.type,
      required this.title,
      this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>($ChatsTable.$convertertype.toSql(type));
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] =
        Variable<PgDateTime>(createdAt, PgTypes.timestampWithTimezone);
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<int>(json['id']),
      type: $ChatsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type':
          serializer.toJson<String>($ChatsTable.$convertertype.toJson(type)),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  Chat copyWith(
          {int? id,
          ChatType? type,
          String? title,
          Value<String?> description = const Value.absent(),
          PgDateTime? createdAt}) =>
      Chat(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, title, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<int> id;
  final Value<ChatType> type;
  final Value<String> title;
  final Value<String?> description;
  final Value<PgDateTime> createdAt;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Chat> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? description,
    Expression<PgDateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChatsCompanion copyWith(
      {Value<int>? id,
      Value<ChatType>? type,
      Value<String>? title,
      Value<String?>? description,
      Value<PgDateTime>? createdAt}) {
    return ChatsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($ChatsTable.$convertertype.toSql(type.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
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
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _contactUserIdMeta =
      const VerificationMeta('contactUserId');
  @override
  late final GeneratedColumn<int> contactUserId = GeneratedColumn<int>(
      'contact_user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
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
  /// References the user ID from the [Users] table, with cascade delete.
  final int userId;

  /// References the contact user ID from the [Users] table, with cascade delete.
  final int contactUserId;

  /// Timestamp when the contact was added, with a default value of the current timestamp.
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

class $ChatParticipantsTable extends ChatParticipants
    with TableInfo<$ChatParticipantsTable, ChatParticipant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatParticipantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES chats (id) ON DELETE CASCADE'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumnWithTypeConverter<ChatParticipantRole, String>
      role = GeneratedColumn<String>('role', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(ChatParticipantRole.member.name))
          .withConverter<ChatParticipantRole>(
              $ChatParticipantsTable.$converterrole);
  static const VerificationMeta _joinedAtMeta =
      const VerificationMeta('joinedAt');
  @override
  late final GeneratedColumn<PgDateTime> joinedAt = GeneratedColumn<PgDateTime>(
      'joined_at', aliasedName, false,
      type: PgTypes.timestampWithTimezone,
      requiredDuringInsert: false,
      defaultValue: const FunctionCallExpression('now', []));
  @override
  List<GeneratedColumn> get $columns => [chatId, userId, role, joinedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_participants';
  @override
  VerificationContext validateIntegrity(Insertable<ChatParticipant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    context.handle(_roleMeta, const VerificationResult.success());
    if (data.containsKey('joined_at')) {
      context.handle(_joinedAtMeta,
          joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chatId, userId};
  @override
  ChatParticipant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatParticipant(
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      role: $ChatParticipantsTable.$converterrole.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!),
      joinedAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampWithTimezone, data['${effectivePrefix}joined_at'])!,
    );
  }

  @override
  $ChatParticipantsTable createAlias(String alias) {
    return $ChatParticipantsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChatParticipantRole, String, String>
      $converterrole =
      const EnumNameConverter<ChatParticipantRole>(ChatParticipantRole.values);
}

class ChatParticipant extends DataClass implements Insertable<ChatParticipant> {
  /// References the chat ID from the [Chats] table.
  final int chatId;

  /// References the user ID from the [Users] table.
  final int userId;

  /// Role of the chat participant, with a default value of 'member'.
  final ChatParticipantRole role;

  /// Timestamp when the user joined the chat, with a default value of the current timestamp.
  final PgDateTime joinedAt;
  const ChatParticipant(
      {required this.chatId,
      required this.userId,
      required this.role,
      required this.joinedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chat_id'] = Variable<int>(chatId);
    map['user_id'] = Variable<int>(userId);
    {
      map['role'] =
          Variable<String>($ChatParticipantsTable.$converterrole.toSql(role));
    }
    map['joined_at'] =
        Variable<PgDateTime>(joinedAt, PgTypes.timestampWithTimezone);
    return map;
  }

  ChatParticipantsCompanion toCompanion(bool nullToAbsent) {
    return ChatParticipantsCompanion(
      chatId: Value(chatId),
      userId: Value(userId),
      role: Value(role),
      joinedAt: Value(joinedAt),
    );
  }

  factory ChatParticipant.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatParticipant(
      chatId: serializer.fromJson<int>(json['chatId']),
      userId: serializer.fromJson<int>(json['userId']),
      role: $ChatParticipantsTable.$converterrole
          .fromJson(serializer.fromJson<String>(json['role'])),
      joinedAt: serializer.fromJson<PgDateTime>(json['joinedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chatId': serializer.toJson<int>(chatId),
      'userId': serializer.toJson<int>(userId),
      'role': serializer
          .toJson<String>($ChatParticipantsTable.$converterrole.toJson(role)),
      'joinedAt': serializer.toJson<PgDateTime>(joinedAt),
    };
  }

  ChatParticipant copyWith(
          {int? chatId,
          int? userId,
          ChatParticipantRole? role,
          PgDateTime? joinedAt}) =>
      ChatParticipant(
        chatId: chatId ?? this.chatId,
        userId: userId ?? this.userId,
        role: role ?? this.role,
        joinedAt: joinedAt ?? this.joinedAt,
      );
  @override
  String toString() {
    return (StringBuffer('ChatParticipant(')
          ..write('chatId: $chatId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chatId, userId, role, joinedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatParticipant &&
          other.chatId == this.chatId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.joinedAt == this.joinedAt);
}

class ChatParticipantsCompanion extends UpdateCompanion<ChatParticipant> {
  final Value<int> chatId;
  final Value<int> userId;
  final Value<ChatParticipantRole> role;
  final Value<PgDateTime> joinedAt;
  final Value<int> rowid;
  const ChatParticipantsCompanion({
    this.chatId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatParticipantsCompanion.insert({
    required int chatId,
    required int userId,
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : chatId = Value(chatId),
        userId = Value(userId);
  static Insertable<ChatParticipant> custom({
    Expression<int>? chatId,
    Expression<int>? userId,
    Expression<String>? role,
    Expression<PgDateTime>? joinedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chatId != null) 'chat_id': chatId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatParticipantsCompanion copyWith(
      {Value<int>? chatId,
      Value<int>? userId,
      Value<ChatParticipantRole>? role,
      Value<PgDateTime>? joinedAt,
      Value<int>? rowid}) {
    return ChatParticipantsCompanion(
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
          $ChatParticipantsTable.$converterrole.toSql(role.value));
    }
    if (joinedAt.present) {
      map['joined_at'] =
          Variable<PgDateTime>(joinedAt.value, PgTypes.timestampWithTimezone);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatParticipantsCompanion(')
          ..write('chatId: $chatId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content =
      GeneratedColumn<String>('content', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES chats (id) ON DELETE CASCADE'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>('updated_at', aliasedName, false,
          type: PgTypes.timestampWithTimezone,
          requiredDuringInsert: false,
          defaultValue: const FunctionCallExpression('now', []));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>('created_at', aliasedName, false,
          type: PgTypes.timestampWithTimezone,
          requiredDuringInsert: false,
          defaultValue: const FunctionCallExpression('now', []));
  @override
  List<GeneratedColumn> get $columns =>
      [id, content, userId, chatId, updatedAt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
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
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_id'])!,
      updatedAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampWithTimezone, data['${effectivePrefix}updated_at'])!,
      createdAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampWithTimezone, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  /// Unique identifier for each message.
  final int id;

  /// Content of the message, with a minimum length constraint.
  final String content;

  /// References the user ID from the [Users] table, with cascade delete.
  final int userId;

  /// References the chat ID from the [Chats] table, with cascade delete.
  final int chatId;

  /// Timestamp when the message was last updated, with a default value of the current timestamp.
  final PgDateTime updatedAt;

  /// Timestamp when the message was created, with a default value of the current timestamp.
  final PgDateTime createdAt;
  const Message(
      {required this.id,
      required this.content,
      required this.userId,
      required this.chatId,
      required this.updatedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['user_id'] = Variable<int>(userId);
    map['chat_id'] = Variable<int>(chatId);
    map['updated_at'] =
        Variable<PgDateTime>(updatedAt, PgTypes.timestampWithTimezone);
    map['created_at'] =
        Variable<PgDateTime>(createdAt, PgTypes.timestampWithTimezone);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      content: Value(content),
      userId: Value(userId),
      chatId: Value(chatId),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      userId: serializer.fromJson<int>(json['userId']),
      chatId: serializer.fromJson<int>(json['chatId']),
      updatedAt: serializer.fromJson<PgDateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'userId': serializer.toJson<int>(userId),
      'chatId': serializer.toJson<int>(chatId),
      'updatedAt': serializer.toJson<PgDateTime>(updatedAt),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  Message copyWith(
          {int? id,
          String? content,
          int? userId,
          int? chatId,
          PgDateTime? updatedAt,
          PgDateTime? createdAt}) =>
      Message(
        id: id ?? this.id,
        content: content ?? this.content,
        userId: userId ?? this.userId,
        chatId: chatId ?? this.chatId,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('userId: $userId, ')
          ..write('chatId: $chatId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, userId, chatId, updatedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.content == this.content &&
          other.userId == this.userId &&
          other.chatId == this.chatId &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<int> id;
  final Value<String> content;
  final Value<int> userId;
  final Value<int> chatId;
  final Value<PgDateTime> updatedAt;
  final Value<PgDateTime> createdAt;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.userId = const Value.absent(),
    this.chatId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required int userId,
    required int chatId,
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : content = Value(content),
        userId = Value(userId),
        chatId = Value(chatId);
  static Insertable<Message> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<int>? userId,
    Expression<int>? chatId,
    Expression<PgDateTime>? updatedAt,
    Expression<PgDateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (userId != null) 'user_id': userId,
      if (chatId != null) 'chat_id': chatId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MessagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? content,
      Value<int>? userId,
      Value<int>? chatId,
      Value<PgDateTime>? updatedAt,
      Value<PgDateTime>? createdAt}) {
    return MessagesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] =
          Variable<PgDateTime>(updatedAt.value, PgTypes.timestampWithTimezone);
    }
    if (createdAt.present) {
      map['created_at'] =
          Variable<PgDateTime>(createdAt.value, PgTypes.timestampWithTimezone);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('userId: $userId, ')
          ..write('chatId: $chatId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
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
  late final $ChatParticipantsTable chatParticipants =
      $ChatParticipantsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [posts, users, chats, contacts, chatParticipants, messages];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('contacts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('contacts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('chats',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chat_participants', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chat_participants', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('messages', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('chats',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('messages', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
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
  Value<PgDateTime> lastActivityAt,
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
  Value<PgDateTime> lastActivityAt,
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
            Value<PgDateTime> lastActivityAt = const Value.absent(),
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
            lastActivityAt: lastActivityAt,
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
            Value<PgDateTime> lastActivityAt = const Value.absent(),
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
            lastActivityAt: lastActivityAt,
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

  ColumnFilters<PgDateTime> get lastActivityAt => $state.composableBuilder(
      column: $state.table.lastActivityAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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

  ComposableFilter chatParticipantUsers(
      ComposableFilter Function($$ChatParticipantsTableFilterComposer f) f) {
    final $$ChatParticipantsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.chatParticipants,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder, parentComposers) =>
                $$ChatParticipantsTableFilterComposer(ComposerState($state.db,
                    $state.db.chatParticipants, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter messageAuthors(
      ComposableFilter Function($$MessagesTableFilterComposer f) f) {
    final $$MessagesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.messages,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder, parentComposers) =>
            $$MessagesTableFilterComposer(ComposerState(
                $state.db, $state.db.messages, joinBuilder, parentComposers)));
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

  ColumnOrderings<PgDateTime> get lastActivityAt => $state.composableBuilder(
      column: $state.table.lastActivityAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ChatsTableInsertCompanionBuilder = ChatsCompanion Function({
  Value<int> id,
  Value<ChatType> type,
  required String title,
  Value<String?> description,
  Value<PgDateTime> createdAt,
});
typedef $$ChatsTableUpdateCompanionBuilder = ChatsCompanion Function({
  Value<int> id,
  Value<ChatType> type,
  Value<String> title,
  Value<String?> description,
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
            Value<ChatType> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<PgDateTime> createdAt = const Value.absent(),
          }) =>
              ChatsCompanion(
            id: id,
            type: type,
            title: title,
            description: description,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<ChatType> type = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            Value<PgDateTime> createdAt = const Value.absent(),
          }) =>
              ChatsCompanion.insert(
            id: id,
            type: type,
            title: title,
            description: description,
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

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter chatParticipantChats(
      ComposableFilter Function($$ChatParticipantsTableFilterComposer f) f) {
    final $$ChatParticipantsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.chatParticipants,
            getReferencedColumn: (t) => t.chatId,
            builder: (joinBuilder, parentComposers) =>
                $$ChatParticipantsTableFilterComposer(ComposerState($state.db,
                    $state.db.chatParticipants, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter messageChats(
      ComposableFilter Function($$MessagesTableFilterComposer f) f) {
    final $$MessagesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.messages,
        getReferencedColumn: (t) => t.chatId,
        builder: (joinBuilder, parentComposers) =>
            $$MessagesTableFilterComposer(ComposerState(
                $state.db, $state.db.messages, joinBuilder, parentComposers)));
    return f(composer);
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

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
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

typedef $$ChatParticipantsTableInsertCompanionBuilder
    = ChatParticipantsCompanion Function({
  required int chatId,
  required int userId,
  Value<ChatParticipantRole> role,
  Value<PgDateTime> joinedAt,
  Value<int> rowid,
});
typedef $$ChatParticipantsTableUpdateCompanionBuilder
    = ChatParticipantsCompanion Function({
  Value<int> chatId,
  Value<int> userId,
  Value<ChatParticipantRole> role,
  Value<PgDateTime> joinedAt,
  Value<int> rowid,
});

class $$ChatParticipantsTableTableManager extends RootTableManager<
    _$Database,
    $ChatParticipantsTable,
    ChatParticipant,
    $$ChatParticipantsTableFilterComposer,
    $$ChatParticipantsTableOrderingComposer,
    $$ChatParticipantsTableProcessedTableManager,
    $$ChatParticipantsTableInsertCompanionBuilder,
    $$ChatParticipantsTableUpdateCompanionBuilder> {
  $$ChatParticipantsTableTableManager(
      _$Database db, $ChatParticipantsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ChatParticipantsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ChatParticipantsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ChatParticipantsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> chatId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<ChatParticipantRole> role = const Value.absent(),
            Value<PgDateTime> joinedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatParticipantsCompanion(
            chatId: chatId,
            userId: userId,
            role: role,
            joinedAt: joinedAt,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required int chatId,
            required int userId,
            Value<ChatParticipantRole> role = const Value.absent(),
            Value<PgDateTime> joinedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatParticipantsCompanion.insert(
            chatId: chatId,
            userId: userId,
            role: role,
            joinedAt: joinedAt,
            rowid: rowid,
          ),
        ));
}

class $$ChatParticipantsTableProcessedTableManager
    extends ProcessedTableManager<
        _$Database,
        $ChatParticipantsTable,
        ChatParticipant,
        $$ChatParticipantsTableFilterComposer,
        $$ChatParticipantsTableOrderingComposer,
        $$ChatParticipantsTableProcessedTableManager,
        $$ChatParticipantsTableInsertCompanionBuilder,
        $$ChatParticipantsTableUpdateCompanionBuilder> {
  $$ChatParticipantsTableProcessedTableManager(super.$state);
}

class $$ChatParticipantsTableFilterComposer
    extends FilterComposer<_$Database, $ChatParticipantsTable> {
  $$ChatParticipantsTableFilterComposer(super.$state);
  ColumnWithTypeConverterFilters<ChatParticipantRole, ChatParticipantRole,
          String>
      get role => $state.composableBuilder(
          column: $state.table.role,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<PgDateTime> get joinedAt => $state.composableBuilder(
      column: $state.table.joinedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $state.db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ChatsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.chats, joinBuilder, parentComposers)));
    return composer;
  }

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
}

class $$ChatParticipantsTableOrderingComposer
    extends OrderingComposer<_$Database, $ChatParticipantsTable> {
  $$ChatParticipantsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<PgDateTime> get joinedAt => $state.composableBuilder(
      column: $state.table.joinedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $state.db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ChatsTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.chats, joinBuilder, parentComposers)));
    return composer;
  }

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
}

typedef $$MessagesTableInsertCompanionBuilder = MessagesCompanion Function({
  Value<int> id,
  required String content,
  required int userId,
  required int chatId,
  Value<PgDateTime> updatedAt,
  Value<PgDateTime> createdAt,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<int> id,
  Value<String> content,
  Value<int> userId,
  Value<int> chatId,
  Value<PgDateTime> updatedAt,
  Value<PgDateTime> createdAt,
});

class $$MessagesTableTableManager extends RootTableManager<
    _$Database,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableProcessedTableManager,
    $$MessagesTableInsertCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder> {
  $$MessagesTableTableManager(_$Database db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MessagesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MessagesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$MessagesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> chatId = const Value.absent(),
            Value<PgDateTime> updatedAt = const Value.absent(),
            Value<PgDateTime> createdAt = const Value.absent(),
          }) =>
              MessagesCompanion(
            id: id,
            content: content,
            userId: userId,
            chatId: chatId,
            updatedAt: updatedAt,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String content,
            required int userId,
            required int chatId,
            Value<PgDateTime> updatedAt = const Value.absent(),
            Value<PgDateTime> createdAt = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            id: id,
            content: content,
            userId: userId,
            chatId: chatId,
            updatedAt: updatedAt,
            createdAt: createdAt,
          ),
        ));
}

class $$MessagesTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableProcessedTableManager,
    $$MessagesTableInsertCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder> {
  $$MessagesTableProcessedTableManager(super.$state);
}

class $$MessagesTableFilterComposer
    extends FilterComposer<_$Database, $MessagesTable> {
  $$MessagesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<PgDateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
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

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $state.db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ChatsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.chats, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$MessagesTableOrderingComposer
    extends OrderingComposer<_$Database, $MessagesTable> {
  $$MessagesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<PgDateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<PgDateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
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

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $state.db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ChatsTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.chats, joinBuilder, parentComposers)));
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
  $$ChatParticipantsTableTableManager get chatParticipants =>
      $$ChatParticipantsTableTableManager(_db, _db.chatParticipants);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
}
