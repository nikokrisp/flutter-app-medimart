import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class ToggleDeliveryOptions extends FilterEvent {}
class TogglePriceRange extends FilterEvent {}
class ToggleReviewRating extends FilterEvent {}
class ToggleOtherOptions extends FilterEvent {}
class UpdatePriceRange extends FilterEvent {
  final double minPrice;
  final double maxPrice;
  const UpdatePriceRange(this.minPrice, this.maxPrice);

  @override
  List<Object?> get props => [minPrice, maxPrice];
}
class ToggleFreeReturn extends FilterEvent {}
class ToggleBuyerProtection extends FilterEvent {}
class ToggleBestDeal extends FilterEvent {}
class ToggleNearest extends FilterEvent {}
