import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Words Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(title: "Random Words Generator",),
    );
  }
}

class RandomWords extends StatefulWidget {
  final String title;
  RandomWords({Key key, this.title}) : super(key: key);
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _wordList = <WordPair>[];
  final _saved = Set<WordPair>();

  Widget _buildRows(WordPair wordPair) {
    final alreadySaved = _saved.contains(wordPair);
    return ListTile(
        title: Text(
            wordPair.asPascalCase
        ),
        trailing: new Column(
            children: [
              new Container(
                child: new IconButton(
                    icon: new Icon(
                        alreadySaved ? Icons.favorite : Icons.favorite_border,
                        color: alreadySaved ? Colors.red : null),
                    onPressed: () {
                      setState(() {
                        if (alreadySaved)
                          _saved.remove(wordPair);
                        else
                          _saved.add(wordPair);
                      });
                    }
                ),
              )
            ]
        )
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _wordList.length) {
            _wordList.addAll(generateWordPairs().take(10));
          }
          return _buildRows(_wordList[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
          ],
        ),
        body: Center(
          child: _buildList(),
        )
    );
  }
  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              final tiles = _saved.map((WordPair pair) {
                return ListTile(
                  title: Text(pair.asPascalCase),
                );
              });
              final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();
              return Scaffold(
                appBar: AppBar(
                  title: Text("Favourites"),
                ),
                body: ListView(children: divided,),
              );
            }
        )
    );
  }
}
