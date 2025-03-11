import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/providers/pokemon_data_providers.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonURL;

  PokemonStatsCard({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return AlertDialog(
      title: Text("Statistics"),
      content: pokemon.when(data: (data) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: data?.stats?.map((s) {
                return Text('${s.stat?.name?.toUpperCase()}: ${s.baseStat}');
              }).toList() ??
              [],
        );
      }, error: (error, StackTrace) {
        return Text(
          error.toString(),
        );
      }, loading: () {
        return const CircularProgressIndicator(
          color: Colors.white,
        );
      }),
    );
  }
}
