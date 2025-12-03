import 'package:hive/hive.dart';

class LocationStorageService {
  static const _boxName = 'locationBox';
  static const _latKey = 'lat';
  static const _lonKey = 'lon';

  Future<void> saveLocation(double lat, double lon) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_latKey, lat);
    await box.put(_lonKey, lon);
    await box.close();
  }

  Future<List<double>?> getLocation() async {
    final box = await Hive.openBox(_boxName);
    final lat = box.get(_latKey);
    final lon = box.get(_lonKey);
    await box.close();
    if (lat != null && lon != null) {
      return [lat, lon];
    }
    return null;
  }
}
