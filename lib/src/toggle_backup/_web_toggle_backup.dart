import 'package:unleash/src/features.dart';
import 'package:unleash/src/toggle_backup/toggle_backup.dart';
import 'package:unleash/src/toggles.dart';

ToggleBackup create(String backupFilePath) => NoOpToggleBackup();

class NoOpToggleBackup implements ToggleBackup {
  @override
  Future<Features?> load() async => null;

  @override
  Future<void> save(Features toggleJson) => Future.value();

  @override
  Future<Toggles?> loadToggles() async => null;

  @override
  Future<void> saveToggles(Toggles toggles) => Future.value();
}
