import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';
import 'package:rick_and_morty_app/rickAndMortyApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await Hive.initFlutter();
  Hive.registerAdapter(CharacterModelAdapter());
  await Hive.openBox<CharacterModel>('favorites_box');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RickAndMortyApp(),
    );
  }
}