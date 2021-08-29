import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'plates.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // runs on start
  @override
  void initState() {
    super.initState();

    // gets saved list of selected plates
    _readPlates();
  }

  TextEditingController _searchController = TextEditingController();

  // pulls saved plates list from shared prefs
  _readPlates() async {
    final prefs = await SharedPreferences.getInstance();

    // updates selected plates list
    Plates.selectedPlates = prefs.getStringList("savedPlates") ?? 0;

    // updates state once plates load
    setState(() {});
  }

  // adds updated selected plates list to shared prefs
  _savePlates() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("savedPlates", Plates.selectedPlates);
  }

  // returns proper plate info based off appropriate list
  String getPlate(info, index) {
    if (_searchController.text.isNotEmpty) {
      // if user is searching something, use search list
      switch(info) { 
        case "name": {return Plates.searchList[index]["name"];} 
        break; 
      
        case "type": {return Plates.searchList[index]["type"];} 
        break; 
      
        case "img": {return Plates.searchList[index]["img"];} 
        break; 
      } 
    }else {
      // else use regular list
      switch(info) { 
        case "name": {return Plates.nameList[index]["name"];} 
        break; 
      
        case "type": {return Plates.nameList[index]["type"];} 
        break; 
      
        case "img": {return Plates.nameList[index]["img"];} 
        break; 
      } 
    }
    return("error");
  }

  // sorts the plates list of maps
  void sort(method) {
    // updates display after nameList is sorted
    setState(() {
      if (method == "AZ") {
        // sorts by abc
        Plates.nameList.sort((a, b) => a["name"].compareTo(b["name"]));
      } else if (method == "ZA") {
        // sorts by cba
        Plates.nameList.sort((b, a) => a["name"].compareTo(b["name"]));
      } else if (method == "SlecUnslec") {
        // sorts selected at top and unselected at bottom
        // loops through nameList, if its in the selectedList, move to top of nameList
        for (int i = 0; i < Plates.nameList.length; i++) {
          if (Plates.selectedPlates.contains(Plates.nameList[i]["name"])) {
            // moves plate to top
            Map currPlate = Plates.nameList[i];
            Plates.nameList.removeAt(i);
            Plates.nameList.insert(0, currPlate);
          }
        }
      } else if (method == "UnslecSlec") {
        // sorts unselected at top and selected at bottom
        // loops through nameList, if its not in the selectedList, move to top of nameList
        for (int i = 0; i < Plates.nameList.length; i++) {
          if (!Plates.selectedPlates.contains(Plates.nameList[i]["name"])) {
            // moves plate to top
            Map currPlate = Plates.nameList[i];
            Plates.nameList.removeAt(i);
            Plates.nameList.insert(0, currPlate);
          }
        }
      }
    });
  }

  // alert dialong that contains filter selections
  void showFilterMenu(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Filter by:"),
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            TextButton(
              child: Text(
                "A → Z",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xffff8080)
                ),
              ),
              onPressed: () {
                sort("AZ");
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text(
                "Z → A",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xffff8080)
                ),
              ),
              onPressed: () {
                sort("ZA");
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text(
                "Unselected → Selected",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xffff8080)
                ),
              ),
              onPressed: () {
                sort("UnslecSlec");
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text(
                "Selected → Unselected",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xffff8080)
                ),
              ),
              onPressed: () {
                sort("SlecUnslec");
                Navigator.pop(context, false);
              },
            ),
          ],
        )
      )
    );

    // shows the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F2F2),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xffF7F2F2),
              bottom: PreferredSize(
                // app bar height
                preferredSize: Size.fromHeight(200),
                child: Column(
                  children: [
                    // plate counter
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:[
                        SizedBox(
                          height: 100,
                          child: Text(
                            // number left - takes length of namelist and subtracts the length of selected
                            (Plates.nameList.length - Plates.selectedPlates.length).toString(),
                            // "1",
                            // "10",
                            // "100",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xffff8080),
                              fontSize: 70,
                              fontFamily: "Segoe UI",
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 45),
                        SizedBox(
                          height: 47,
                          child: Text(
                            // license plate text - changes plural to singular if 1 left
                            Plates.selectedPlates.length == Plates.nameList.length - 1 ? "License Plate Left" : "License Plates Left",
                            style: TextStyle(
                              color: Color(0xff705656),
                              fontSize: 25,
                              fontFamily: "Segoe UI",
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF5EBEB),
                            borderRadius: BorderRadius.circular(30),
                          ),

                          // search bar
                          child: TextField(
                            // search logic
                            onChanged: (value) {
                              setState(() {
                                // loops through all name list, checks if name contains search, if so, add it to search list
                                // search list contains list of all plates that fit search query
                                Plates.searchList =
                                  Plates.nameList
                                  .where((element) => element["name"].toLowerCase()
                                  .contains(value.toLowerCase()))
                                  .toList();
                              });
                            },
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                fontFamily: "Segoe UI",
                                fontWeight: FontWeight.w700,
                                color: Color(0xff715656)
                              ),
                              // filter button
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.filter_alt_rounded,
                                  color: Color(0xff715656),
                                  size: 25,
                                ),
                                // opens the filter menu on pressed
                                onPressed: () {
                                  showFilterMenu(context);
                                },
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          )
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            )
          ];
        },
        
        // grid contains all plate cards
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2 / 2,
            crossAxisCount: 2
          ),
          itemCount: _searchController.text.isNotEmpty ? Plates.searchList.length : Plates.nameList.length,
          itemBuilder: (BuildContext ctx, index) {
            // each card
            return Padding(
              padding: const EdgeInsets.all(7),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // updates the selected plates list with clicking on plate
                    // checks if plate is already selected
                    if (Plates.selectedPlates.contains(getPlate("name", index))) {
                      // removes plate if already selected
                      Plates.selectedPlates.remove(getPlate("name", index));
                    }else {
                      // adds plate if not already selected
                      Plates.selectedPlates.add(getPlate("name", index));
                    }
                    
                    // whenever new plate is selected or removed, saves new plate list
                    _savePlates();
                  });
                },
                // animated container allows for fade on border
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      // checks if plate is in the selected plate list, if so, set the border to green, if not, set it transparent
                      color: Plates.selectedPlates.contains(getPlate("name", index)) ? Colors.green[500] : Colors.transparent,
                      width: 10,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        blurRadius: 16,
                        spreadRadius: -9,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Color(0xfffcf6f6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      // image
                      Container(
                        width: 120,
                        height: 60,
                        // image shadow
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image(
                          image: AssetImage("images/" + getPlate("img", index)),  
                        ),
                      ),
                      SizedBox(height: 15),
                      // name
                      // flexible lets text overflow
                      Flexible(
                        // scroll view lets overflowed text to scroll so you can see the entire name
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              // plate name
                              // builder loops through all names and displays plate name
                              getPlate("name", index),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff715656),
                                fontSize: 15,
                                fontFamily: "Segoe UI",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      // type
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          // plate type
                          // builder loops through all names and displays plate type
                          getPlate("type", index),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff715656),
                            fontSize: 12,
                            fontFamily: "Segoe UI",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      )
    );
  }
}


