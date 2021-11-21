import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Basic Phrases';

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class AudioTileInformation {
  AudioTileInformation(this.phrase, this.foreignLanguage, this.originalAudioPath, this.foreignAudioPath);

  final String phrase;
  final String foreignLanguage;
  final String originalAudioPath;
  final String foreignAudioPath;
}

class AudioTile {
  AudioTile(this.text, this.audioPath);

  static AudioCache player = AudioCache();

  final String text;
  final String audioPath;

  void onTap() {
    player.play(audioPath);
  }
}

final List<AudioTileInformation> tileInformation = <AudioTileInformation>[
  AudioTileInformation('bună ziua', 'franceză', 'buna_ziua.mp3', 'buna_ziua_fra.mp3'),
  AudioTileInformation('aș dori un sandviș', 'italiană', 'as_dori_un_sandvis.mp3', 'as_dori_un_sandvis_ita.mp3'),
  AudioTileInformation('cât costă o pâine?', 'maghiară', 'cat_costa_o_paine.mp3', 'cat_costa_o_paine_hun.mp3'),
  AudioTileInformation('mi-e foame', 'germană', 'mi-e_foame.mp3', 'mi-e_foame_ger.mp3'),
  AudioTileInformation('hai la restaurant', 'suedeză', 'hai_la_restaurant.mp3', 'hai_la_restaurant_swe.mp3'),
].toList();

List<AudioTile> _generateAudioTiles(AudioTileInformation info) {
  final String phrase = info.phrase;
  final String foreignTileText = '$phrase (${info.foreignLanguage})';

  return <AudioTile>[
    AudioTile(phrase, info.originalAudioPath),
    AudioTile(foreignTileText, info.foreignAudioPath),
  ];
}

class _MyHomePageState extends State<MyHomePage> {
  List<AudioTile> audioTiles = tileInformation
      .map((AudioTileInformation tileInfo) => _generateAudioTiles(tileInfo))
      .expand((List<AudioTile> tiles) => tiles)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 30.0,
          crossAxisSpacing: 20.0,
        ),
        itemCount: audioTiles.length,
        itemBuilder: (BuildContext context, int index) {
          final AudioTile tile = audioTiles[index];

          return GestureDetector(
            onTap: tile.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: <MaterialAccentColor>[Colors.blueAccent, Colors.lightBlueAccent],
                  stops: <double>[0.6, 1],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    tile.text,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
