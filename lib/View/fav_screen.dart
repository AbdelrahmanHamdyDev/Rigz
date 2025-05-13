import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rigz/View/Products_Screen.dart';
import 'package:rigz/bloc/Fav/bloc.dart';
import 'package:rigz/bloc/Fav/event.dart';
import 'package:rigz/bloc/Fav/state.dart';

class favScreen extends StatelessWidget {
  const favScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<FavBloc>().add(ClearFavList());
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: BlocBuilder<FavBloc, FavState>(
        builder: (context, state) {
          return Products_Screen(title: "Favorites", products: state.products);
        },
      ),
    );
  }
}
