import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<ToggleDeliveryOptions>((event, emit) {
      emit(state.copyWith(isDeliveryOptionsVisible: !state.isDeliveryOptionsVisible));
    });
    on<TogglePriceRange>((event, emit) {
      emit(state.copyWith(isPriceRangeVisible: !state.isPriceRangeVisible));
    });
    on<ToggleReviewRating>((event, emit) {
      emit(state.copyWith(isReviewRatingVisible: !state.isReviewRatingVisible));
    });
    on<ToggleOtherOptions>((event, emit) {
      emit(state.copyWith(isOtherOptionsVisible: !state.isOtherOptionsVisible));
    });
    on<UpdatePriceRange>((event, emit) {
      emit(state.copyWith(minPrice: event.minPrice, maxPrice: event.maxPrice));
    });
    on<ToggleFreeReturn>((event, emit) {
      emit(state.copyWith(freeReturn: !state.freeReturn));
    });
    on<ToggleBuyerProtection>((event, emit) {
      emit(state.copyWith(buyerProtection: !state.buyerProtection));
    });
    on<ToggleBestDeal>((event, emit) {
      emit(state.copyWith(bestDeal: !state.bestDeal));
    });
    on<ToggleNearest>((event, emit) {
      emit(state.copyWith(nearest: !state.nearest));
    });
  }
}
