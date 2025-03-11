class PokemonState {
  final List<String> pokemonLiked;
  final List<String> pokemonCommented;

  PokemonState(
      {this.pokemonLiked = const [], this.pokemonCommented = const []});

  PokemonState copyWith(
      {List<String>? pokemonLiked, List<String>? pokemonCommented}) {
    return PokemonState(
        pokemonLiked: pokemonLiked ?? this.pokemonLiked,
        pokemonCommented: pokemonCommented ?? this.pokemonCommented);
  }
}
