import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:rigz/bloc/Fav/event.dart';
import 'package:rigz/bloc/Fav/state.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  FavBloc() : super(FavState(products: [])) {
    on<ClearFavList>((event, emit) {
      final updatedList = List<productModel>.from(state.products)..clear();
      emit(state.copyWith(products: updatedList));
    });
    on<toogleProductFav>((event, emit) {
      final updatedList = List<productModel>.from(state.products);
      final index = updatedList.indexWhere(
        (item) => item.id == event.product.id,
      );
      if (index != -1) {
        updatedList.removeAt(index);
      } else {
        updatedList.add(event.product);
      }
      emit(state.copyWith(products: updatedList));
    });
  }
}
