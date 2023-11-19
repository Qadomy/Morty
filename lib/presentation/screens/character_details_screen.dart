import 'package:flutter/material.dart';
import 'package:untitled/data/models/character.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({super.key, required this.character});

  buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.grey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.name,
          style: const TextStyle(color: Colors.white),
        ),
        background: Hero(
          tag: character.id,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  buildDivider(double endIndent) {
    return Divider(
      height: 30,
      endIndent: endIndent,
      color: Colors.yellow,
      thickness: 2,
    );
  }

  String getStringAfterLastSlash(String input) {
    List<String> parts = input.split('/');
    return parts.isNotEmpty ? parts.last : input;
  }

  @override
  Widget build(BuildContext context) {
    List<String> numbersAfterLastSlash =
        character.episode.map((url) => getStringAfterLastSlash(url)).toList();

    // BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: Colors.grey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo('Species : ', character.species),
                      buildDivider(315),
                      characterInfo('Gender : ', character.gender),
                      buildDivider(250),
                      characterInfo(
                          'Episode : ', numbersAfterLastSlash.join(' / ')),
                      buildDivider(280),
                      characterInfo('Status : ', character.status),
                      buildDivider(300),
                      character.type.isEmpty
                          ? Container()
                          : characterInfo('Type : ', character.type),
                      character.type.isEmpty ? Container() : buildDivider(150),
                      characterInfo('Created Date : ',
                          "${character.created.year}-${character.created.month}-${character.created.day}"),
                      buildDivider(235),
                      const SizedBox(
                        height: 20,
                      ),
                      // BlocBuilder<CharactersCubit, CharactersState>(
                      //   builder: (context, state) {
                      //     return checkIfQuotesAreLoaded(state);
                      //   },
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 500,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
