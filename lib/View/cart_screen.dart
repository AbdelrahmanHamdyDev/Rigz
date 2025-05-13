import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rigz/View/widget/cartProduct_Widget.dart';
import 'package:rigz/bloc/Cart/bloc.dart';
import 'package:rigz/bloc/Cart/event.dart';
import 'package:rigz/bloc/Cart/state.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:rigz/bloc/Is_Sign/Cubit.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class cartScreen extends StatefulWidget {
  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> with WidgetsBindingObserver {
  bool _isButtonLocked = false;
  final _supabase = Supabase.instance.client;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> _checkOrderStatus() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;
      final response =
          await _supabase
              .from('orders')
              .select()
              .eq('user_id', userId)
              .order('create_at', ascending: false)
              .limit(1)
              .single();

      return response['status'] == 'success';
    } catch (e) {
      print('Error checking order status: $e');
      return false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final isPaymentSuccess = await _checkOrderStatus();
      if (isPaymentSuccess) {
        context.read<CartBloc>().add(ClearproductOrder());
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment is not completed")),
        );
        setState(() {
          _isButtonLocked = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<CartBloc>().add(ClearproductOrder());
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                //products
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: math.max(
                    MediaQuery.of(context).size.height / 6,
                    math.min(
                      (MediaQuery.of(context).size.height / 6) *
                          state.products.length,
                      MediaQuery.of(context).size.height / 1.5,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(12),
                      ),
                      depth: -20,
                      color: Colors.grey,
                    ),
                    child: ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder:
                          (context, index) => cartProduct_Widget(
                            productCart: state.products[index],
                          ),
                    ),
                  ),
                ),

                //pay button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child:
                      _isButtonLocked
                          ? const CircularProgressIndicator()
                          : BlocSelector<SignCubit, bool, bool>(
                            selector: (state) => state,
                            builder: (context, isSigned) {
                              return ConfirmationSlider(
                                text: "Slide to pay",
                                onConfirmation: () {
                                  setState(() {
                                    _isButtonLocked = true;
                                  });
                                  if (isSigned) {
                                    context.read<CartBloc>().add(
                                      PayproductOrder(),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Sign in Firstly"),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            },
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
