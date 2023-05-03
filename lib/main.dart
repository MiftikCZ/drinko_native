import 'package:dynamic_color/dynamic_color.dart';

import 'package:flutter/material.dart';
import 'components/add_sklenicka_route.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
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

  void addVoda(double howMuchInMl) {
    setState(() {
      todayDrankInMl += howMuchInMl.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 200,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
          ),
          title: Container(
            height: 200,
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  verticalDirection: VerticalDirection.down,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Dnes jsi vypil skleniček:",
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_drink,
                            size: 34,
                            color: Theme.of(context).colorScheme.secondary),
                        Text(
                            " %1/%2 "
                                .replaceAll(
                                    "%1",
                                    (((todayDrankInMl / sklenickaObjemInMl) * 2)
                                                .round() /
                                            2)
                                        .toString())
                                .replaceAll(
                                    "%2",
                                    (((goalInMl / sklenickaObjemInMl) * 2)
                                                .round() /
                                            2)
                                        .toString()),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 34,
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                      ],
                    )
                  ]),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          MainPageInfoContainer(
            nadpis_: "Zatím jsi vypil",
            child_: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(children: [
                    Text("$todayDrankInMl ml",
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text("/ ${goalInMl.toString()} ml")
                  ]),
                  Row(children: [
                    Text("${todayDrankInMl / 1000} litrů",
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text("/ ${(goalInMl / 1000).toString()} litrů")
                  ])
                ]),
          ),
          const Divider(),
          MainPageInfoContainer(
            nadpis_: "Musíš vypít ještě",
            child_: todayDrankInMl >= goalInMl
                ? const Text("Dnes máš vypito!")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        Row(
                          children: [
                            Text((goalInMl - todayDrankInMl).toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            const Text(" ml")
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                ((goalInMl - todayDrankInMl) / 1000).toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            const Text(" litrů")
                          ],
                        ),
                      ]),
          )
        ]),
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

class HeaderInfoText extends StatelessWidget {
  final String text;
  const HeaderInfoText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 20));
  }
}

class MainPageInfoContainer extends StatelessWidget {
  final Widget? child_;
  final String? nadpis_;
  const MainPageInfoContainer({Key? key, this.child_, this.nadpis_})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(nadpis_ ?? "něco víc",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          DefaultTextStyle(
              style: TextStyle(
                  fontSize: 22, color: Theme.of(context).colorScheme.onSurface),
              child: child_ ?? const Text("?"))
        ]);
  }
}
