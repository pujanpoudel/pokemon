import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/providers/pokemon_data_providers.dart';
import 'package:test/services/database_service.dart';

class PokemonStatsCard extends ConsumerStatefulWidget {
  final String pokemonURL;

  PokemonStatsCard({super.key, required this.pokemonURL});

  @override
  _PokemonStatsCardState createState() => _PokemonStatsCardState();
}

class _PokemonStatsCardState extends ConsumerState<PokemonStatsCard> {
  final TextEditingController _commentController = TextEditingController();
  late PokemonCommentsProvider _pokemonCommentsProvider;
  late List<String> _commentsOnPokemon;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = ref.watch(pokemonDataProvider(widget.pokemonURL));
    _pokemonCommentsProvider = ref.watch(pokemonCommentsProvider.notifier);
    _commentsOnPokemon = ref.watch(pokemonCommentsProvider);
    String comment = _commentController.text;

    return AlertDialog(
      title: const Center(child: Text("Statistics")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          pokemon.when(
            data: (data) {
              return Column(
                children: data?.stats?.map((s) {
                      return Text(
                          '${s.stat?.name?.toUpperCase()}: ${s.baseStat}');
                    }).toList() ??
                    [],
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const CircularProgressIndicator(color: Colors.white),
          ),
          const Text(
            "Comments",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: ListView.separated(
              itemCount: _commentsOnPokemon.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('item $index'),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: "Comment",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            _pokemonCommentsProvider.addComments(widget.pokemonURL);
            Navigator.of(context).pop(_commentController.text);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
