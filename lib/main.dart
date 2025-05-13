import 'package:flutter/material.dart';
import 'package:rigz/bloc/Is_Sign/Cubit.dart';
import 'package:rigz/pageView.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rigz/bloc/Cart/bloc.dart';
import 'package:rigz/bloc/Fav/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Supabase.initialize(
    url: dotenv.env['supaBase_Url']!,
    anonKey: dotenv.env['supabase_annonKey']!,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => FavBloc()),
        BlocProvider(create: (context) => SignCubit()),
      ],
      child: MaterialApp(home: pageViewController()),
    ),
  );
}
