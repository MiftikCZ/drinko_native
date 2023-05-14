import 'package:dynamic_color/dynamic_color.dart';

import 'package:flutter/material.dart';
import 'components/add_sklenicka_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Drinko native',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const MainPageRoute(),
      );
    });
  }
}

class MainPageRoute extends StatefulWidget {
  const MainPageRoute({Key? key}) : super(key: key);

  @override
  _MainPageRouteState createState() => _MainPageRouteState();
}

class _MainPageRouteState extends State<MainPageRoute> {
  int goalInMl = 2000;
  int sklenickaObjemInMl = 400;
  int todayDrankInMl = 0;

  late SharedPreferences db;
  @override
  void initState() {
    super.initState();

    initPrefs();
  }

  String getTodayTime() {
    DateTime now = DateTime.now();
    return "${now.day}.${now.month}.${now.year}";
  }

  Future<void> initPrefs() async {
    db = await SharedPreferences.getInstance();

    if (db.getString("waterLastDate") != getTodayTime()) {
      db.setString("waterLastDate", getTodayTime());
      db.setInt("waterDrank", 0);
    }

    db.setInt("sklenickaObjem", db.getInt("sklenickaObjem") ?? 400);
    db.setInt("denniCil", db.getInt("denniCil") ?? 2000);

    setState(() {
      todayDrankInMl = db.getInt("waterDrank") ?? 0;
      sklenickaObjemInMl = db.getInt("sklenickaObjem") ?? 400;
      goalInMl = db.getInt("denniCil") ?? 2000;
    });
  }

  void addVoda(double howMuchInMl) async {
    int counter = (db.getInt('waterDrank') ?? 0) + howMuchInMl.toInt();

    db.setInt('waterDrank', counter).then((value) {
      setState(() {
        todayDrankInMl = counter;
      });
    });
  }

  void setSklenkaObjem(double howMuchInMl) async {
    int counter = howMuchInMl.toInt();

    db.setInt('sklenickaObjem', counter).then((value) {
      setState(() {
        sklenickaObjemInMl = counter;
      });
    });
  }

  void setDenniCil(double howMuchInMl) async {
    int counter = howMuchInMl.toInt();

    db.setInt('denniCil', counter).then((value) {
      setState(() {
        goalInMl = counter;
      });
    });
  }

  Widget CustomizeElButton(String appBarTitle, String inputHint,
      Function(double) setTheValue, String buttonText) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Scaffold(
                appBar: AppBar(title: Text(appBarTitle)),
                body: TextField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  onSubmitted: (val) {
                    setTheValue(double.parse(val));
                    Navigator.pop(context);
                  },
                  decoration: InputDecoration(
                      hintText: inputHint,
                      contentPadding: const EdgeInsets.all(16.0)),
                ));
          }));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(buttonText),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // Size sizeAppBarContext = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Scaffold(
                      appBar: AppBar(title: const Text("Přizpůsobit")),
                      body: Center(
                        child: Column(children: [
                          CustomizeElButton(
                              "Objem skleničky (ml)",
                              'Objem tvé skleničky v ML',
                              setSklenkaObjem,
                              "Objem skleničky"),
                          CustomizeElButton(
                              "Denní cíl (ml)",
                              'Denní cíl v ML (2L = 2000)',
                              setDenniCil,
                              "Denní cíl")
                        ]),
                      ));
                }));
              })),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Zbývá ti skleniček:",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                                  .withOpacity(0.5))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_drink,
                              size: 34,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                          Text(
                              " ${((((goalInMl - todayDrankInMl) / sklenickaObjemInMl) * 2).floor() / 2)}"
                                  .replaceAll(RegExp(r'\.0'), ""),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 34,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer)),
                        ],
                      )
                    ]),
              )),
          Expanded(
            child: GridView.count(
              childAspectRatio: 1.8,
              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 2,
              children: [
                DataInfoGridWidget(
                    hodnota: "$todayDrankInMl", goal: "${goalInMl}ml"),
                DataInfoGridWidget(
                    hodnota:
                        "${(((todayDrankInMl / sklenickaObjemInMl) * 2).round() / 2)}"
                            .replaceAll(RegExp(r'\.0'), ""),
                    goal:
                        "${(((goalInMl / sklenickaObjemInMl) * 2).round() / 2)}"
                            .replaceAll(RegExp(r'\.0'), "")),
                DataInfoGridWidget(
                  hodnota: "${((todayDrankInMl / goalInMl) * 100).round()}%",
                  goal: "",
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddSkelnickaRoute(
              addVodaInMl: addVoda,
              goalInMl: goalInMl,
              sklenkaObjem: sklenickaObjemInMl,
            );
          }));
        },
        tooltip: 'Zapsat',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DataInfoGridWidget extends StatelessWidget {
  final String hodnota;
  final String goal;
  const DataInfoGridWidget(
      {Key? key, required this.hodnota, required this.goal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          hodnota,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 26,
              fontWeight: FontWeight.w500),
        ),
        Text(goal != "" ? " / $goal" : "",
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant))
      ]),
    );
  }
}
