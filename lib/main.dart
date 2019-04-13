import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokemon/pokemon.dart';
import 'package:pokemon/pokemondetail.dart';





void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon',
      theme: ThemeData(
      primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pokemon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,this.title}):super(key:key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var url =  "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  PokeHub pokeHub;
  @override
  void initState() {
      fetchData();
      super.initState();

    }
  fetchData() async{
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub==null
      ?Center(child: CircularProgressIndicator())
      :GridView.count(
        crossAxisCount: 2,
        children: pokeHub.pokemon.map((poke)=>Padding(
          padding: EdgeInsets.all(4.0),
          child: InkWell(
           onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PokeDetail(
                            pokemon: poke,
                      )));
            },
            child:Hero(
              tag: poke.img,
              child:Card(
              elevation: 3.0,
              // color: Colors.blueAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(poke.img)
                      )
                    ),
                  ),
                  Text(
                    poke.name,
                    style:TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    )
                    )
                ],
              ),
            ),
            ),
            )
          )).toList()
        ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'refresh',
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
