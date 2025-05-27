import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final double minPrice;
  final double maxPrice;
  final bool freeReturn;
  final bool buyerProtection;
  final bool bestDeal;
  final bool nearest;
  final bool isDeliveryOptionsVisible;
  final bool isPriceRangeVisible;
  final bool isReviewRatingVisible;
  final bool isOtherOptionsVisible;

  const FilterState({
    this.minPrice = 1000,
    this.maxPrice = 10000,
    this.freeReturn = false,
    this.buyerProtection = false,
    this.bestDeal = false,
    this.nearest = false,
    this.isDeliveryOptionsVisible = true,
    this.isPriceRangeVisible = true,
    this.isReviewRatingVisible = true,
    this.isOtherOptionsVisible = true,
  });

  FilterState copyWith({
    double? minPrice,
    double? maxPrice,
    bool? freeReturn,
    bool? buyerProtection,
    bool? bestDeal,
    bool? nearest,
    bool? isDeliveryOptionsVisible,
    bool? isPriceRangeVisible,
    bool? isReviewRatingVisible,
    bool? isOtherOptionsVisible,
  }) {
    return FilterState(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      freeReturn: freeReturn ?? this.freeReturn,
      buyerProtection: buyerProtection ?? this.buyerProtection,
      bestDeal: bestDeal ?? this.bestDeal,
      nearest: nearest ?? this.nearest,
      isDeliveryOptionsVisible: isDeliveryOptionsVisible ?? this.isDeliveryOptionsVisible,
      isPriceRangeVisible: isPriceRangeVisible ?? this.isPriceRangeVisible,
      isReviewRatingVisible: isReviewRatingVisible ?? this.isReviewRatingVisible,
      isOtherOptionsVisible: isOtherOptionsVisible ?? this.isOtherOptionsVisible,
    );
  }

  @override
  List<Object?> get props => [
    minPrice,
    maxPrice,
    freeReturn,
    buyerProtection,
    bestDeal,
    nearest,
    isDeliveryOptionsVisible,
    isPriceRangeVisible,
    isReviewRatingVisible,
    isOtherOptionsVisible,
  ];
}
