import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/business_logic/cubit/characters_cubit.dart';

import '../../data/models/character.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedForCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading:
            _isSearching ? const BackButton(color: Colors.black) : Container(),
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body: buildBlocWidget(),
    );
  }

  _buildAppBarTitle() {
    return const Text(
      'Characters',
      style: TextStyle(color: Colors.black),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear, color: Colors.black),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(Icons.search, color: Colors.black),
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        hintText: 'Find a character...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }

  addSearchedForItemsToSearchedList(String searchedCharacter) {
    searchedForCharacters = allCharacters
        .where((character) =>
        character.name.toLowerCase().contains(searchedCharacter.toLowerCase()))
        .toList();
    setState(() {});
  }

  buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharacterLoaded) {
        allCharacters = (state).characters;
        return _buildLoadedListWidget();
      } else {
        return _buildLoadingIndicator();
      }
    });
  }

  _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 5),
    );
  }

  _buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey,
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _searchTextController.text.isEmpty
                  ? allCharacters.length
                  : searchedForCharacters.length,
              itemBuilder: (context, index) {
                final character = _searchTextController.text.isEmpty
                    ? allCharacters[index]
                    : searchedForCharacters[index];
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  padding: const EdgeInsetsDirectional.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    // onTap: () => Navigator.pushNamed(context, characterDetailsScreen , arguments: character),
                    child: GridTile(
                      footer: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        color: Colors.black54,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          character.name,
                          style: const TextStyle(
                            height: 1.3,
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      child: Hero(
                        tag: character.id,
                        child: Container(
                          color: Colors.grey,
                          child: character.image.isNotEmpty
                              ? FadeInImage.assetNetwork(
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: 'assets/loading.gif',
                                  image: character.image,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset('assets/placeholder.jpeg'),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
