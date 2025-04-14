import 'package:carousel_slider/carousel_slider.dart';
import 'package:rigz/View/widget/imagePreview.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:decimal/decimal.dart';

class productDetail_Screen extends StatefulWidget {
  productDetail_Screen({super.key, required this.product});

  final productModel product;

  @override
  State<productDetail_Screen> createState() => _productDetail_ScreenState();
}

class _productDetail_ScreenState extends State<productDetail_Screen> {
  Color _background_Color = Colors.white;
  int _cartQuantity = 1;
  int _currentIMGIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  Future<void> _getBackgroundColor() async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.product.imageUrl[0]),
      size: const Size(200, 100),
    );

    setState(() {
      _background_Color =
          generator.dominantColor?.color ??
          Theme.of(context).colorScheme.surface;
    });
  }

  @override
  void initState() {
    super.initState();
    _getBackgroundColor();
  }

  Widget imageViewerWidget(int index) {
    return Image.network(
      widget.product.imageUrl[index],
      fit: BoxFit.contain,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    Decimal discountPrice =
        (widget.product.price *
                (Decimal.fromInt(100) - widget.product.discount) /
                Decimal.fromInt(100))
            .toDecimal();
    return Scaffold(
      backgroundColor: _background_Color,

      body: SafeArea(
        child: Stack(
          children: [
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: widget.product.imageUrl.length,
              itemBuilder: (context, index, realIndex) {
                return InkWell(
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => imagePreview(
                                imageUrl: widget.product.imageUrl[index],
                              ),
                        ),
                      ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: widget.product.imageUrl[index],
                          child: imageViewerWidget(index),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                _background_Color.withAlpha(80),
                                _background_Color,
                              ],
                              stops: [0.6, 0.8, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 2.5,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIMGIndex = index;
                  });
                },
              ),
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 2.5),
                AnimatedSmoothIndicator(
                  activeIndex: _currentIMGIndex,
                  count: widget.product.imageUrl.length,
                  effect: ScrollingDotsEffect(),
                  onDotClicked: (index) {
                    setState(() {
                      _currentIMGIndex = index;
                    });
                    _carouselController.animateToPage(index);
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(-1, -1),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Title
                          Text(
                            widget.product.title,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //Description
                          Text(widget.product.description),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${(widget.product.price) * Decimal.fromInt(_cartQuantity)} £",
                                    style: TextStyle(
                                      fontSize:
                                          (widget.product.discount !=
                                                  Decimal.parse("0"))
                                              ? 25
                                              : 30,
                                      decoration:
                                          (widget.product.discount !=
                                                  Decimal.parse("0"))
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                  if ((widget.product.discount !=
                                      Decimal.parse("0")))
                                    Text(
                                      "${discountPrice * Decimal.fromInt(_cartQuantity)} £",
                                      style: TextStyle(fontSize: 32),
                                    ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //Counter
                                  Card(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 20,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_cartQuantity > 1) {
                                                _cartQuantity--;
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        Text(
                                          _cartQuantity.toString(),
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_cartQuantity <=
                                                  widget.product.stockAmount) {
                                                _cartQuantity++;
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).hideCurrentSnackBar();
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "This is the maximum amount in the stock",
                                                    ),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text("Add To Cart"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.product.discount != Decimal.parse("0"))
              Padding(
                padding: EdgeInsets.all(15),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/Discount.png"),
                  child: Text("${widget.product.discount}%"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
