import 'package:hive/hive.dart';

abstract class BaseStorage {
  late Box<dynamic> _box;

  Future<void> init(String boxName) async {
    _box = await Hive.openBox(boxName);
  }

  Future<void> remove(String key) => _box.delete(key);

  Future<void> removeAll() => _box.clear();

  T? retrieve<T>(String key) => _box.get(key) as T?;

  Future<void> store<T>(String key, T value) => _box.put(key, value);

  bool hasData(String key) => _box.containsKey(key);

  List<dynamic> getAllKeys() => _box.keys.toList();
}
