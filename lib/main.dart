import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
      );
  }
}


// this class creates its State class
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}


// create a stateful widget to be able to change content
class RandomWordsState extends State<RandomWords> {
  @override
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>(); // This saves the state of the Name
  final _biggerFont = const TextStyle(fontSize: 18.0);

    // This builds an infinite list
    Widget _buildSuggestions() {
      return ListView.builder(
        padding: const EdgeInsets.all(6.0),
        itemBuilder: /*1*/ (context, i) {
          final index = i; /*3*/

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
    }

    Widget _buildRow(WordPair pair) {
      final bool alreadySaved = _saved.contains(pair);
      return Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
              trailing: Icon(   // Add the lines from here...
                alreadySaved ? Icons.star : Icons.star_border,
                color: alreadySaved ? Colors.yellow : null,
              ),
              onTap: () {      // Interactive event
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                });
              },
            ),
          ]
        ),
      );
    }

    void _pushSaved() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _saved.map(
                  (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );
            final List<Widget> divided = ListTile
                .divideTiles(
              context: context,
              tiles: tiles,
            )
                .toList();

            // Creates a new Scaffold/Window
            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'),
              ),
              body: ListView(children: divided),
            );
          },

        ),
      );
    }
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.star), onPressed: _pushSaved),
          ],
          title: Text('Startup Name Generator'),

        ),
        body: _buildSuggestions(),
      );
    }
}
