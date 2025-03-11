import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/services/database_service.dart';
import '../models/pokemon.dart';
import '../state/pokemon_state.dart';

final pokemonrNotifierProvider =
    StateNotifierProvider<PokemonNotifier, PokemonState>((ref) {
  return PokemonNotifier();
});

class PokemonNotifier extends StateNotifier<PokemonState> {
  final DatabaseService _databaseService = DatabaseService();
  PokemonNotifier() : super(PokemonState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final Pokemon pokemon = Pokemon();
    final likedList =
        await _databaseService.getLikedList(pokemon.id.toString());

    final commentsList =
        await _databaseService.getComments(pokemon.id.toString());

    print("data: $likedList.toString()");
    try {
      state = state.copyWith(pokemonLiked: likedList);
      print("$state");
      state = state.copyWith(pokemonCommented: commentsList);
    } catch (e) {
      print("Error fetching Pokemons: $e");
    }
  }
}
