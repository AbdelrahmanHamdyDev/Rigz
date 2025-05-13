import 'package:flutter/material.dart';

/*
Card(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 10,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_cartQuantity > 1) {
                                                _cartQuantity--;
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text(
                                          _cartQuantity.toString(),
                                          style: const TextStyle(fontSize: 22),
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
                                                  const SnackBar(
                                                    content: Text(
                                                      "This is the maximum amount in the stock",
                                                    ),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
*/

class quantity extends StatefulWidget {
  const quantity({super.key, required this.stockAmount});

  final int stockAmount;

  @override
  State<quantity> createState() => _quantityState();
}

class _quantityState extends State<quantity> {
  int _counter = 0;
  bool _isAddIconPressed = false;
  bool _isRemoveIconPressed = false;

  void _incrementCounter() {
    setState(() {
      if (_counter < widget.stockAmount) {
        _counter++;
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This is the maximum amount in the stock"),
          ),
        );
      }
      _isAddIconPressed = true;
      _isRemoveIconPressed = false;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        _isAddIconPressed = false;
        _isRemoveIconPressed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Color(0XFF1E1E1E)),
          BoxShadow(offset: Offset(2, 2), blurRadius: 4),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _decrementCounter,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color:
                      _isRemoveIconPressed
                          ? const Color(0xFF00BAAB)
                          : const Color(0xFF5E5E5E),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Icon(Icons.remove, size: 10),
              ),
            ),
            const SizedBox(width: 30),
            Text(
              _counter.toString(),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(width: 30),
            GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color:
                      _isAddIconPressed
                          ? const Color(0xFF00BAAB)
                          : const Color(0xFF5E5E5E),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Icon(Icons.add, size: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
