import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rigz/Model/CartModel.dart';
import 'package:rigz/View/widget/imagePreview.dart';
import 'package:rigz/bloc/Cart/bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:decimal/decimal.dart';
import 'package:rigz/bloc/Cart/event.dart' as CartEvent;
import 'package:animated_flip_counter/animated_flip_counter.dart';

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
    Decimal discountPrice = Decimal.parse(
      (widget.product.price *
              (Decimal.fromInt(100) - widget.product.discount) /
              Decimal.fromInt(100))
          .toDecimal()
          .toStringAsFixed(2),
    );
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
                  effect: const ScrollingDotsEffect(),
                  onDotClicked: (index) {
                    setState(() {
                      _currentIMGIndex = index;
                    });
                    _carouselController.animateToPage(index);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: const BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      boxShadow: [
                        BoxShadow(blurRadius: 10, offset: Offset(-1, -1)),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Title
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //Description
                          Text(
                            widget.product.description,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedFlipCounter(
                                    duration: const Duration(milliseconds: 300),
                                    suffix: "  LE",
                                    textStyle: TextStyle(
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
                                    value:
                                        ((widget.product.price) *
                                                Decimal.fromInt(_cartQuantity))
                                            .toDouble(),
                                  ),

                                  if ((widget.product.discount !=
                                      Decimal.parse("0")))
                                    AnimatedFlipCounter(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      suffix: "  LE",
                                      textStyle: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      value:
                                          (discountPrice *
                                                  Decimal.fromInt(
                                                    _cartQuantity,
                                                  ))
                                              .toDouble(),
                                    ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //Counter
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(color: Color(0XFF1E1E1E)),
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (_cartQuantity > 1) {
                                                  _cartQuantity--;
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF5E5E5E),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 30),
                                          Text(
                                            _cartQuantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 30),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (_cartQuantity <
                                                    widget
                                                        .product
                                                        .stockAmount) {
                                                  _cartQuantity++;
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).hideCurrentSnackBar();
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "This is the maximum amount in the stock",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF5E5E5E),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    child: TextButton(
                                      onPressed: () {
                                        context.read<CartBloc>().add(
                                          CartEvent.Addproduct(
                                            CartModel(
                                              product: widget.product,
                                              quantity: _cartQuantity,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("Add To Cart"),
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
                padding: const EdgeInsets.all(15),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const AssetImage("assets/Discount.png"),
                  child: Text("${widget.product.discount}%"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
