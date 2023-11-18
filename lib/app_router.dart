import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/business_logic/cubit/characters_cubit.dart';
import 'package:untitled/data/repository/characters_repository.dart';
import 'package:untitled/data/web_services/character_web_services.dart';
import 'package:untitled/presentation/screens/character_details_screen.dart';
import 'package:untitled/presentation/screens/characters_screen.dart';
import 'package:untitled/strings.dart';

class AppRouter {
  late CharacterRepository characterRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    characterRepository = CharacterRepository(CharacterWebServices());
    charactersCubit = CharactersCubit(characterRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      /// characterScreen
      case characterScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                CharactersCubit(characterRepository),
            child: const CharactersScreen(),
          ),
        );

      /// characterDetailsScreen
      case characterDetailsScreen:
        return MaterialPageRoute(
            builder: (_) => const CharacterDetailsScreen());
    }
    return null;
  }
}
