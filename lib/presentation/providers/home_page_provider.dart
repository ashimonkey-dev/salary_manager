import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homePageControllerProvider = StateNotifierProvider<HomePageControllerNotifier, PageController>((ref) {
  return HomePageControllerNotifier();
});

class HomePageControllerNotifier extends StateNotifier<PageController> {
  HomePageControllerNotifier() : super(PageController(initialPage: _getCurrentMonthIndex()));

  static int _getCurrentMonthIndex() {
    final startDate = DateTime(2020, 1);
    final currentDate = DateTime.now();
    return currentDate.difference(startDate).inDays ~/ 30;
  }

  void goToCurrentMonth() {
    final currentIndex = _getCurrentMonthIndex();
    state.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
} 