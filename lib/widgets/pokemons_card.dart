import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test/models/pokemon.dart';
import 'package:test/providers/pokemon_data_providers.dart';
import 'package:test/widgets/pokemon_stats.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonURL;

  late FavouritePokemonsProvider _favouritePokemonsProvider;

  PokemonCard({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    _favouritePokemonsProvider = ref.watch(favouritePokemonsProvider.notifier);

    return pokemon.when(data: (data) {
      return _card(context, false, data);
    }, error: (error, StackTrace) {
      return Text("Error: $error");
    }, loading: () {
      return _card(context, true, null);
    });
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      ignoreContainers: true,
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
                context: context,
                builder: (_) {
                  return PokemonStatsCard(pokemonURL: pokemonURL);
                });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, spreadRadius: 2, blurRadius: 10)
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon?.name?.toUpperCase() ?? "pokemon",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "#${pokemon?.id?.toString()}",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Expanded(
                    child: CircleAvatar(
                        radius: MediaQuery.sizeOf(context).height * 0.05,
                        backgroundImage: pokemon != null
                            ? NetworkImage(pokemon!.sprites!.frontDefault!)
                            : null)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${pokemon?.moves?.length} Moves",
                      style: const TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        _favouritePokemonsProvider
                            .removeFavouritePokemon(pokemonURL);
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
