// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  HadithDao? _hadithDaoInstance;

  CuzDao? _cuzDaoInstance;

  ListDao? _listDaoInstance;

  SurahDao? _surahDaoInstance;

  VerseDao? _verseDaoInstance;

  TopicDao? _topicDaoInstance;

  SectionDao? _sectionDaoInstance;

  SavePointDao? _savePointDaoInstance;

  TopicSavePointDao? _topicSavePointDaoInstance;

  HistoryDao? _historyDaoInstance;

  BackupMetaDao? _backupMetaDaoInstance;

  BackupDao? _backupDaoInstance;

  UserInfoDao? _userInfoDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `hadith` (`content` TEXT NOT NULL, `source` TEXT NOT NULL, `contentSize` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `rowNumber` INTEGER, `bookId` INTEGER NOT NULL, FOREIGN KEY (`bookId`) REFERENCES `book` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Cuz` (`cuzNo` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`cuzNo`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Surah` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `topic` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `sectionId` INTEGER NOT NULL, FOREIGN KEY (`sectionId`) REFERENCES `section` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `verse` (`surahId` INTEGER NOT NULL, `cuzNo` INTEGER NOT NULL, `pageNo` INTEGER NOT NULL, `verseNumber` TEXT NOT NULL, `content` TEXT NOT NULL, `isProstrationVerse` INTEGER NOT NULL, `pageRank` INTEGER, `surahName` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `rowNumber` INTEGER, `bookId` INTEGER NOT NULL, FOREIGN KEY (`cuzNo`) REFERENCES `Cuz` (`cuzNo`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`surahId`) REFERENCES `Surah` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`bookId`) REFERENCES `book` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `section` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `bookId` INTEGER NOT NULL, FOREIGN KEY (`bookId`) REFERENCES `book` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `IntData` (`data` INTEGER NOT NULL, PRIMARY KEY (`data`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `savePoint` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `itemIndexPos` INTEGER NOT NULL, `title` TEXT NOT NULL, `isAuto` INTEGER NOT NULL, `modifiedDate` TEXT NOT NULL, `savePointType` INTEGER NOT NULL, `bookIdBinary` INTEGER NOT NULL, `parentName` TEXT NOT NULL, `parentKey` TEXT NOT NULL, FOREIGN KEY (`savePointType`) REFERENCES `savePointType` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`bookId`) REFERENCES `book` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `savePointType` (`id` INTEGER, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BackupMeta` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `fileName` TEXT NOT NULL, `updatedDate` TEXT NOT NULL, `isAuto` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `topicSavePoint` (`id` INTEGER, `pos` INTEGER NOT NULL, `type` INTEGER NOT NULL, `parentKey` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `History` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `originType` INTEGER NOT NULL, `modifiedDate` TEXT NOT NULL, FOREIGN KEY (`originType`) REFERENCES `sourceType` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `userInfo` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` TEXT NOT NULL, `img` BLOB)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `list` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `isRemovable` INTEGER NOT NULL, `sourceId` INTEGER NOT NULL, `isArchive` INTEGER NOT NULL, `pos` INTEGER NOT NULL, FOREIGN KEY (`sourceId`) REFERENCES `sourceType` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `sourceType` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sourceType` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ItemCountModel` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `itemCount` INTEGER NOT NULL, `rowNumber` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `verseTopic` (`verseId` INTEGER NOT NULL, `topicId` INTEGER NOT NULL, FOREIGN KEY (`verseId`) REFERENCES `verse` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`topicId`) REFERENCES `topic` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`verseId`, `topicId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `listHadith` (`listId` INTEGER NOT NULL, `hadithId` INTEGER NOT NULL, `pos` INTEGER NOT NULL, FOREIGN KEY (`listId`) REFERENCES `List<dynamic>` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`hadithId`) REFERENCES `hadith` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`listId`, `hadithId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `listVerse` (`listId` INTEGER NOT NULL, `verseId` INTEGER NOT NULL, `pos` INTEGER NOT NULL, FOREIGN KEY (`listId`) REFERENCES `List<dynamic>` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`verseId`) REFERENCES `verse` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`listId`, `verseId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `hadithTopic` (`topicId` INTEGER NOT NULL, `hadithId` INTEGER NOT NULL, FOREIGN KEY (`topicId`) REFERENCES `topic` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`hadithId`) REFERENCES `hadith` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`topicId`, `hadithId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `book` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `sourceId` INTEGER NOT NULL, FOREIGN KEY (`sourceId`) REFERENCES `sourceType` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await database.execute(
            'CREATE VIEW IF NOT EXISTS `ListVerseView` AS select L.id,L.name,L.isRemovable,L.isArchive,L.sourceId,count(LV.verseId)itemCounts,ifnull(max(LH.pos),0)contentMaxPos,L.pos listPos \n  from List L left join ListVerse LV on L.id=LV.listId where L.sourceId=2  group by L.id');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `ListHadithView` AS select L.id,L.name,L.isRemovable,count(LH.hadithId)itemCounts,L.isArchive,L.sourceId,ifnull(max(LH.pos),0)contentMaxPos,L.pos listPos \n  from List L left join ListHadith LH on  L.id=LH.listId where L.sourceId=1 group by L.id');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  HadithDao get hadithDao {
    return _hadithDaoInstance ??= _$HadithDao(database, changeListener);
  }

  @override
  CuzDao get cuzDao {
    return _cuzDaoInstance ??= _$CuzDao(database, changeListener);
  }

  @override
  ListDao get listDao {
    return _listDaoInstance ??= _$ListDao(database, changeListener);
  }

  @override
  SurahDao get surahDao {
    return _surahDaoInstance ??= _$SurahDao(database, changeListener);
  }

  @override
  VerseDao get verseDao {
    return _verseDaoInstance ??= _$VerseDao(database, changeListener);
  }

  @override
  TopicDao get topicDao {
    return _topicDaoInstance ??= _$TopicDao(database, changeListener);
  }

  @override
  SectionDao get sectionDao {
    return _sectionDaoInstance ??= _$SectionDao(database, changeListener);
  }

  @override
  SavePointDao get savePointDao {
    return _savePointDaoInstance ??= _$SavePointDao(database, changeListener);
  }

  @override
  TopicSavePointDao get topicSavePointDao {
    return _topicSavePointDaoInstance ??=
        _$TopicSavePointDao(database, changeListener);
  }

  @override
  HistoryDao get historyDao {
    return _historyDaoInstance ??= _$HistoryDao(database, changeListener);
  }

  @override
  BackupMetaDao get backupMetaDao {
    return _backupMetaDaoInstance ??= _$BackupMetaDao(database, changeListener);
  }

  @override
  BackupDao get backupDao {
    return _backupDaoInstance ??= _$BackupDao(database, changeListener);
  }

  @override
  UserInfoDao get userInfoDao {
    return _userInfoDaoInstance ??= _$UserInfoDao(database, changeListener);
  }
}

class _$HadithDao extends HadithDao {
  _$HadithDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Stream<List<Hadith>> getStreamAllHadiths() {
    return _queryAdapter.queryListStream('select * from hadith',
        mapper: (Map<String, Object?> row) => Hadith(
            content: row['content'] as String,
            contentSize: row['contentSize'] as int,
            source: row['source'] as String,
            id: row['id'] as int?,
            rowNumber: row['rowNumber'] as int?,
            bookId: row['bookId'] as int),
        queryableName: 'hadith',
        isView: false);
  }

  @override
  Stream<List<Hadith>> getStreamHadithsWithListId(int listId) {
    return _queryAdapter.queryListStream(
        'select H.* from Hadith H,ListHadith LH where LH.hadithId=H.id and LH.listId=?1',
        mapper: (Map<String, Object?> row) => Hadith(
            content: row['content'] as String,
            contentSize: row['contentSize'] as int,
            source: row['source'] as String,
            id: row['id'] as int?,
            rowNumber: row['rowNumber'] as int?,
            bookId: row['bookId'] as int),
        arguments: [listId],
        queryableName: 'hadith',
        isView: false);
  }

  @override
  Stream<List<Hadith>> getStreamHadithsWithTopicId(int topicId) {
    return _queryAdapter.queryListStream(
        'select H.* from Hadith H,HadithTopic HT where HT.hadithId=H.id and HT.topicId=?1',
        mapper: (Map<String, Object?> row) => Hadith(
            content: row['content'] as String,
            contentSize: row['contentSize'] as int,
            source: row['source'] as String,
            id: row['id'] as int?,
            rowNumber: row['rowNumber'] as int?,
            bookId: row['bookId'] as int),
        arguments: [topicId],
        queryableName: 'hadith',
        isView: false);
  }

  @override
  Future<IntData?> getAllHadithCount() async {
    return _queryAdapter.query('select count(*) data from hadith',
        mapper: (Map<String, Object?> row) =>
            IntData(data: row['data'] as int));
  }

  @override
  Future<List<Hadith>> getPagingAllHadiths(int limit, int page) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,* from hadith limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page]);
  }

  @override
  Future<IntData?> getHadithBookCount(int bookId) async {
    return _queryAdapter.query(
        'select count(*) data from hadith where bookId=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [bookId]);
  }

  @override
  Future<List<Hadith>> getPagingBookHadiths(
      int limit, int page, int bookId) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,* from hadith where bookId=?3  limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, bookId]);
  }

  @override
  Future<IntData?> getListWithHadithCount(int listId) async {
    return _queryAdapter.query(
        'select count(H.id) data from Hadith H,ListHadith LH      where LH.hadithId=H.id and LH.listId=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [listId]);
  }

  @override
  Future<List<Hadith>> getPagingListHadiths(
      int limit, int page, int listId) async {
    return _queryAdapter.queryList(
        'select row_number() over(order by       LH.pos desc) rowNumber,H.* from Hadith H,ListHadith LH      where LH.hadithId=H.id and LH.listId=?3 order by       LH.pos desc limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, listId]);
  }

  @override
  Future<List<Hadith>> getListHadiths(int listId) async {
    return _queryAdapter.queryList(
        'select row_number() over(order by       LH.pos desc) rowNumber,H.* from Hadith H,ListHadith LH      where LH.hadithId=H.id and LH.listId=?1 order by       LH.pos desc',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [listId]);
  }

  @override
  Future<IntData?> getTopicWithHadithCount(int topicId) async {
    return _queryAdapter.query(
        'select count(H.id) data from Hadith H,HadithTopic HT      where HT.hadithId=H.id and HT.topicId=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [topicId]);
  }

  @override
  Future<List<Hadith>> getPagingTopicHadiths(
      int limit, int page, int topicId) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,H.* from Hadith H,HadithTopic HT      where HT.hadithId=H.id and HT.topicId=?3 limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, topicId]);
  }

  @override
  Future<IntData?> getSearchWithHadithCountWithRegEx(String regExp) async {
    return _queryAdapter.query(
        'select count(id) data from Hadith where lower(content)  REGEXP lower(?1)',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [regExp]);
  }

  @override
  Future<List<Hadith>> getPagingSearchHadithsWithRegEx(
      int limit, int page, String regExp) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,* from Hadith where lower(content)  REGEXP lower(?3)       limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, regExp]);
  }

  @override
  Future<IntData?> getSearchHadithCountWithBookAndRegEx(
      String regExp, int bookId) async {
    return _queryAdapter.query(
        'select count(id) data from Hadith where bookId=?2 and lower(content)  REGEXP lower(?1)',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [regExp, bookId]);
  }

  @override
  Future<List<Hadith>> getPagingSearchHadithsWithBookAndRegEx(
      int limit, int page, int bookId, String regExp) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,* from Hadith where bookId=?3 and       lower(content)  REGEXP lower(?4) limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, bookId, regExp]);
  }

  @override
  Future<IntData?> getSearchWithHadithCount(String query) async {
    return _queryAdapter.query(
        'select count(id) data from Hadith where lower(content) Like lower(?1)',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [query]);
  }

  @override
  Future<List<Hadith>> getPagingSearchHadiths(
      int limit, int page, String query) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,* from Hadith where lower(content) Like lower(?3)       limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, query]);
  }

  @override
  Future<IntData?> getSearchHadithCountWithBook(
      String query, int bookId) async {
    return _queryAdapter.query(
        'select count(id) data from Hadith where bookId=?2 and lower(content)  Like lower(?1)',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [query, bookId]);
  }

  @override
  Future<List<Hadith>> getPagingSearchHadithsWithBook(
      int limit, int page, int bookId, String query) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,* from Hadith where bookId=?3 and       lower(content) Like lower(?4) limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Hadith(content: row['content'] as String, contentSize: row['contentSize'] as int, source: row['source'] as String, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, bookId, query]);
  }
}

class _$CuzDao extends CuzDao {
  _$CuzDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Cuz>> getAllCuz() async {
    return _queryAdapter.queryList('select * from cuz',
        mapper: (Map<String, Object?> row) =>
            Cuz(cuzNo: row['cuzNo'] as int, name: row['name'] as String));
  }
}

class _$ListDao extends ListDao {
  _$ListDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _listEntityInsertionAdapter = InsertionAdapter(
            database,
            'list',
            (ListEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isRemovable': item.isRemovable ? 1 : 0,
                  'sourceId': item.sourceId,
                  'isArchive': item.isArchive ? 1 : 0,
                  'pos': item.pos
                },
            changeListener),
        _listHadithEntityInsertionAdapter = InsertionAdapter(
            database,
            'listHadith',
            (ListHadithEntity item) => <String, Object?>{
                  'listId': item.listId,
                  'hadithId': item.hadithId,
                  'pos': item.pos
                },
            changeListener),
        _listVerseEntityInsertionAdapter = InsertionAdapter(
            database,
            'listVerse',
            (ListVerseEntity item) => <String, Object?>{
                  'listId': item.listId,
                  'verseId': item.verseId,
                  'pos': item.pos
                },
            changeListener),
        _listEntityUpdateAdapter = UpdateAdapter(
            database,
            'list',
            ['id'],
            (ListEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isRemovable': item.isRemovable ? 1 : 0,
                  'sourceId': item.sourceId,
                  'isArchive': item.isArchive ? 1 : 0,
                  'pos': item.pos
                },
            changeListener),
        _listHadithEntityUpdateAdapter = UpdateAdapter(
            database,
            'listHadith',
            ['listId', 'hadithId'],
            (ListHadithEntity item) => <String, Object?>{
                  'listId': item.listId,
                  'hadithId': item.hadithId,
                  'pos': item.pos
                },
            changeListener),
        _listVerseEntityUpdateAdapter = UpdateAdapter(
            database,
            'listVerse',
            ['listId', 'verseId'],
            (ListVerseEntity item) => <String, Object?>{
                  'listId': item.listId,
                  'verseId': item.verseId,
                  'pos': item.pos
                },
            changeListener),
        _listEntityDeletionAdapter = DeletionAdapter(
            database,
            'list',
            ['id'],
            (ListEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isRemovable': item.isRemovable ? 1 : 0,
                  'sourceId': item.sourceId,
                  'isArchive': item.isArchive ? 1 : 0,
                  'pos': item.pos
                },
            changeListener),
        _listHadithEntityDeletionAdapter = DeletionAdapter(
            database,
            'listHadith',
            ['listId', 'hadithId'],
            (ListHadithEntity item) => <String, Object?>{
                  'listId': item.listId,
                  'hadithId': item.hadithId,
                  'pos': item.pos
                },
            changeListener),
        _listVerseEntityDeletionAdapter = DeletionAdapter(
            database,
            'listVerse',
            ['listId', 'verseId'],
            (ListVerseEntity item) => <String, Object?>{
                  'listId': item.listId,
                  'verseId': item.verseId,
                  'pos': item.pos
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ListEntity> _listEntityInsertionAdapter;

  final InsertionAdapter<ListHadithEntity> _listHadithEntityInsertionAdapter;

  final InsertionAdapter<ListVerseEntity> _listVerseEntityInsertionAdapter;

  final UpdateAdapter<ListEntity> _listEntityUpdateAdapter;

  final UpdateAdapter<ListHadithEntity> _listHadithEntityUpdateAdapter;

  final UpdateAdapter<ListVerseEntity> _listVerseEntityUpdateAdapter;

  final DeletionAdapter<ListEntity> _listEntityDeletionAdapter;

  final DeletionAdapter<ListHadithEntity> _listHadithEntityDeletionAdapter;

  final DeletionAdapter<ListVerseEntity> _listVerseEntityDeletionAdapter;

  @override
  Stream<List<ListEntity>> getStreamList(int sourceId) {
    return _queryAdapter.queryListStream(
        'select * from list where sourceId=?1 order by isRemovable asc,pos desc',
        mapper: (Map<String, Object?> row) => ListEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            isRemovable: (row['isRemovable'] as int) != 0,
            sourceId: row['sourceId'] as int,
            pos: row['pos'] as int),
        arguments: [sourceId],
        queryableName: 'list',
        isView: false);
  }

  @override
  Stream<List<ListEntity>> getStreamListWithArchive(
      int sourceId, bool isArchive) {
    return _queryAdapter.queryListStream(
        'select * from list where sourceId=?1 and isArchive=?2 order by isRemovable asc,pos desc',
        mapper: (Map<String, Object?> row) => ListEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            isRemovable: (row['isRemovable'] as int) != 0,
            sourceId: row['sourceId'] as int,
            pos: row['pos'] as int),
        arguments: [sourceId, isArchive ? 1 : 0],
        queryableName: 'list',
        isView: false);
  }

  @override
  Stream<List<ListEntity>> getStreamRemovableList(int sourceId) {
    return _queryAdapter.queryListStream(
        'select * from list where sourceId=?1 and isRemovable=1 order by pos desc',
        mapper: (Map<String, Object?> row) => ListEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            isRemovable: (row['isRemovable'] as int) != 0,
            sourceId: row['sourceId'] as int,
            pos: row['pos'] as int),
        arguments: [sourceId],
        queryableName: 'list',
        isView: false);
  }

  @override
  Stream<List<ListEntity>> getStreamRemovableListWithArchive(
      int sourceId, bool isArchive) {
    return _queryAdapter.queryListStream(
        'select * from list where sourceId=?1 and isRemovable=1 and    isArchive=?2 order by pos desc',
        mapper: (Map<String, Object?> row) => ListEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            isRemovable: (row['isRemovable'] as int) != 0,
            sourceId: row['sourceId'] as int,
            pos: row['pos'] as int),
        arguments: [sourceId, isArchive ? 1 : 0],
        queryableName: 'list',
        isView: false);
  }

  @override
  Future<List<ListHadithEntity>> getHadithListWithListId(int listId) async {
    return _queryAdapter.queryList('select * from listHadith where listId=?1',
        mapper: (Map<String, Object?> row) => ListHadithEntity(
            listId: row['listId'] as int,
            hadithId: row['hadithId'] as int,
            pos: row['pos'] as int),
        arguments: [listId]);
  }

  @override
  Future<List<ListHadithEntity>> getHadithListWithHadithId(int hadithId) async {
    return _queryAdapter.queryList('select * from listHadith where hadithId=?1',
        mapper: (Map<String, Object?> row) => ListHadithEntity(
            listId: row['listId'] as int,
            hadithId: row['hadithId'] as int,
            pos: row['pos'] as int),
        arguments: [hadithId]);
  }

  @override
  Future<List<ListHadithEntity>> getHadithListWithHadithIdArchive(
      int hadithId, bool isArchive) async {
    return _queryAdapter.queryList(
        'select * from listHadith where hadithId=?1 and isArchive=?2',
        mapper: (Map<String, Object?> row) => ListHadithEntity(
            listId: row['listId'] as int,
            hadithId: row['hadithId'] as int,
            pos: row['pos'] as int),
        arguments: [hadithId, isArchive ? 1 : 0]);
  }

  @override
  Future<List<ListHadithEntity>> getHadithListWithRemovable(
      int hadithId, bool isRemovable) async {
    return _queryAdapter.queryList(
        'select LH.* from listHadith LH,List L where      LH.listId=L.id and LH.hadithId=?1 and L.isRemovable=?2',
        mapper: (Map<String, Object?> row) => ListHadithEntity(listId: row['listId'] as int, hadithId: row['hadithId'] as int, pos: row['pos'] as int),
        arguments: [hadithId, isRemovable ? 1 : 0]);
  }

  @override
  Future<List<ListHadithEntity>> getHadithListWithRemovableArchive(
      int hadithId, bool isRemovable, bool isArchive) async {
    return _queryAdapter.queryList(
        'select LH.* from listHadith LH,List L where isArchive=?3 and     LH.listId=L.id and LH.hadithId=?1 and L.isRemovable=?2',
        mapper: (Map<String, Object?> row) => ListHadithEntity(listId: row['listId'] as int, hadithId: row['hadithId'] as int, pos: row['pos'] as int),
        arguments: [hadithId, isRemovable ? 1 : 0, isArchive ? 1 : 0]);
  }

  @override
  Future<List<ListVerseEntity>> getVerseListWithListId(int listId) async {
    return _queryAdapter.queryList('select * from listVerse where listId=?1',
        mapper: (Map<String, Object?> row) => ListVerseEntity(
            listId: row['listId'] as int,
            verseId: row['verseId'] as int,
            pos: row['pos'] as int),
        arguments: [listId]);
  }

  @override
  Future<List<ListVerseEntity>> getVerseListWithVerseId(int verseId) async {
    return _queryAdapter.queryList('select * from listVerse where verseId=?1',
        mapper: (Map<String, Object?> row) => ListVerseEntity(
            listId: row['listId'] as int,
            verseId: row['verseId'] as int,
            pos: row['pos'] as int),
        arguments: [verseId]);
  }

  @override
  Future<List<ListVerseEntity>> getVerseListWithVerseIdArchive(
      int verseId, bool isArchive) async {
    return _queryAdapter.queryList(
        'select * from listVerse where verseId=?1 and isArchive=?2',
        mapper: (Map<String, Object?> row) => ListVerseEntity(
            listId: row['listId'] as int,
            verseId: row['verseId'] as int,
            pos: row['pos'] as int),
        arguments: [verseId, isArchive ? 1 : 0]);
  }

  @override
  Future<List<ListVerseEntity>> getVerseListWithRemovable(
      int verseId, bool isRemovable) async {
    return _queryAdapter.queryList(
        'select LV.* from listVerse LV,List L where     LV.listId=L.id and LV.verseId=?1 and L.isRemovable=?2',
        mapper: (Map<String, Object?> row) => ListVerseEntity(listId: row['listId'] as int, verseId: row['verseId'] as int, pos: row['pos'] as int),
        arguments: [verseId, isRemovable ? 1 : 0]);
  }

  @override
  Future<List<ListVerseEntity>> getVerseListWithRemovableArchive(
      int verseId, bool isRemovable, bool isArchive) async {
    return _queryAdapter.queryList(
        'select LV.* from listVerse LV,List L where isArchive=?3 and     LV.listId=L.id and LV.verseId=?1 and L.isRemovable=?2',
        mapper: (Map<String, Object?> row) => ListVerseEntity(listId: row['listId'] as int, verseId: row['verseId'] as int, pos: row['pos'] as int),
        arguments: [verseId, isRemovable ? 1 : 0, isArchive ? 1 : 0]);
  }

  @override
  Future<IntData?> getContentMaxPosFromListHadith(int listId) async {
    return _queryAdapter.query(
        'select contentMaxPos data from listHadithView where id=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [listId]);
  }

  @override
  Future<IntData?> getContentMaxPosFromListVerse(int listId) async {
    return _queryAdapter.query(
        'select contentMaxPos data from listVerseView where id=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [listId]);
  }

  @override
  Future<IntData?> getMaxPosListWithSourceId(int sourceId) async {
    return _queryAdapter.query(
        'select max(pos) data from list where sourceId=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [sourceId]);
  }

  @override
  Future<IntData?> getMaxPosList() async {
    return _queryAdapter.query('select max(pos) data from list',
        mapper: (Map<String, Object?> row) =>
            IntData(data: row['data'] as int));
  }

  @override
  Stream<List<ListHadithView>> getListHadithViews(bool isArchive) {
    return _queryAdapter.queryListStream(
        'select * from listHadithView where isArchive=?1 order by isRemovable asc,listPos desc',
        mapper: (Map<String, Object?> row) => ListHadithView(
            id: row['id'] as int,
            contentMaxPos: row['contentMaxPos'] as int,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            sourceId: row['sourceId'] as int,
            itemCounts: row['itemCounts'] as int,
            isRemovable: (row['isRemovable'] as int) != 0,
            listPos: row['listPos'] as int),
        arguments: [isArchive ? 1 : 0],
        queryableName: 'ListHadithView',
        isView: true);
  }

  @override
  Stream<List<ListHadithView>> getSearchResultHadithViews(
      String name, String or1, String or2, String or3, bool isArchive) {
    return _queryAdapter.queryListStream(
        'select * from listHadithView where isArchive=?5 and      name like ?1 order by       (case when name=?2 then 1 when name like ?3 then 2 when name like ?4       then 3 else 4 end ),listPos desc',
        mapper: (Map<String, Object?> row) => ListHadithView(
            id: row['id'] as int,
            contentMaxPos: row['contentMaxPos'] as int,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            sourceId: row['sourceId'] as int,
            itemCounts: row['itemCounts'] as int,
            isRemovable: (row['isRemovable'] as int) != 0,
            listPos: row['listPos'] as int),
        arguments: [name, or1, or2, or3, isArchive ? 1 : 0],
        queryableName: 'ListHadithView',
        isView: true);
  }

  @override
  Stream<List<ListHadithView>> getAllArchivedListViews() {
    return _queryAdapter.queryListStream(
        'select * from listHadithView  where isArchive=1 union        select * from listVerseView where isArchive=1 order by isRemovable asc,listPos desc',
        mapper: (Map<String, Object?> row) => ListHadithView(
            id: row['id'] as int,
            contentMaxPos: row['contentMaxPos'] as int,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            sourceId: row['sourceId'] as int,
            itemCounts: row['itemCounts'] as int,
            isRemovable: (row['isRemovable'] as int) != 0,
            listPos: row['listPos'] as int),
        queryableName: 'ListHadithView',
        isView: true);
  }

  @override
  Stream<List<ListVerseView>> getListVerseViews(bool isArchive) {
    return _queryAdapter.queryListStream(
        'select * from listVerseView where isArchive=?1 order by isRemovable asc,listPos desc',
        mapper: (Map<String, Object?> row) => ListVerseView(
            id: row['id'] as int,
            contentMaxPos: row['contentMaxPos'] as int,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            sourceId: row['sourceId'] as int,
            itemCounts: row['itemCounts'] as int,
            isRemovable: (row['isRemovable'] as int) != 0,
            listPos: row['listPos'] as int),
        arguments: [isArchive ? 1 : 0],
        queryableName: 'ListVerseView',
        isView: true);
  }

  @override
  Stream<List<ListVerseView>> getSearchResultVerseViews(
      String name, String or1, String or2, String or3, bool isArchive) {
    return _queryAdapter.queryListStream(
        'select * from listVerseView where isArchive=?5 and      name like ?1 order by       (case when name=?2 then 1 when name like ?3 then 2 when name like ?4       then 3 else 4 end )',
        mapper: (Map<String, Object?> row) => ListVerseView(
            id: row['id'] as int,
            contentMaxPos: row['contentMaxPos'] as int,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            sourceId: row['sourceId'] as int,
            itemCounts: row['itemCounts'] as int,
            isRemovable: (row['isRemovable'] as int) != 0,
            listPos: row['listPos'] as int),
        arguments: [name, or1, or2, or3, isArchive ? 1 : 0],
        queryableName: 'ListVerseView',
        isView: true);
  }

  @override
  Future<void> deleteListHadithWithQuery(int listId) async {
    await _queryAdapter.queryNoReturn('delete from listHadith where listId=?1',
        arguments: [listId]);
  }

  @override
  Future<void> deleteListVerseWithQuery(int listId) async {
    await _queryAdapter.queryNoReturn('delete from listVerse where listId=?1',
        arguments: [listId]);
  }

  @override
  Future<int> insertList(ListEntity listEntity) {
    return _listEntityInsertionAdapter.insertAndReturnId(
        listEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> insertHadithList(ListHadithEntity listHadithEntity) {
    return _listHadithEntityInsertionAdapter.insertAndReturnId(
        listHadithEntity, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertHadithLists(
      List<ListHadithEntity> listHadithEntities) {
    return _listHadithEntityInsertionAdapter.insertListAndReturnIds(
        listHadithEntities, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertVerseList(ListVerseEntity listVerseEntity) {
    return _listVerseEntityInsertionAdapter.insertAndReturnId(
        listVerseEntity, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertVerseLists(List<ListVerseEntity> listVerseEntities) {
    return _listVerseEntityInsertionAdapter.insertListAndReturnIds(
        listVerseEntities, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateList(ListEntity listEntity) {
    return _listEntityUpdateAdapter.updateAndReturnChangedRows(
        listEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateHadithList(ListHadithEntity listHadithEntity) {
    return _listHadithEntityUpdateAdapter.updateAndReturnChangedRows(
        listHadithEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateVerseList(ListVerseEntity listVerseEntity) {
    return _listVerseEntityUpdateAdapter.updateAndReturnChangedRows(
        listVerseEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteList(ListEntity listEntity) {
    return _listEntityDeletionAdapter.deleteAndReturnChangedRows(listEntity);
  }

  @override
  Future<int> deleteHadithList(ListHadithEntity listHadithEntity) {
    return _listHadithEntityDeletionAdapter
        .deleteAndReturnChangedRows(listHadithEntity);
  }

  @override
  Future<int> deleteHadithLists(List<ListHadithEntity> listHadithEntities) {
    return _listHadithEntityDeletionAdapter
        .deleteListAndReturnChangedRows(listHadithEntities);
  }

  @override
  Future<int> deleteVerseList(ListVerseEntity listVerseEntity) {
    return _listVerseEntityDeletionAdapter
        .deleteAndReturnChangedRows(listVerseEntity);
  }

  @override
  Future<int> deleteVerseLists(List<ListVerseEntity> listVerseEntities) {
    return _listVerseEntityDeletionAdapter
        .deleteListAndReturnChangedRows(listVerseEntities);
  }
}

class _$SurahDao extends SurahDao {
  _$SurahDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Surah>> getAllSurah() async {
    return _queryAdapter.queryList('select * from surah',
        mapper: (Map<String, Object?> row) =>
            Surah(id: row['id'] as int, name: row['name'] as String));
  }

  @override
  Future<List<Surah>> getSearchedSurahs(
      String query, String or1, String or2, String or3) async {
    return _queryAdapter.queryList(
        'with SurahText as(select id || name as text,id from surah)     select S.* from surah S,SurahText ST where ST.id=S.id and ST.text like ?1      order by (case when ST.text=?2 then 1 when ST.text like ?3 then 2 when ST.text like ?4       then 3 else 4 end)',
        mapper: (Map<String, Object?> row) => Surah(id: row['id'] as int, name: row['name'] as String),
        arguments: [query, or1, or2, or3]);
  }
}

class _$VerseDao extends VerseDao {
  _$VerseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Verse>> getVersesWithSurahId(int surahId) async {
    return _queryAdapter.queryList('select * from verse where surahId=?1',
        mapper: (Map<String, Object?> row) => Verse(
            surahId: row['surahId'] as int,
            cuzNo: row['cuzNo'] as int,
            pageNo: row['pageNo'] as int,
            verseNumber: row['verseNumber'] as String,
            content: row['content'] as String,
            pageRank: row['pageRank'] as int?,
            surahName: row['surahName'] as String?,
            isProstrationVerse: (row['isProstrationVerse'] as int) != 0,
            id: row['id'] as int?,
            rowNumber: row['rowNumber'] as int?,
            bookId: row['bookId'] as int),
        arguments: [surahId]);
  }

  @override
  Future<List<Verse>> getVersesWithCuzNo(int cuzNo) async {
    return _queryAdapter.queryList('select * from verse where cuzNo=?1',
        mapper: (Map<String, Object?> row) => Verse(
            surahId: row['surahId'] as int,
            cuzNo: row['cuzNo'] as int,
            pageNo: row['pageNo'] as int,
            verseNumber: row['verseNumber'] as String,
            content: row['content'] as String,
            pageRank: row['pageRank'] as int?,
            surahName: row['surahName'] as String?,
            isProstrationVerse: (row['isProstrationVerse'] as int) != 0,
            id: row['id'] as int?,
            rowNumber: row['rowNumber'] as int?,
            bookId: row['bookId'] as int),
        arguments: [cuzNo]);
  }

  @override
  Future<List<Verse>> getPagingVerses(int limit, int page) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by pageNo)pageRank,       row_number() over() rowNumber,       V.*,S.name surahName from verse V,Surah S        where V.surahId=S.id limit ?1 offset ?1*((?2)-1)',
        mapper: (Map<String, Object?> row) => Verse(surahId: row['surahId'] as int, cuzNo: row['cuzNo'] as int, pageNo: row['pageNo'] as int, verseNumber: row['verseNumber'] as String, content: row['content'] as String, pageRank: row['pageRank'] as int?, surahName: row['surahName'] as String?, isProstrationVerse: (row['isProstrationVerse'] as int) != 0, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page]);
  }

  @override
  Future<IntData?> getPagingCount() async {
    return _queryAdapter.query('select count(*) data from verse',
        mapper: (Map<String, Object?> row) =>
            IntData(data: row['data'] as int));
  }

  @override
  Future<List<Verse>> getPagingTopicVerses(
      int limit, int page, int topicId) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by pageNo)pageRank,       row_number() over() rowNumber,       V.*,S.name surahName from verse V,Surah S,VerseTopic VT        where V.surahId=S.id and VT.verseId=V.id and VT.topicId=?3        limit ?1 offset ?1*((?2)-1)',
        mapper: (Map<String, Object?> row) => Verse(surahId: row['surahId'] as int, cuzNo: row['cuzNo'] as int, pageNo: row['pageNo'] as int, verseNumber: row['verseNumber'] as String, content: row['content'] as String, pageRank: row['pageRank'] as int?, surahName: row['surahName'] as String?, isProstrationVerse: (row['isProstrationVerse'] as int) != 0, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, topicId]);
  }

  @override
  Future<IntData?> getPagingTopicVersesCount(int topicId) async {
    return _queryAdapter.query(
        'select count(*) data from verse V,VerseTopic VT where VT.verseId=V.id and VT.topicId=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [topicId]);
  }

  @override
  Future<List<Verse>> getPagingSurahVerses(
      int limit, int page, int surahId) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by pageNo)pageRank,       row_number() over() rowNumber,       V.*,S.name surahName from verse V,Surah S        where V.surahId=S.id and S.id=?3 limit ?1 offset ?1*((?2)-1)',
        mapper: (Map<String, Object?> row) => Verse(surahId: row['surahId'] as int, cuzNo: row['cuzNo'] as int, pageNo: row['pageNo'] as int, verseNumber: row['verseNumber'] as String, content: row['content'] as String, pageRank: row['pageRank'] as int?, surahName: row['surahName'] as String?, isProstrationVerse: (row['isProstrationVerse'] as int) != 0, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, surahId]);
  }

  @override
  Future<IntData?> getPagingSurahVersesCount(int surahId) async {
    return _queryAdapter.query(
        'select count(*) data from verse V,Surah S where V.surahId=S.id and V.surahId=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [surahId]);
  }

  @override
  Future<List<Verse>> getPagingCuzVerses(int limit, int page, int cuzNo) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by pageNo)pageRank,       row_number() over() rowNumber,       V.*,S.name surahName from verse V,Surah S,Cuz C        where V.surahId=S.id and C.cuzNo=V.cuzNo and V.cuzNo=?3 limit ?1 offset ?1*((?2)-1)',
        mapper: (Map<String, Object?> row) => Verse(surahId: row['surahId'] as int, cuzNo: row['cuzNo'] as int, pageNo: row['pageNo'] as int, verseNumber: row['verseNumber'] as String, content: row['content'] as String, pageRank: row['pageRank'] as int?, surahName: row['surahName'] as String?, isProstrationVerse: (row['isProstrationVerse'] as int) != 0, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, cuzNo]);
  }

  @override
  Future<IntData?> getPagingCuzVersesCount(int cuzNo) async {
    return _queryAdapter.query(
        'select count(*) data from verse V,Cuz C where C.cuzNo=V.cuzNo and V.cuzNo=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [cuzNo]);
  }

  @override
  Future<List<Verse>> getPagingListVerses(
      int limit, int page, int listId) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by pageNo)pageRank,       row_number() over(order by LV.pos desc) rowNumber,       V.*,S.name surahName from verse V,Surah S,ListVerse LV       where V.surahId=S.id and LV.verseId=V.id and LV.listId=?3 order by LV.pos desc limit ?1 offset ?1*((?2)-1)',
        mapper: (Map<String, Object?> row) => Verse(surahId: row['surahId'] as int, cuzNo: row['cuzNo'] as int, pageNo: row['pageNo'] as int, verseNumber: row['verseNumber'] as String, content: row['content'] as String, pageRank: row['pageRank'] as int?, surahName: row['surahName'] as String?, isProstrationVerse: (row['isProstrationVerse'] as int) != 0, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, listId]);
  }

  @override
  Future<IntData?> getPagingListVersesCount(int listId) async {
    return _queryAdapter.query(
        'select count(*) data from verse V,ListVerse LV where LV.verseId=V.id and LV.listId=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [listId]);
  }

  @override
  Future<List<Verse>> getListVerses(int listId) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by pageNo)pageRank,       row_number() over(order by LV.pos desc) rowNumber,       V.*,S.name surahName from verse V,Surah S,ListVerse LV       where V.surahId=S.id and LV.verseId=V.id and LV.listId=?1 order by LV.pos desc',
        mapper: (Map<String, Object?> row) => Verse(surahId: row['surahId'] as int, cuzNo: row['cuzNo'] as int, pageNo: row['pageNo'] as int, verseNumber: row['verseNumber'] as String, content: row['content'] as String, pageRank: row['pageRank'] as int?, surahName: row['surahName'] as String?, isProstrationVerse: (row['isProstrationVerse'] as int) != 0, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [listId]);
  }

  @override
  Future<IntData?> getSearchWithVerseCountWithRegEx(String regExp) async {
    return _queryAdapter.query(
        'select count(id) data from verse V where lower(content)  REGEXP lower(?1)',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [regExp]);
  }

  @override
  Future<List<Verse>> getPagingSearchVersesWithRegEx(
      int limit, int page, String regExp) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by pageNo)pageRank,       row_number() over() rowNumber,       V.*,S.name surahName from verse V,Surah S       where V.surahId=S.id and  lower(content)  REGEXP lower(?3)       limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Verse(surahId: row['surahId'] as int, cuzNo: row['cuzNo'] as int, pageNo: row['pageNo'] as int, verseNumber: row['verseNumber'] as String, content: row['content'] as String, pageRank: row['pageRank'] as int?, surahName: row['surahName'] as String?, isProstrationVerse: (row['isProstrationVerse'] as int) != 0, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, regExp]);
  }

  @override
  Future<IntData?> getSearchWithVerseCount(String query) async {
    return _queryAdapter.query(
        'select count(id) data from verse V where lower(content) Like lower(?1)',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [query]);
  }

  @override
  Future<List<Verse>> getPagingSearchVerses(
      int limit, int page, String query) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by pageNo)pageRank,       row_number() over() rowNumber,       V.*,S.name surahName from verse V,Surah S       where V.surahId=S.id and  lower(content)  Like lower(?3)       limit ?1 offset ?1 * ((?2) -1)',
        mapper: (Map<String, Object?> row) => Verse(surahId: row['surahId'] as int, cuzNo: row['cuzNo'] as int, pageNo: row['pageNo'] as int, verseNumber: row['verseNumber'] as String, content: row['content'] as String, pageRank: row['pageRank'] as int?, surahName: row['surahName'] as String?, isProstrationVerse: (row['isProstrationVerse'] as int) != 0, id: row['id'] as int?, rowNumber: row['rowNumber'] as int?, bookId: row['bookId'] as int),
        arguments: [limit, page, query]);
  }
}

class _$TopicDao extends TopicDao {
  _$TopicDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Topic>> getHadithTopics(int hadithId) async {
    return _queryAdapter.queryList(
        'select T.* from topic T,HadithTopic HT      where T.id=HT.topicId and HT.hadithId=?1',
        mapper: (Map<String, Object?> row) => Topic(id: row['id'] as int?, name: row['name'] as String, sectionId: row['sectionId'] as int),
        arguments: [hadithId]);
  }

  @override
  Future<List<Topic>> getTopicsWithSectionId(int sectionId) async {
    return _queryAdapter.queryList('select * from topic where sectionId=?1',
        mapper: (Map<String, Object?> row) => Topic(
            id: row['id'] as int?,
            name: row['name'] as String,
            sectionId: row['sectionId'] as int),
        arguments: [sectionId]);
  }

  @override
  Future<List<ItemCountModel>> getHadithTopicWithSectionId(
      int sectionId) async {
    return _queryAdapter.queryList(
        'select row_number() over(partition by T.sectionId) rowNumber,     T.id,T.name,count(HT.hadithId)itemCount from      topic T,HadithTopic HT where T.id=HT.topicId and T.sectionId=?1 group by T.id',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [sectionId]);
  }

  @override
  Future<List<ItemCountModel>> getSearchHadithTopicWithSectionId(
      int sectionId, String query, String or1, String or2, String or3) async {
    return _queryAdapter.queryList(
        'select T.id,T.name,count(HT.hadithId)itemCount from      topic T,HadithTopic HT where T.id=HT.topicId and T.sectionId=?1 and T.name like ?2      group by T.id order by (case when T.name=?3 then 1 when T.name like ?4 then 2 when T.name like ?5       then 3 else 4 end )',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [sectionId, query, or1, or2, or3]);
  }

  @override
  Future<List<ItemCountModel>> getHadithTopicWithBookId(int bookId) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,T.id,T.name,count(HT.hadithId)itemCount from      topic T,HadithTopic HT,section S where T.id=HT.topicId and S.id=T.sectionId      and S.bookId=?1 group by T.id',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [bookId]);
  }

  @override
  Future<List<ItemCountModel>> getSearchHadithTopicWithBookId(
      int bookId, String query, String or1, String or2, String or3) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,T.id,T.name,count(HT.hadithId)itemCount from      topic T,HadithTopic HT,Section S where T.id=HT.topicId and S.id=T.sectionId and S.bookId=?1 and T.name like ?2      group by T.id order by (case when T.name=?3 then 1 when T.name like ?4 then 2 when T.name like ?5       then 3 else 4 end )',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [bookId, query, or1, or2, or3]);
  }

  @override
  Future<List<ItemCountModel>> getVerseTopicWithSectionId(int sectionId) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,T.id,T.name,count(VT.verseId)itemCount from     topic T,VerseTopic VT where T.id=VT.topicId and T.sectionId=?1 group by T.id',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [sectionId]);
  }

  @override
  Future<List<ItemCountModel>> getSearchVerseTopicWithSectionId(
      int sectionId, String query, String or1, String or2, String or3) async {
    return _queryAdapter.queryList(
        'select T.id,T.name,count(VT.verseId)itemCount from     topic T,VerseTopic VT where T.id=VT.topicId and T.sectionId=?1 and T.name like ?2      group by T.id order by (case when T.name=?3 then 1 when T.name like ?4 then 2 when T.name like ?5       then 3 else 4 end )',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [sectionId, query, or1, or2, or3]);
  }

  @override
  Future<List<ItemCountModel>> getVerseTopicWithBookId(int bookId) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,T.id,T.name,count(VT.verseId)itemCount from     topic T,VerseTopic VT,Section S where T.id=VT.topicId and      S.id=T.sectionId and S.bookId=?1 group by T.id',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [bookId]);
  }

  @override
  Future<List<ItemCountModel>> getSearchVerseTopicWithBookId(
      int bookId, String query, String or1, String or2, String or3) async {
    return _queryAdapter.queryList(
        'select T.id,T.name,count(VT.verseId)itemCount from     topic T,VerseTopic VT,Section S where T.id=VT.topicId and S.id=T.sectionId and S.bookId=?1     and T.name like ?2      group by T.id order by (case when T.name=?3 then 1 when T.name like ?4 then 2 when T.name like ?5     then 3 else 4 end )',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [bookId, query, or1, or2, or3]);
  }

  @override
  Future<List<ItemCountModel>> getSectionWithBookId(int bookId) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,S.id,S.name,count(T.id)itemCount from section S,Topic T        where S.id=T.sectionId and S.bookId=?1 group by S.id',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [bookId]);
  }

  @override
  Future<IntData?> getTopicCountsWithBookId(int bookId) async {
    return _queryAdapter.query(
        'select count(T.id) data from topic T,Section S where T.sectionId=S.id and S.bookId=?1',
        mapper: (Map<String, Object?> row) => IntData(data: row['data'] as int),
        arguments: [bookId]);
  }

  @override
  Future<List<ItemCountModel>> getSearchSectionWithBookId(
      int bookId, String query, String or1, String or2, String or3) async {
    return _queryAdapter.queryList(
        'select row_number() over() rowNumber,S.id,S.name,count(T.id)itemCount from section S,Topic T        where S.id=T.sectionId and S.bookId=?1 and S.name like ?2 group by S.id        order by (case when S.name=?3 then 1 when S.name like ?4 then 2 when S.name like ?5       then 3 else 4 end )',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [bookId, query, or1, or2, or3]);
  }
}

class _$SectionDao extends SectionDao {
  _$SectionDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Section>> getSectionsWithBookId(int bookId) async {
    return _queryAdapter.queryList(
        'select select row_number() over() rowNumber,* from section where bookId=?1',
        mapper: (Map<String, Object?> row) => Section(id: row['id'] as int?, name: row['name'] as String, bookId: row['bookId'] as int),
        arguments: [bookId]);
  }

  @override
  Future<List<ItemCountModel>> getSectionCountWithBookId(int bookId) async {
    return _queryAdapter.queryList(
        'select S.id,S.name,count(T.id)itemCount from     section S, Topic T where S.id=T.sectionId and S.bookId=?1 group by S.id',
        mapper: (Map<String, Object?> row) => ItemCountModel(id: row['id'] as int, name: row['name'] as String, itemCount: row['itemCount'] as int, rowNumber: row['rowNumber'] as int?),
        arguments: [bookId]);
  }
}

class _$SavePointDao extends SavePointDao {
  _$SavePointDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _savePointInsertionAdapter = InsertionAdapter(
            database,
            'savePoint',
            (SavePoint item) => <String, Object?>{
                  'id': item.id,
                  'itemIndexPos': item.itemIndexPos,
                  'title': item.title,
                  'isAuto': item.isAuto ? 1 : 0,
                  'modifiedDate': item.modifiedDate,
                  'savePointType':
                      _originTagConverter.encode(item.savePointType),
                  'bookIdBinary': item.bookIdBinary,
                  'parentName': item.parentName,
                  'parentKey': item.parentKey
                },
            changeListener),
        _savePointUpdateAdapter = UpdateAdapter(
            database,
            'savePoint',
            ['id'],
            (SavePoint item) => <String, Object?>{
                  'id': item.id,
                  'itemIndexPos': item.itemIndexPos,
                  'title': item.title,
                  'isAuto': item.isAuto ? 1 : 0,
                  'modifiedDate': item.modifiedDate,
                  'savePointType':
                      _originTagConverter.encode(item.savePointType),
                  'bookIdBinary': item.bookIdBinary,
                  'parentName': item.parentName,
                  'parentKey': item.parentKey
                },
            changeListener),
        _savePointDeletionAdapter = DeletionAdapter(
            database,
            'savePoint',
            ['id'],
            (SavePoint item) => <String, Object?>{
                  'id': item.id,
                  'itemIndexPos': item.itemIndexPos,
                  'title': item.title,
                  'isAuto': item.isAuto ? 1 : 0,
                  'modifiedDate': item.modifiedDate,
                  'savePointType':
                      _originTagConverter.encode(item.savePointType),
                  'bookIdBinary': item.bookIdBinary,
                  'parentName': item.parentName,
                  'parentKey': item.parentKey
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SavePoint> _savePointInsertionAdapter;

  final UpdateAdapter<SavePoint> _savePointUpdateAdapter;

  final DeletionAdapter<SavePoint> _savePointDeletionAdapter;

  @override
  Future<SavePoint?> getAutoSavePoint(
      int savePointType, String parentKey) async {
    return _queryAdapter.query(
        'select * from `savepoint` where savePointType=?1    and parentKey=?2 and isAuto=1 order by modifiedDate desc limit 1',
        mapper: (Map<String, Object?> row) => SavePoint(id: row['id'] as int?, itemIndexPos: row['itemIndexPos'] as int, title: row['title'] as String, isAuto: (row['isAuto'] as int) != 0, modifiedDate: row['modifiedDate'] as String?, savePointType: _originTagConverter.decode(row['savePointType'] as int), bookIdBinary: row['bookIdBinary'] as int, parentKey: row['parentKey'] as String, parentName: row['parentName'] as String),
        arguments: [savePointType, parentKey]);
  }

  @override
  Future<SavePoint?> getSavePoint(int savePointType, String parentKey) async {
    return _queryAdapter.query(
        'select * from `savepoint` where savePointType=?1    and parentKey=?2 and isAuto=0 order by modifiedDate desc limit 1',
        mapper: (Map<String, Object?> row) => SavePoint(id: row['id'] as int?, itemIndexPos: row['itemIndexPos'] as int, title: row['title'] as String, isAuto: (row['isAuto'] as int) != 0, modifiedDate: row['modifiedDate'] as String?, savePointType: _originTagConverter.decode(row['savePointType'] as int), bookIdBinary: row['bookIdBinary'] as int, parentKey: row['parentKey'] as String, parentName: row['parentName'] as String),
        arguments: [savePointType, parentKey]);
  }

  @override
  Future<SavePoint?> getSavePointWithId(int id) async {
    return _queryAdapter.query('select * from `savepoint` where id=?1',
        mapper: (Map<String, Object?> row) => SavePoint(
            id: row['id'] as int?,
            itemIndexPos: row['itemIndexPos'] as int,
            title: row['title'] as String,
            isAuto: (row['isAuto'] as int) != 0,
            modifiedDate: row['modifiedDate'] as String?,
            savePointType:
                _originTagConverter.decode(row['savePointType'] as int),
            bookIdBinary: row['bookIdBinary'] as int,
            parentKey: row['parentKey'] as String,
            parentName: row['parentName'] as String),
        arguments: [id]);
  }

  @override
  Stream<List<SavePoint>> getStreamSavePoints(
      int savePointType, String parentKey) {
    return _queryAdapter.queryListStream(
        'select * from `savepoint` where    savePointType=?1 and parentKey=?2    order by modifiedDate desc',
        mapper: (Map<String, Object?> row) => SavePoint(
            id: row['id'] as int?,
            itemIndexPos: row['itemIndexPos'] as int,
            title: row['title'] as String,
            isAuto: (row['isAuto'] as int) != 0,
            modifiedDate: row['modifiedDate'] as String?,
            savePointType:
                _originTagConverter.decode(row['savePointType'] as int),
            bookIdBinary: row['bookIdBinary'] as int,
            parentKey: row['parentKey'] as String,
            parentName: row['parentName'] as String),
        arguments: [savePointType, parentKey],
        queryableName: 'savePoint',
        isView: false);
  }

  @override
  Stream<List<SavePoint>> getStreamSavePointsWithBookIdBinary(
      int savePointType, int bookIdBinary) {
    return _queryAdapter.queryListStream(
        'select * from `savepoint` where    savePointType=?1 and bookIdBinary=?2    order by modifiedDate desc',
        mapper: (Map<String, Object?> row) => SavePoint(
            id: row['id'] as int?,
            itemIndexPos: row['itemIndexPos'] as int,
            title: row['title'] as String,
            isAuto: (row['isAuto'] as int) != 0,
            modifiedDate: row['modifiedDate'] as String?,
            savePointType:
                _originTagConverter.decode(row['savePointType'] as int),
            bookIdBinary: row['bookIdBinary'] as int,
            parentKey: row['parentKey'] as String,
            parentName: row['parentName'] as String),
        arguments: [savePointType, bookIdBinary],
        queryableName: 'savePoint',
        isView: false);
  }

  @override
  Future<SavePoint?> getAutoSavePointWithBookIdBinary(
      int savePointType, int bookIdBinary) async {
    return _queryAdapter.query(
        'select * from `savepoint` where savePointType=?1    and bookIdBinary=?2 and isAuto=1 order by modifiedDate desc limit 1',
        mapper: (Map<String, Object?> row) => SavePoint(id: row['id'] as int?, itemIndexPos: row['itemIndexPos'] as int, title: row['title'] as String, isAuto: (row['isAuto'] as int) != 0, modifiedDate: row['modifiedDate'] as String?, savePointType: _originTagConverter.decode(row['savePointType'] as int), bookIdBinary: row['bookIdBinary'] as int, parentKey: row['parentKey'] as String, parentName: row['parentName'] as String),
        arguments: [savePointType, bookIdBinary]);
  }

  @override
  Stream<List<SavePoint>> getStreamSavePointsWithBook(List<int> bookBinaryIds) {
    const offset = 1;
    final _sqliteVariablesForBookBinaryIds =
        Iterable<String>.generate(bookBinaryIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryListStream(
        'select * from `savepoint` where bookIdBinary in(' +
            _sqliteVariablesForBookBinaryIds +
            ')    order by modifiedDate desc',
        mapper: (Map<String, Object?> row) => SavePoint(
            id: row['id'] as int?,
            itemIndexPos: row['itemIndexPos'] as int,
            title: row['title'] as String,
            isAuto: (row['isAuto'] as int) != 0,
            modifiedDate: row['modifiedDate'] as String?,
            savePointType:
                _originTagConverter.decode(row['savePointType'] as int),
            bookIdBinary: row['bookIdBinary'] as int,
            parentKey: row['parentKey'] as String,
            parentName: row['parentName'] as String),
        arguments: [...bookBinaryIds],
        queryableName: 'savePoint',
        isView: false);
  }

  @override
  Stream<List<SavePoint>> getStreamSavePointsWithBookFilter(
      List<int> bookBinaryIds, int savePointType) {
    const offset = 2;
    final _sqliteVariablesForBookBinaryIds =
        Iterable<String>.generate(bookBinaryIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryListStream(
        'select * from `savepoint` where bookIdBinary in(' +
            _sqliteVariablesForBookBinaryIds +
            ')      and savePointType=?1 order by modifiedDate desc',
        mapper: (Map<String, Object?> row) => SavePoint(
            id: row['id'] as int?,
            itemIndexPos: row['itemIndexPos'] as int,
            title: row['title'] as String,
            isAuto: (row['isAuto'] as int) != 0,
            modifiedDate: row['modifiedDate'] as String?,
            savePointType:
                _originTagConverter.decode(row['savePointType'] as int),
            bookIdBinary: row['bookIdBinary'] as int,
            parentKey: row['parentKey'] as String,
            parentName: row['parentName'] as String),
        arguments: [savePointType, ...bookBinaryIds],
        queryableName: 'savePoint',
        isView: false);
  }

  @override
  Future<void> deleteSavePointWithQuery(
      int savePointType, String parentKey) async {
    await _queryAdapter.queryNoReturn(
        'delete from `savepoint` where savePointType=?1 and parentKey=?2',
        arguments: [savePointType, parentKey]);
  }

  @override
  Future<int> insertSavePoint(SavePoint savePoint) {
    return _savePointInsertionAdapter.insertAndReturnId(
        savePoint, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateSavePoint(SavePoint savePoint) {
    return _savePointUpdateAdapter.updateAndReturnChangedRows(
        savePoint, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteSavePoint(SavePoint savePoint) {
    return _savePointDeletionAdapter.deleteAndReturnChangedRows(savePoint);
  }
}

class _$TopicSavePointDao extends TopicSavePointDao {
  _$TopicSavePointDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _topicSavePointEntityInsertionAdapter = InsertionAdapter(
            database,
            'topicSavePoint',
            (TopicSavePointEntity item) => <String, Object?>{
                  'id': item.id,
                  'pos': item.pos,
                  'type': _topicSavePointConverter.encode(item.type),
                  'parentKey': item.parentKey
                },
            changeListener),
        _topicSavePointEntityUpdateAdapter = UpdateAdapter(
            database,
            'topicSavePoint',
            ['id'],
            (TopicSavePointEntity item) => <String, Object?>{
                  'id': item.id,
                  'pos': item.pos,
                  'type': _topicSavePointConverter.encode(item.type),
                  'parentKey': item.parentKey
                },
            changeListener),
        _topicSavePointEntityDeletionAdapter = DeletionAdapter(
            database,
            'topicSavePoint',
            ['id'],
            (TopicSavePointEntity item) => <String, Object?>{
                  'id': item.id,
                  'pos': item.pos,
                  'type': _topicSavePointConverter.encode(item.type),
                  'parentKey': item.parentKey
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TopicSavePointEntity>
      _topicSavePointEntityInsertionAdapter;

  final UpdateAdapter<TopicSavePointEntity> _topicSavePointEntityUpdateAdapter;

  final DeletionAdapter<TopicSavePointEntity>
      _topicSavePointEntityDeletionAdapter;

  @override
  Stream<TopicSavePointEntity?> getStreamTopicSavePointEntity(
      int type, String parentKey) {
    return _queryAdapter.queryStream(
        'select * from topicSavePoint where type=?1 and parentKey=?2      order by id desc limit 1',
        mapper: (Map<String, Object?> row) => TopicSavePointEntity(
            id: row['id'] as int?,
            pos: row['pos'] as int,
            type: _topicSavePointConverter.decode(row['type'] as int),
            parentKey: row['parentKey'] as String),
        arguments: [type, parentKey],
        queryableName: 'topicSavePoint',
        isView: false);
  }

  @override
  Future<TopicSavePointEntity?> getTopicSavePointEntity(
      int type, String parentKey) async {
    return _queryAdapter.query(
        'select * from topicSavePoint where type=?1 and parentKey=?2      order by id desc limit 1',
        mapper: (Map<String, Object?> row) => TopicSavePointEntity(id: row['id'] as int?, pos: row['pos'] as int, type: _topicSavePointConverter.decode(row['type'] as int), parentKey: row['parentKey'] as String),
        arguments: [type, parentKey]);
  }

  @override
  Future<int> insertTopicSavePoint(TopicSavePointEntity topicSavePointEntity) {
    return _topicSavePointEntityInsertionAdapter.insertAndReturnId(
        topicSavePointEntity, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateTopicSavePoint(TopicSavePointEntity topicSavePointEntity) {
    return _topicSavePointEntityUpdateAdapter.updateAndReturnChangedRows(
        topicSavePointEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteTopicSavePoint(TopicSavePointEntity topicSavePointEntity) {
    return _topicSavePointEntityDeletionAdapter
        .deleteAndReturnChangedRows(topicSavePointEntity);
  }
}

class _$HistoryDao extends HistoryDao {
  _$HistoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _historyEntityInsertionAdapter = InsertionAdapter(
            database,
            'History',
            (HistoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'originType': item.originType,
                  'modifiedDate': item.modifiedDate
                },
            changeListener),
        _historyEntityUpdateAdapter = UpdateAdapter(
            database,
            'History',
            ['id'],
            (HistoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'originType': item.originType,
                  'modifiedDate': item.modifiedDate
                },
            changeListener),
        _historyEntityDeletionAdapter = DeletionAdapter(
            database,
            'History',
            ['id'],
            (HistoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'originType': item.originType,
                  'modifiedDate': item.modifiedDate
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HistoryEntity> _historyEntityInsertionAdapter;

  final UpdateAdapter<HistoryEntity> _historyEntityUpdateAdapter;

  final DeletionAdapter<HistoryEntity> _historyEntityDeletionAdapter;

  @override
  Stream<List<HistoryEntity>> getStreamHistoryWithOrigin(int originId) {
    return _queryAdapter.queryListStream(
        'select * from history where originType=?1 order by modifiedDate desc',
        mapper: (Map<String, Object?> row) => HistoryEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            originType: row['originType'] as int,
            modifiedDate: row['modifiedDate'] as String),
        arguments: [originId],
        queryableName: 'History',
        isView: false);
  }

  @override
  Future<HistoryEntity?> getHistoryEntity(int originId, String name) async {
    return _queryAdapter.query(
        'select * from history where originType=?1 and name=?2',
        mapper: (Map<String, Object?> row) => HistoryEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            originType: row['originType'] as int,
            modifiedDate: row['modifiedDate'] as String),
        arguments: [originId, name]);
  }

  @override
  Future<int> insertHistory(HistoryEntity historyEntity) {
    return _historyEntityInsertionAdapter.insertAndReturnId(
        historyEntity, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateHistory(HistoryEntity historyEntity) {
    return _historyEntityUpdateAdapter.updateAndReturnChangedRows(
        historyEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteHistory(HistoryEntity historyEntity) {
    return _historyEntityDeletionAdapter
        .deleteAndReturnChangedRows(historyEntity);
  }

  @override
  Future<int> deleteHistories(List<HistoryEntity> historyEntities) {
    return _historyEntityDeletionAdapter
        .deleteListAndReturnChangedRows(historyEntities);
  }
}

class _$BackupMetaDao extends BackupMetaDao {
  _$BackupMetaDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _backupMetaInsertionAdapter = InsertionAdapter(
            database,
            'BackupMeta',
            (BackupMeta item) => <String, Object?>{
                  'id': item.id,
                  'fileName': item.fileName,
                  'updatedDate': item.updatedDate,
                  'isAuto': item.isAuto ? 1 : 0
                },
            changeListener),
        _backupMetaUpdateAdapter = UpdateAdapter(
            database,
            'BackupMeta',
            ['id'],
            (BackupMeta item) => <String, Object?>{
                  'id': item.id,
                  'fileName': item.fileName,
                  'updatedDate': item.updatedDate,
                  'isAuto': item.isAuto ? 1 : 0
                },
            changeListener),
        _backupMetaDeletionAdapter = DeletionAdapter(
            database,
            'BackupMeta',
            ['id'],
            (BackupMeta item) => <String, Object?>{
                  'id': item.id,
                  'fileName': item.fileName,
                  'updatedDate': item.updatedDate,
                  'isAuto': item.isAuto ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BackupMeta> _backupMetaInsertionAdapter;

  final UpdateAdapter<BackupMeta> _backupMetaUpdateAdapter;

  final DeletionAdapter<BackupMeta> _backupMetaDeletionAdapter;

  @override
  Future<List<BackupMeta>> getNonAutoBackupMetaWithOffset(
      int limit, int offset) async {
    return _queryAdapter.queryList(
        'select * from backupMeta where isAuto=0 order by updatedDate desc limit ?1 offset ?2',
        mapper: (Map<String, Object?> row) => BackupMeta(fileName: row['fileName'] as String, id: row['id'] as int?, updatedDate: row['updatedDate'] as String, isAuto: (row['isAuto'] as int) != 0),
        arguments: [limit, offset]);
  }

  @override
  Future<List<BackupMeta>> getAutoBackupMetaWithOffset(
      int limit, int offset) async {
    return _queryAdapter.queryList(
        'select * from backupMeta where isAuto=1 order by updatedDate desc limit ?1 offset ?2',
        mapper: (Map<String, Object?> row) => BackupMeta(fileName: row['fileName'] as String, id: row['id'] as int?, updatedDate: row['updatedDate'] as String, isAuto: (row['isAuto'] as int) != 0),
        arguments: [limit, offset]);
  }

  @override
  Future<IntData?> getNonAutoBackupMetaSize() async {
    return _queryAdapter.query(
        'select count(*) data from backupMeta where isAuto=0',
        mapper: (Map<String, Object?> row) =>
            IntData(data: row['data'] as int));
  }

  @override
  Future<IntData?> getAutoBackupMetaSize() async {
    return _queryAdapter.query(
        'select count(*) data from backupMeta where isAuto=1',
        mapper: (Map<String, Object?> row) =>
            IntData(data: row['data'] as int));
  }

  @override
  Future<BackupMeta?> getFirstUpdatedAutoBackupMeta() async {
    return _queryAdapter.query(
        'select * from backupMeta where isAuto=1 order by updatedDate limit 1',
        mapper: (Map<String, Object?> row) => BackupMeta(
            fileName: row['fileName'] as String,
            id: row['id'] as int?,
            updatedDate: row['updatedDate'] as String,
            isAuto: (row['isAuto'] as int) != 0));
  }

  @override
  Future<BackupMeta?> getFirstUpdatedNonAutoBackupMeta() async {
    return _queryAdapter.query(
        'select * from backupMeta where isAuto=0 order by updatedDate limit 1',
        mapper: (Map<String, Object?> row) => BackupMeta(
            fileName: row['fileName'] as String,
            id: row['id'] as int?,
            updatedDate: row['updatedDate'] as String,
            isAuto: (row['isAuto'] as int) != 0));
  }

  @override
  Stream<List<BackupMeta>> getStreamBackupMetas() {
    return _queryAdapter.queryListStream(
        'select * from backupMeta order by updatedDate desc',
        mapper: (Map<String, Object?> row) => BackupMeta(
            fileName: row['fileName'] as String,
            id: row['id'] as int?,
            updatedDate: row['updatedDate'] as String,
            isAuto: (row['isAuto'] as int) != 0),
        queryableName: 'BackupMeta',
        isView: false);
  }

  @override
  Future<BackupMeta?> getLastBackupMeta() async {
    return _queryAdapter.query(
        'select * from backupMeta order by updatedDate desc limit 1',
        mapper: (Map<String, Object?> row) => BackupMeta(
            fileName: row['fileName'] as String,
            id: row['id'] as int?,
            updatedDate: row['updatedDate'] as String,
            isAuto: (row['isAuto'] as int) != 0));
  }

  @override
  Future<void> deleteBackupMetaWithQuery() async {
    await _queryAdapter.queryNoReturn('delete from backupMeta');
  }

  @override
  Future<List<int>> insertBackupMetas(List<BackupMeta> backupMetas) {
    return _backupMetaInsertionAdapter.insertListAndReturnIds(
        backupMetas, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertBackupMeta(BackupMeta backupMeta) {
    return _backupMetaInsertionAdapter.insertAndReturnId(
        backupMeta, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateBackupMetas(List<BackupMeta> backupMetas) {
    return _backupMetaUpdateAdapter.updateListAndReturnChangedRows(
        backupMetas, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateBackupMeta(BackupMeta backupMeta) {
    return _backupMetaUpdateAdapter.updateAndReturnChangedRows(
        backupMeta, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteBackupMeta(BackupMeta backupMeta) {
    return _backupMetaDeletionAdapter.deleteAndReturnChangedRows(backupMeta);
  }

  @override
  Future<int> deleteBackupMetas(List<BackupMeta> backupMetas) {
    return _backupMetaDeletionAdapter
        .deleteListAndReturnChangedRows(backupMetas);
  }
}

class _$BackupDao extends BackupDao {
  _$BackupDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _historyEntityInsertionAdapter = InsertionAdapter(
            database,
            'History',
            (HistoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'originType': item.originType,
                  'modifiedDate': item.modifiedDate
                },
            changeListener),
        _listEntityInsertionAdapter = InsertionAdapter(
            database,
            'list',
            (ListEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isRemovable': item.isRemovable ? 1 : 0,
                  'sourceId': item.sourceId,
                  'isArchive': item.isArchive ? 1 : 0,
                  'pos': item.pos
                },
            changeListener),
        _listHadithEntityInsertionAdapter = InsertionAdapter(
            database,
            'listHadith',
            (ListHadithEntity item) => <String, Object?>{
                  'listId': item.listId,
                  'hadithId': item.hadithId,
                  'pos': item.pos
                },
            changeListener),
        _listVerseEntityInsertionAdapter = InsertionAdapter(
            database,
            'listVerse',
            (ListVerseEntity item) => <String, Object?>{
                  'listId': item.listId,
                  'verseId': item.verseId,
                  'pos': item.pos
                },
            changeListener),
        _savePointInsertionAdapter = InsertionAdapter(
            database,
            'savePoint',
            (SavePoint item) => <String, Object?>{
                  'id': item.id,
                  'itemIndexPos': item.itemIndexPos,
                  'title': item.title,
                  'isAuto': item.isAuto ? 1 : 0,
                  'modifiedDate': item.modifiedDate,
                  'savePointType':
                      _originTagConverter.encode(item.savePointType),
                  'bookIdBinary': item.bookIdBinary,
                  'parentName': item.parentName,
                  'parentKey': item.parentKey
                },
            changeListener),
        _topicSavePointEntityInsertionAdapter = InsertionAdapter(
            database,
            'topicSavePoint',
            (TopicSavePointEntity item) => <String, Object?>{
                  'id': item.id,
                  'pos': item.pos,
                  'type': _topicSavePointConverter.encode(item.type),
                  'parentKey': item.parentKey
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HistoryEntity> _historyEntityInsertionAdapter;

  final InsertionAdapter<ListEntity> _listEntityInsertionAdapter;

  final InsertionAdapter<ListHadithEntity> _listHadithEntityInsertionAdapter;

  final InsertionAdapter<ListVerseEntity> _listVerseEntityInsertionAdapter;

  final InsertionAdapter<SavePoint> _savePointInsertionAdapter;

  final InsertionAdapter<TopicSavePointEntity>
      _topicSavePointEntityInsertionAdapter;

  @override
  Future<List<HistoryEntity>> getHistories() async {
    return _queryAdapter.queryList('select * from history',
        mapper: (Map<String, Object?> row) => HistoryEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            originType: row['originType'] as int,
            modifiedDate: row['modifiedDate'] as String));
  }

  @override
  Future<List<ListEntity>> getLists() async {
    return _queryAdapter.queryList('select * from list where isRemovable=1',
        mapper: (Map<String, Object?> row) => ListEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            isArchive: (row['isArchive'] as int) != 0,
            isRemovable: (row['isRemovable'] as int) != 0,
            sourceId: row['sourceId'] as int,
            pos: row['pos'] as int));
  }

  @override
  Future<List<ListHadithEntity>> getHadithListEntities() async {
    return _queryAdapter.queryList('select * from ListHadith',
        mapper: (Map<String, Object?> row) => ListHadithEntity(
            listId: row['listId'] as int,
            hadithId: row['hadithId'] as int,
            pos: row['pos'] as int));
  }

  @override
  Future<List<ListVerseEntity>> getVerseListEntities() async {
    return _queryAdapter.queryList('select * from listVerse',
        mapper: (Map<String, Object?> row) => ListVerseEntity(
            listId: row['listId'] as int,
            verseId: row['verseId'] as int,
            pos: row['pos'] as int));
  }

  @override
  Future<List<SavePoint>> getSavePoints() async {
    return _queryAdapter.queryList('select * from savepoint',
        mapper: (Map<String, Object?> row) => SavePoint(
            id: row['id'] as int?,
            itemIndexPos: row['itemIndexPos'] as int,
            title: row['title'] as String,
            isAuto: (row['isAuto'] as int) != 0,
            modifiedDate: row['modifiedDate'] as String?,
            savePointType:
                _originTagConverter.decode(row['savePointType'] as int),
            bookIdBinary: row['bookIdBinary'] as int,
            parentKey: row['parentKey'] as String,
            parentName: row['parentName'] as String));
  }

  @override
  Future<List<TopicSavePointEntity>> getTopicSavePoints() async {
    return _queryAdapter.queryList('select * from topicSavePoint',
        mapper: (Map<String, Object?> row) => TopicSavePointEntity(
            id: row['id'] as int?,
            pos: row['pos'] as int,
            type: _topicSavePointConverter.decode(row['type'] as int),
            parentKey: row['parentKey'] as String));
  }

  @override
  Future<void> deleteHistories() async {
    await _queryAdapter.queryNoReturn('delete from history');
  }

  @override
  Future<void> deleteLists() async {
    await _queryAdapter.queryNoReturn('delete from list where isRemovable=1');
  }

  @override
  Future<void> deleteHadithLists() async {
    await _queryAdapter.queryNoReturn('delete from ListHadith');
  }

  @override
  Future<void> deleteVerseLists() async {
    await _queryAdapter.queryNoReturn('delete from listVerse');
  }

  @override
  Future<void> deleteSavePoints() async {
    await _queryAdapter.queryNoReturn('delete from savepoint');
  }

  @override
  Future<void> deleteTopicSavePoints() async {
    await _queryAdapter.queryNoReturn('delete from topicSavePoint');
  }

  @override
  Future<List<int>> insertHistories(List<HistoryEntity> histories) {
    return _historyEntityInsertionAdapter.insertListAndReturnIds(
        histories, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertLists(List<ListEntity> lists) {
    return _listEntityInsertionAdapter.insertListAndReturnIds(
        lists, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertHadithLists(List<ListHadithEntity> hadithLists) {
    return _listHadithEntityInsertionAdapter.insertListAndReturnIds(
        hadithLists, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertVerseLists(List<ListVerseEntity> verseLists) {
    return _listVerseEntityInsertionAdapter.insertListAndReturnIds(
        verseLists, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertSavePoints(List<SavePoint> savePoints) {
    return _savePointInsertionAdapter.insertListAndReturnIds(
        savePoints, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertTopicSavePoints(
      List<TopicSavePointEntity> topicSavePoints) {
    return _topicSavePointEntityInsertionAdapter.insertListAndReturnIds(
        topicSavePoints, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertHistory(HistoryEntity history) {
    return _historyEntityInsertionAdapter.insertAndReturnId(
        history, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertList(ListEntity list) {
    return _listEntityInsertionAdapter.insertAndReturnId(
        list, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertHadithList(ListHadithEntity hadithList) {
    return _listHadithEntityInsertionAdapter.insertAndReturnId(
        hadithList, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertVerseList(ListVerseEntity verseList) {
    return _listVerseEntityInsertionAdapter.insertAndReturnId(
        verseList, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertSavePoint(SavePoint savePoint) {
    return _savePointInsertionAdapter.insertAndReturnId(
        savePoint, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertTopicSavePoint(TopicSavePointEntity topicSavePoint) {
    return _topicSavePointEntityInsertionAdapter.insertAndReturnId(
        topicSavePoint, OnConflictStrategy.replace);
  }
}

class _$UserInfoDao extends UserInfoDao {
  _$UserInfoDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _userInfoEntityInsertionAdapter = InsertionAdapter(
            database,
            'userInfo',
            (UserInfoEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'img': item.img
                },
            changeListener),
        _userInfoEntityUpdateAdapter = UpdateAdapter(
            database,
            'userInfo',
            ['id'],
            (UserInfoEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'img': item.img
                },
            changeListener),
        _userInfoEntityDeletionAdapter = DeletionAdapter(
            database,
            'userInfo',
            ['id'],
            (UserInfoEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'img': item.img
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserInfoEntity> _userInfoEntityInsertionAdapter;

  final UpdateAdapter<UserInfoEntity> _userInfoEntityUpdateAdapter;

  final DeletionAdapter<UserInfoEntity> _userInfoEntityDeletionAdapter;

  @override
  Stream<UserInfoEntity?> getStreamUserInfoWithId(String userId) {
    return _queryAdapter.queryStream('select * from userInfo where userId=?1',
        mapper: (Map<String, Object?> row) => UserInfoEntity(
            userId: row['userId'] as String,
            img: row['img'] as Uint8List?,
            id: row['id'] as int?),
        arguments: [userId],
        queryableName: 'userInfo',
        isView: false);
  }

  @override
  Future<UserInfoEntity?> getUserInfoWithId(String userId) async {
    return _queryAdapter.query('select * from userInfo where userId=?1',
        mapper: (Map<String, Object?> row) => UserInfoEntity(
            userId: row['userId'] as String,
            img: row['img'] as Uint8List?,
            id: row['id'] as int?),
        arguments: [userId]);
  }

  @override
  Future<void> deleteAllDataWithQuery() async {
    await _queryAdapter.queryNoReturn('delete from userInfo');
  }

  @override
  Future<int> insertUserInfo(UserInfoEntity userInfoEntity) {
    return _userInfoEntityInsertionAdapter.insertAndReturnId(
        userInfoEntity, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateUserInfo(UserInfoEntity userInfoEntity) {
    return _userInfoEntityUpdateAdapter.updateAndReturnChangedRows(
        userInfoEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteUserInfo(UserInfoEntity userInfoEntity) {
    return _userInfoEntityDeletionAdapter
        .deleteAndReturnChangedRows(userInfoEntity);
  }
}

// ignore_for_file: unused_element
final _originTagConverter = OriginTagConverter();
final _topicSavePointConverter = TopicSavePointConverter();
