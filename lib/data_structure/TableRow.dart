abstract class TableRow {
  String tableName = "";
  fromMap(Map<String, dynamic> pMap) {}
  toMap() {}

  List<Object?> getWhereKey() {
    return [];
  }

  String getWhereExp() {
    return "";
  }
}
