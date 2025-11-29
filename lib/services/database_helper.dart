import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/audio_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> getDataBase() async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDB("playoor.db");
      return _database!;
    }
  }

  Future<Database?> initDB(String filePath) async {
    String dbPath, path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      dbPath = await databaseFactoryFfi.getDatabasesPath();
      path = join(dbPath, filePath);
      return await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(version: 1, onCreate: onCreate),
      );
    }
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
      return await openDatabase(path, version: 1, onCreate: onCreate);
    }
    return null;
  }

  FutureOr<void> onCreate(Database db, int version) async {
    return await db.execute("""
    create table audioitem (
    id integer primary key autoincrement not null unique,
    assetPath text not null,
    title text not null,
    artist text not null,
    imagePath text not null
    );     
    """);
  }

  Future<AudioItem> create(AudioItem audioItem) async {
    final db = await instance.getDataBase();
    int newId = await db.insert('audioitem', audioItem.toMap());
    return AudioItem(
      id: newId,
      assetPath: audioItem.assetPath,
      title: audioItem.title,
      artist: audioItem.artist,
      imagePath: audioItem.imagePath,
    );
  }

  Future<List<AudioItem>> readAll() async {
    final db = await instance.getDataBase();
    final data = await db.query("audioitem");
    return data.map((map) => AudioItem.fromMap(map)).toList();
  }

  Future<int> update(AudioItem audioItem) async {
    final db = await instance.getDataBase();
    return await db.update(
      "audioitem",
      audioItem.toMap(),
      where: 'id=?',
      whereArgs: [audioItem.id],
    );
  }

  Future<int> delete(AudioItem audioItem) async {
    final db = await instance.getDataBase();
    return await db.delete(
      "audioitem",
      where: 'id=?',
      whereArgs: [audioItem.id],
    );
  }

  Future<bool> isDatabaseSeeded() async {
    final db = await instance.getDataBase();
    final result = await db.query("audioitem", limit: 1);
    return result.isNotEmpty;
  }

  Future<void> seedInitialData() async {
    final isSeeded = await isDatabaseSeeded();
    if (isSeeded) {
      return;
    }

    final initialSongs = [
      AudioItem(
        assetPath: "allthat.mp3",
        title: "All that",
        artist: "Mayelo",
        imagePath: "assets/allthat_colored.jpg",
      ),
      AudioItem(
        assetPath: "love.mp3",
        title: "Love",
        artist: "Diego",
        imagePath: "assets/love_colored.jpg",
      ),
      AudioItem(
        assetPath: "thejazzpiano.mp3",
        title: "Jazz Piano",
        artist: "Jazira",
        imagePath: "assets/thejazzpiano_colored.jpg",
      ),
      AudioItem(
        assetPath: "Bring Me To Life.mp3",
        title: "Bring Me To Life",
        artist: "Evanescence",
        imagePath: "assets/Bring Me To Life.jpg",
      ),
      AudioItem(
        assetPath: "Welcome to the Black Parade.mp3",
        title: "Welcome to the Black Parade",
        artist: "My Chemical Romance",
        imagePath: "assets/Welcome to the Black Parade.jpg",
      ),
      AudioItem(
        assetPath: "System Of A Down - Chop Suey.mp3",
        title: "Chop Suey",
        artist: "System Of A Down",
        imagePath: "assets/chop suey.jpg",
      ),
      AudioItem(
        assetPath: "Madrugada.mp3",
        title: "Madrugada",
        artist: "Enjambre",
        imagePath: "assets/madrugada.jpg",
      ),
      AudioItem(
        assetPath: "Du hast.mp3",
        title: "Du hast",
        artist: "Rammstein",
        imagePath: "assets/du hast.jpg",
      ),
    ];

    for (var song in initialSongs) {
      await create(song);
    }
  }

  void close() async {
    final db = await instance.getDataBase();
    db.close();
  }
}
