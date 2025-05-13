import 'package:decimal/decimal.dart';
import 'package:rigz/Model/CartModel.dart';
import 'package:rigz/ViewModel/paymob.dart';
import 'package:rigz/bloc/Cart/event.dart';
import 'package:rigz/bloc/Cart/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(products: [])) {
    on<Addproduct>((event, emit) {
      final updatedList = List<CartModel>.from(state.products);
      final index = updatedList.indexWhere(
        (item) => item.product.id == event.product.product.id,
      );
      if (index != -1) {
        add(IncrementproductOrder(event.product));
      } else {
        updatedList.add(event.product);
      }
      emit(state.copyWith(products: updatedList));
    });
    on<IncrementproductOrder>((event, emit) {
      final updatedList = List<CartModel>.from(state.products);
      final index = updatedList.indexWhere(
        (item) => item.product.id == event.product.product.id,
      );
      if (index != -1) {
        if (updatedList[index].product.stockAmount >
            updatedList[index].quantity)
          updatedList[index].quantity += 1;
        else {
          Fluttertoast.showToast(
            msg: "This is the maximum amount in the stock",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
          );
        }
      }
      emit(state.copyWith(products: updatedList));
    });
    on<DecrementproductOrder>((event, emit) {
      final updatedList = List<CartModel>.from(state.products);
      final index = updatedList.indexWhere(
        (item) => item.product.id == event.product.product.id,
      );
      if (index != -1) {
        if (updatedList[index].quantity > 1) {
          updatedList[index].quantity -= 1;
        } else {
          updatedList.removeAt(index);
        }
      }
      emit(state.copyWith(products: updatedList));
    });
    on<PayproductOrder>((event, emit) async {
      final double totalAmount = List<CartModel>.from(
        state.products,
      ).fold<double>(
        0.0,
        (sum, item) =>
            sum + (item.product.price * item.quantity.toDecimal()).toDouble(),
      );

      if (totalAmount > 0.0) {
        final String paymentKey = await PaymobManager().getPaymentKey(
          totalAmount,
        );

        await launchUrl(
          Uri.parse(
            "https://accept.paymob.com/api/acceptance/iframes/920338?payment_token=$paymentKey",
          ),
          mode: LaunchMode.inAppBrowserView,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Put something in the cart first!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
        );
      }
    });

    on<ClearproductOrder>((event, emit) {
      final updatedList = List<CartModel>.from(state.products)..clear();
      emit(state.copyWith(products: updatedList));
    });
  }
}
