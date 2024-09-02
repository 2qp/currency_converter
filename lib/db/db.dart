import 'package:currency_converter/bloc/autocomplete/auto_complete_state.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  late final Database _database;
  late final StoreRef<String, Map<String, dynamic>> _store;

  AppDatabase._create(this._database) {
    _store = stringMapStoreFactory.store('autoCompleteStates');
  }

  static Future<AppDatabase> create() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocDir.path, 'app.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return AppDatabase._create(database);
  }

  Future<void> removeState(String id) async {
    final autoCompleteStates = await getAutoCompleteStates();

    if (autoCompleteStates != null) {
      final updatedStates =
          Map<String, AutoCompleteState>.from(autoCompleteStates.states);
      updatedStates.remove(id);

      final updatedAutoCompleteStates =
          autoCompleteStates.copyWith(states: updatedStates);

      await saveAutoCompleteStates(updatedAutoCompleteStates);
    }
  }

  Future<void> saveAutoCompleteStates(
      AutoCompleteStates autoCompleteStates) async {
    await _store.record('states').put(_database, autoCompleteStates.toMap());
  }

  Future<AutoCompleteStates?> getAutoCompleteStates() async {
    final record = await _store.record('states').get(_database);
    if (record != null) {
      return AutoCompleteStates.fromMap(record);
    }
    return null;
  }
}
