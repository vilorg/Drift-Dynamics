import 'package:drift_dynamics/database/pilot.dart';
import 'package:drift_dynamics/database/round.dart';
import 'package:drift_dynamics/database/session.dart';
import 'package:drift_dynamics/database/session_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    else if (_database==null) _database = await initDB(); return _database;
  }

  static const tableRounds = """
      CREATE TABLE Round (
      id INTEGER PRIMARY KEY,
      name TEXT
      );
      """;

  static const tablePilots = """
    CREATE TABLE Pilot (
    id INTEGER PRIMARY KEY,
    name TEXT
    );
  """;

  static const tableSession = """
    CREATE TABLE Session (
    id INTEGER PRIMARY KEY,
    track TEXT,
    curTime TEXT,
    pilot TEXT,
    speed TEXT,
    speedAVG TEXT,
    angle TEXT,
    offset REAL,
    time TEXT,
    zero TEXT,
    session TEXT
    );
  """;

  static const tableSessionList = """
    CREATE TABLE SessionList (
    id INTEGER PRIMARY KEY,
    tag TEXT,
    pilot TEXT,
    raceDT TEXT,
    track TEXT
    );
  """;

  Future<Database> initDB() async {
    print("initDB executed");
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), "data.db");
    bool key = await databaseExists(path);
    if (key) {
      await deleteDatabase(path);
      return await openDatabase(path, version: 2,
          onCreate: (Database db, int version) async {
            await db.execute(tableRounds);
            await db.execute(tablePilots);
            await db.execute(tableSession);
            await db.execute(tableSessionList);
          });
    }
  }

  newRound(Round newRound) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Round");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Round (id,name)"
            " VALUES (?,?)",
        [newRound.id, newRound.name]);
    return raw;
  }

  updateRound(Round newRound) async {
    final db = await database;
    var res = await db.update("Round", newRound.toMap(),
        where: "id = ?", whereArgs: [newRound.id]);
    return res;
  }

  getRound(int id) async {
    final db = await database;
    var res = await db.query("Round", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Round.fromMap(res.first) : null;
  }

  Future<List<Round>> getAllRounds() async {
    final db = await database;
    var res = await db.query("Round");
    List<Round> list =
    res.isNotEmpty ? res.map((c) => Round.fromMap(c)).toList() : [];
    return list;
  }

  deleteRound(int id) async {
    final db = await database;
    return db.delete("Round", where: "id = ?", whereArgs: [id]);
  }

  deleteAllRound() async {
    final db = await database;
    db.rawDelete("Delete * from Round");
  }

  newPilot(Pilot newPilot) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Pilot");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Pilot (id,name)"
            " VALUES (?,?)",
        [newPilot.id, newPilot.name]);
    return raw;
  }

  updatePilot(Pilot newPilot) async {
    final db = await database;
    var res = await db.update("Pilot", newPilot.toMap(),
        where: "id = ?", whereArgs: [newPilot.id]);
    return res;
  }

  getPilot(int id) async {
    final db = await database;
    var res = await db.query("Pilot", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Pilot.fromMap(res.first) : null;
  }

  Future<List<Pilot>> getAllPilots() async {
    final db = await database;
    var res = await db.query("Pilot");
    List<Pilot> list =
    res.isNotEmpty ? res.map((c) => Pilot.fromMap(c)).toList() : [];
    return list;
  }

  deletePilot(int id) async {
    final db = await database;
    return db.delete("Pilot", where: "id = ?", whereArgs: [id]);
  }

  deleteAllPilot() async {
    final db = await database;
    db.rawDelete("Delete * from Pilot");
  }

  newSession(Session newSession) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Session");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Session (id,tag,pilot,raceDT)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [
          newSession.sessionId,
          newSession.track,
          newSession.curTime,
          newSession.pilot,
          newSession.speed,
          newSession.speedAvg,
          newSession.angle,
          newSession.offset,
          newSession.time,
          newSession.zero,
          newSession.session.toString()
        ]);
    return raw;
  }

  getSession(int id) async {
    final db = await database;
    var res = await db.query("Session", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Session.fromMap(res.first) : null;
  }

  Future<List<Session>> getAllSessions() async {
    final db = await database;
    var res = await db.query("Session");
    List<Session> list =
    res.isNotEmpty ? res.map((c) => Session.fromMap(c)).toList() : [];
    return list;
  }

  deleteAllSession() async {
    final db = await database;
    db.rawDelete("Delete * from Session");
  }

  newSessionList(SessionList newSessionList) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM SessionList");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into SessionList (id,tag,pilot,raceDT, track)"
            " VALUES (?,?,?,?,?)",
        [newSessionList.id, newSessionList.tag, newSessionList.pilot, newSessionList.raceDT, newSessionList.track]);
    return raw;
  }

  updateSessionList(SessionList newSessionList) async {
    final db = await database;
    var res = await db.update("SessionList", newSessionList.toMap(),
        where: "id = ?", whereArgs: [newSessionList.id]);
    return res;
  }

  getSessionList(int id) async {
    final db = await database;
    var res = await db.query("SessionList", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? SessionList.fromMap(res.first) : null;
  }

  Future<List<SessionList>> getAllSessionLists() async {
    final db = await database;
    var res = await db.query("SessionList");
    List<SessionList> list =
    res.isNotEmpty ? res.map((c) => SessionList.fromMap(c)).toList() : [];
    return list;
  }

  deleteSessionList(int id) async {
    final db = await database;
    return db.delete("SessionList", where: "id = ?", whereArgs: [id]);
  }

  deleteAllSessionList() async {
    final db = await database;
    db.rawDelete("Delete * from SessionList");
  }
}
