import 'package:flutter/material.dart';
import 'package:tinda/animation/FadeAnimation.dart';
import 'package:tinda/widgets/itemBuilder/options_dialog.dart';

class ItemDetail extends StatefulWidget {
  final String id;
  final String category;
  final String barcode;
  final String itemName;
  final String quantity;
  final String image;
  final String buyDate;
  final String supplier;
  final String buyPrice;
  final String sellPrice;

  ItemDetail({
    @required this.id,
    @required this.category,
    @required this.barcode,
    @required this.itemName,
    @required this.quantity,
    @required this.image,
    @required this.buyDate,
    @required this.supplier,
    @required this.buyPrice,
    @required this.sellPrice,
  });

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  //TODO: ItemProvider??
  _optionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return OptionsDialog(
            id: widget.id,
            category: widget.category,
            barcode: widget.barcode,
            itemName: widget.itemName,
            quantity: widget.quantity,
            image: widget.image,
            buyDate: widget.buyDate,
            supplier: widget.supplier,
            buyPrice: widget.buyPrice,
            sellPrice: widget.sellPrice,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Hero(
          tag: widget.itemName,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400],
                  blurRadius: 10,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: Stack(
              //TODO: menu to ask how many stocks before alerting / adding to grocery list
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _optionsDialog(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow.shade900),
                          child: Center(
                            child: Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  child: FadeAnimation(
                    .5,
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.teal.shade900.withOpacity(.9),
                            Colors.teal.shade900.withOpacity(.0),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeAnimation(
                            0.6,
                            Text(
                              widget.itemName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 6),
                          FadeAnimation(
                            0.7,
                            Text(
                              'In Stock:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          FadeAnimation(
                            0.8,
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 20),
                              child: Center(
                                child: Text(
                                  widget.quantity,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
