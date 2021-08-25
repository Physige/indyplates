import "package:flutter/material.dart";
import 'plates.dart';
/* TODO:
- clean up code
- clean up fonts
- comment
- filter
- to top
- save selections
- add animations
*/
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchController = TextEditingController();

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
                child: Padding(
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
                            Plates.searchList =
                              Plates.nameList
                              .where((element) => element["name"].toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                          });
                        },
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          hintStyle: TextStyle(
                            fontFamily: "Segoe UI",
                            fontWeight: FontWeight.w700,
                            color: Color(0xff715656)
                          ),
                          hintText: "Search",
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
              padding: const EdgeInsets.all(15),
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
                  });
                },
                // animated container allows for fade on border
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      // checks if plate is in the selected plate list, if so, set the border to green, if not, set it transparent
                      color: Plates.selectedPlates.contains(getPlate("name", index)) ? Colors.green[500] : Colors.transparent,
                      width: 12,
                    ),
                    borderRadius: BorderRadius.circular(45),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        blurRadius: 15,
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
                        width: 160,
                        height: 80,
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
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          // plate name
                          // builder loops through all names and displays plate name
                          getPlate("name", index),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff715656),
                            fontSize: 18,
                            fontFamily: "Segoe UI",
                            fontWeight: FontWeight.w700,
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
                              fontSize: 16,
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


