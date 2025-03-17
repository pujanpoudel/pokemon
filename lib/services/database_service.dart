import 'package:shared_preferences/shared_preferences.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_data_providers.dart';

final PokemonListResult _pokemon = PokemonListResult();

class DatabaseService {
  DatabaseService();

  final pokemonId = _pokemon.url;

  Future<bool?> saveLikedList(String key, List<String> value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setStringList(key, value);
      return result;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<String>?> getLikedList(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? result = await prefs.getStringList(key);
      return result;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool?> saveComments(String id, List<String> value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setStringList(pokemonId!, value);
      return result;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<String>?> getComments(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? comments = await prefs.getStringList(pokemonId!);
      return comments;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
