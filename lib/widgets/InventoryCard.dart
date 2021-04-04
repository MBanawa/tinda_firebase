import 'package:flutter/material.dart';
import 'package:tinda/screens/itemsPerCategory_screen.dart';
import 'package:tinda/widgets/menuItem.dart';

class InventoryCard extends StatelessWidget {
  final String categID;
  final String categName;
  final String categDescription;
  final int categColor;
  final Function onMenuItemSelected;

  InventoryCard({
    @required this.categID,
    @required this.categName,
    @required this.categDescription,
    @required this.categColor,
    @required this.onMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
      elevation: 3,
      child: InkWell(
        splashColor: Colors.teal.withAlpha(80),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ItemsPerCategory(categID)));
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                width: 6,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4)),
                  color: Color(categColor == null ? 0xff008080 : categColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categName,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.teal.shade800,
                            ),
                          ),
                          Text(
                            '$categDescription',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.orange.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                        onSelected: onMenuItemSelected,
                        itemBuilder: (BuildContext context) {
                          return menuitems.map((MenuItem menuItem) {
                            return PopupMenuItem(
                              value: menuItem,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(menuItem.iconVal),
                                  Text(menuItem.menuVal),
                                ],
                              ),
                            );
                          }).toList();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
