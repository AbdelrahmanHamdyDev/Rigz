import 'package:rigz/Model/CartModel.dart';
import 'package:rigz/bloc/Cart/event.dart';
import 'package:rigz/bloc/Cart/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class productBloc extends Bloc<ProductEvent, productsState> {
  productBloc() : super(productsState(products: [])) {
    on<Addproduct>((event, emit) {
      final updatedList = List<CartModel>.from(state.products)
        ..add(event.product);
      emit(state.copyWith(products: updatedList));
    });
    on<IncrementproductOrder>((event, emit) {
      final updatedList = List<CartModel>.from(state.products);
      final index = updatedList.indexWhere(
        (item) => item.product.id == event.product.product.id,
      );
      if (index != -1) {
        updatedList[index].quantity += 1;
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
    on<ClearproductOrder>((event, emit) {
      final updatedList = List<CartModel>.from(state.products)..clear();
      emit(state.copyWith(products: updatedList));
    });
  }
}
