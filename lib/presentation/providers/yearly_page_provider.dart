import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class YearlyPageControllerNotifier extends StateNotifier<PageController> {
  YearlyPageControllerNotifier() : super(PageController());

  void goToCurrentYear() {
    final currentYear = DateTime.now().year;
    final startYear = 2020;
    final page = currentYear - startYear;
    state.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

final yearlyPageControllerProvider = StateNotifierProvider<YearlyPageControllerNotifier, PageController>((ref) {
  return YearlyPageControllerNotifier();
}); 