import 'package:flutter/material.dart';

class StarWarsObject {
  String name = "";
  String skin_color = "";
  String birth_year = "";
  String url = "";
  String img = "";
  

  StarWarsObject(name, skin_color, birth_year, url, img) {
    this.name = name;
    this.skin_color = skin_color;
    this.birth_year = birth_year;
    this.url = url;
    this.img = img;
  }
}
