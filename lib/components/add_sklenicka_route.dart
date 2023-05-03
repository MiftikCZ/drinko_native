import "package:flutter/material.dart";

class AddSkelnickaRoute extends StatelessWidget {
  ValueSetter<double> addVodaInMl = (double value) {};
  int goalInMl = 2000;
  int sklenkaObjem = 300;
  AddSkelnickaRoute(
      {Key? key,
      required this.addVodaInMl,
      required this.goalInMl,
      required this.sklenkaObjem})
      : super(key: key);

  Widget AddVodaButton(BuildContext context, double valueInInt, String? label,
      bool showCupIcon) {
    return ElevatedButton(
        onPressed: () {
          addVodaInMl(valueInInt);
          Navigator.of(context).pop();
        },
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label ?? "${valueInInt}ml",
                  style: const TextStyle(fontSize: 26)),
              showCupIcon
                  ? const Icon(Icons.local_drink, size: 26)
                  : Container()
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Přidat")),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddVodaButton(context, sklenkaObjem.toDouble(), "1 ", true),
                AddVodaButton(context, sklenkaObjem / 2, "1/2 ", true),
                AddVodaButton(context, 100, "100 ml", false),
                AddVodaButton(context, sklenkaObjem / -2, "-1/2 ", true)
              ]),
        ));
  }
}
