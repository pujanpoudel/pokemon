import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:test/providers/pokemon_data_providers.dart';

import '../services/database_service.dart';

class PokemonStatsCard extends ConsumerStatefulWidget {
  final String pokemonURL;

  const PokemonStatsCard({super.key, required this.pokemonURL});

  @override
  _PokemonStatsCardState createState() => _PokemonStatsCardState();
}

class _PokemonStatsCardState extends ConsumerState<PokemonStatsCard> {
  final TextEditingController _commentController = TextEditingController();

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
    var _comments = ref.watch(pokemonCommentsProvider.notifier);
    var item = _databaseService.getComments(widget.pokemonURL);
    // final item = _comments.getComments(widget.pokemonURL);

    return AlertDialog(
      title: const Center(
          child: Text(
        "Statistics",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )),
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
              itemCount: 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("$item"),
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
            _comments.addComments(widget.pokemonURL, _commentController.text);
            _commentController.clear();
            // Navigator.of(context).pop(_commentController.text);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
