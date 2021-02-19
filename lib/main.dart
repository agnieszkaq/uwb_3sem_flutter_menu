import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<List<Meal>> _getMeals() async {
  var file = await DefaultCacheManager().getSingleFile('https://gist.githubusercontent.com/agnieszkaq/0494fbde7633ae4293129a9f0dad74e8/raw/a97182f683aa8e144da9c17621018a6cd8f18613/flutter_menu.json');
  List<Meal> meals;
  if (file != null && await file.exists()) {
    var res = await file.readAsString();
    meals = (json.decode(res) as List)
        .map((i) => Meal.fromJson(i))
        .toList();
    return meals;
  }
}


class Meal {
  String picture;
  Description description;
  String ingredients;
  int price;
  Calories calories;
  String name;

  Meal(
      {this.picture,
      this.description,
      this.ingredients,
      this.price,
      this.calories,
      this.name});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
        name: json['name'],
        ingredients: json['ingredients'],
        price: json['price'],
        picture: json['picture'],
        description: json['description'] != null
            ? new Description.fromJson(json['description'])
            : null,
        calories: json['calories'] != null
            ? new Calories.fromJson(json['calories'])
            : null);
  }
}
class Description {
  String shortDesc;
  String longDesc;

  Description({this.shortDesc, this.longDesc});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
        shortDesc: json['shortDesc'], longDesc: json['longDesc']);
  }
}
class Calories {
  int carb;
  int protein;
  int fat;
  int cal;

  Calories({this.carb, this.protein, this.fat, this.cal});

  factory Calories.fromJson(Map<String, dynamic> json) {
    return Calories(
        cal: json['cal'],
        carb: json['carb'],
        fat: json['fat'],
        protein: json['protein']);
  }
}

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Meal>> futureMeal;
  @override
  void initState() {
    super.initState();
    futureMeal = _getMeals();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Bar',
      theme: ThemeData(
        primaryColor: Colors.brown[300],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'FastFood Menu',
            style: TextStyle(fontFamily: 'Lobster', fontSize: 37.0),
          ),
        ),
        body: Center(
          child: FutureBuilder(
              future: _getMeals(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(snapshot.data);
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            leading: CircleAvatar(
                              radius: 35.0,
                              backgroundImage: new CachedNetworkImageProvider(
                                  snapshot.data[index].picture),
                            ),
                            title: Text(
                                snapshot.data[index].name +
                                    ': ' +
                                    snapshot.data[index].price.toString() +
                                    'PLN',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    letterSpacing: 0.5,
                                    color: Colors.orangeAccent,
                                    fontFamily: 'Lobster')),
                            subtitle: Text(
                              snapshot.data[index].description.shortDesc,
                              style: TextStyle(fontFamily: 'Lobster'),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(snapshot.data[index])));
                            });
                      });
                }
                ;
              }),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Meal meal;

  DetailPage(this.meal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name,
            style: TextStyle(fontFamily: 'Lobster', fontSize: 34.0)),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Card(
            shadowColor: Colors.grey,
            elevation: 20,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(26.0),
              child: Column(
                children: [
                  Ink.image(
                    alignment: Alignment.center,
                    image: new CachedNetworkImageProvider(meal.picture),
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    meal.description.longDesc,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lobster',
                      color: Colors.brown[300],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
          Card(
            shadowColor: Colors.grey,
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orangeAccent[100], Colors.deepOrangeAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      'składniki: '+ '\n'+ meal.ingredients,
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Pacifico',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
          Card(
            shadowColor: Colors.grey,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown, Colors.brown[900]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kalorie: ' +
                          meal.calories.cal.toString() +
                          '\n' +
                          'Węglowodany: ' +
                          meal.calories.carb.toString() +
                          '\n'
                              'Tłuszcz: ' +
                          meal.calories.fat.toString() +
                          '\n'
                              'Białko: ' +
                          meal.calories.protein.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Lobster',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
