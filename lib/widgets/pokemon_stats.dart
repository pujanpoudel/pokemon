import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/providers/pokemon_data_providers.dart';
import 'package:test/services/database_service.dart'; // Import your DatabaseService

class PokemonStatsCard extends ConsumerStatefulWidget {
  final String pokemonURL;

  const PokemonStatsCard({super.key, required this.pokemonURL});

  @override
  _PokemonStatsCardState createState() => _PokemonStatsCardState();
}

class _PokemonStatsCardState extends ConsumerState<PokemonStatsCard> {
  final TextEditingController _commentController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = false;

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

    return SingleChildScrollView(
      child: AlertDialog(
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
              loading: () =>
                  const CircularProgressIndicator(color: Colors.white),
            ),
            SizedBox(
              child: Column(children: []),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : TextField(
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
              Navigator.of(context).pop(_commentController.text);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
