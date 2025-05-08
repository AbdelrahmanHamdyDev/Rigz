import 'package:flutter/material.dart';
import 'package:rigz/pageView.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rigz/bloc/Cart/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Supabase.initialize(
    url: dotenv.env['supaBase_Url']!,
    anonKey: dotenv.env['supabase_annonKey']!,
  );
  runApp(
    BlocProvider(
      create: (context) => productBloc(),
      child: MaterialApp(home: pageViewController()),
    ),
  );
}
