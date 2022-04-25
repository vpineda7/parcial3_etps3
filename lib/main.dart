import 'dart:convert';
import 'package:fluteeapps/modelos/StarWarsObject.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(WebFlutter());
}

class WebFlutter extends StatefulWidget {
  @override
  State<WebFlutter> createState() => _WebFlutterState();
}

class _WebFlutterState extends State<WebFlutter> {
  late Future<List<StarWarsObject>> _listadoStarWarsObject;

  Future<List<StarWarsObject>> _getStarWarsObject() async {
    final response = await http.get(Uri.parse("https://swapi.dev/api/people/"));
    String cuerpo;
    List<StarWarsObject> lista = [];

    if (response.statusCode == 200) {
      print(response.body);
      cuerpo = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(cuerpo);
      for (var item in jsonData["results"]) {
        lista.add(StarWarsObject(item["name"], item["skin_color"], item["birth_year"], 
                                item["url"], "https://starwars-visualguide.com/assets/img/characters/"+item["url"].replaceAll(new RegExp(r'[^0-9]'),'')+".jpg"));
        //print(item["url"].replaceAll(new RegExp(r'[^0-9]'),'')); 
        //print("https://starwars-visualguide.com/assets/img/characters/"+item["url"].replaceAll(new RegExp(r'[^0-9]'),'')+".jpg");
        //source images: "https://starwars-visualguide.com/#/"
      }
    } else {
      throw Exception("Falla en conexion  estado 500");
    }
    return lista;
  }

  @override
  void initState() {
    super.initState();
    _listadoStarWarsObject = _getStarWarsObject();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: _listadoStarWarsObject,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listadoStarWarsObjects(snapshot.data),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Error");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consumo Webservice',
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.auto_awesome_sharp)
            ),
            title: Text('StartWars People API'),
          ),
          //body: //futureBuilder),
          body: new Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //search box
                Padding(

                  padding: const EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 5),
                  child: TextField(                    
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true, 
                      fillColor: Color.fromRGBO(239, 241, 231, 1),
                      prefixIconColor:Colors.white,//Color.fromRGBO(239, 241, 231, 1) ,  
                      hintText: 'Buscar',
                      prefixIcon: Icon(Icons.search)
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: futureBuilder,
                ),
                // Expanded(
                //   flex: 2,
                //   child: Text("hello"),
                //   ),

              ],
            );
        }
      )
    )
    );
  }

  List<Widget> _listadoStarWarsObjects(data) {
    List<Widget> startwarsObject = [];
    for (var itempk in data) {
      startwarsObject.add(Card(
        elevation: 2.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Text(itempk.num),
            SizedBox(height:20),
            Container(
              padding: EdgeInsets.all(2.0),
              height: 250,
              width: 200,
               decoration: BoxDecoration(
                 image: DecorationImage(
                     image: NetworkImage(itempk.img),
                     fit: BoxFit.cover),
               ),
            ),
            SizedBox(height:10),
            Text("Nombre:" + itempk.name),
            SizedBox(height:5),
            Text("Color de piel: " + itempk.skin_color),
            SizedBox(height:5),
            Text("Año de nacimiento: " + itempk.birth_year),
            SizedBox(height:15),
          ],
        ),
      ));
    }
    return startwarsObject;
  }
}
