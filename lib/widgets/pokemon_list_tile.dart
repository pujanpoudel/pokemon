import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test/models/pokemon.dart';
import 'package:test/providers/pokemon_data_providers.dart';
import 'package:test/widgets/pokemon_stats.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  late FavouritePokemonsProvider _favouritePokemonProvider;
  late List<String> _favouritePokemons;

  PokemonListTile({super.key, required this.pokemonURL});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favouritePokemonProvider = ref.watch(favouritePokemonsProvider.notifier);
    _favouritePokemons = ref.watch(favouritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stackTrace) {
      return Text("error: $error");
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          print("data");
          if (!isLoading) {
            showDialog(
                context: context,
                builder: (_) {
                  return PokemonStatsCard(pokemonURL: pokemonURL);
                });
          }
        },
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    pokemon.sprites!.frontDefault!,
                  ),
                )
              : CircleAvatar(),
          title: Text(
            pokemon != null
                ? pokemon.name!.toUpperCase()
                : "currently loading name for pokemon",
          ),
          subtitle: Text("has ${pokemon?.moves?.length.toString() ?? 0} moves"),
          trailing: IconButton(
              onPressed: () {
                if (_favouritePokemons.contains(pokemonURL)) {
                  _favouritePokemonProvider.removeFavouritePokemon(pokemonURL);
                } else {
                  _favouritePokemonProvider.addFavouritePokemon(pokemonURL);
                }
              },
              icon: Icon(
                _favouritePokemons.contains(pokemonURL)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              )),
        ),
      ),
    );
  }
}
