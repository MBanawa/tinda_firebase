import 'package:flutter/material.dart';
import 'package:tinda/animation/FadeAnimation.dart';
import 'package:tinda/providers/image/cached_image_provider.dart';
import 'package:tinda/screens/itemDetail_screen.dart';
import 'package:tinda/widgets/itemBuilder/options_dialog.dart';
import 'package:tinda/widgets/shared-widgets/images/cached_image.dart';

Color fontColor = Colors.white;

class MakeItem extends StatelessWidget {
  final String id;
  final String createdAt;
  final String category;
  final String categoryId;
  final String barcode;
  final String itemName;
  final String quantity;
  final String image;
  final String buyDate;
  final String supplier;
  final String buyPrice;
  final String sellPrice;

  MakeItem({
    @required this.id,
    @required this.createdAt,
    @required this.category,
    @required this.categoryId,
    @required this.barcode,
    @required this.itemName,
    @required this.quantity,
    @required this.image,
    @required this.buyDate,
    @required this.supplier,
    @required this.buyPrice,
    @required this.sellPrice,
  });

  _optionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return OptionsDialog(
            id: id,
            category: category,
            barcode: barcode,
            itemName: itemName,
            quantity: quantity,
            image: image,
            buyDate: buyDate,
            supplier: supplier,
            buyPrice: buyPrice,
            sellPrice: sellPrice,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: itemName,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetail(
                        id: id,
                        category: category,
                        barcode: barcode,
                        itemName: itemName,
                        quantity: quantity,
                        image: image,
                        buyDate: buyDate,
                        supplier: supplier,
                        buyPrice: buyPrice,
                        sellPrice: sellPrice,
                      )));
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  )
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedImageWidget(
                  url: image,
                  quality: 70,
                  customPathList: ['items', id],
                  boxFit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.teal,
                    BlendMode.modulate,
                  ),
                  height: 250,
                  width: double.infinity,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                // image: DecorationImage(
                //   image: CachedImageProvider(
                //     image,
                //     quality: 70,
                //     customPathList: ['items', id],
                //   ),
                //   fit: BoxFit.cover,
                //   colorFilter: ColorFilter.mode(
                //     Colors.teal,
                //     BlendMode.modulate,
                //   ),
                // ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeAnimation(
                              0.5,
                              Text(
                                'In Stock: $quantity',
                                style: TextStyle(
                                    color: fontColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FadeAnimation(
                              .6,
                              Text(
                                'Buy Price: PHP ${double.parse(buyPrice).toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: fontColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
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
                        ),
                      )
                    ],
                  ),
                  FadeAnimation(
                    0.7,
                    Text(
                      itemName,
                      style: TextStyle(
                        color: fontColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
