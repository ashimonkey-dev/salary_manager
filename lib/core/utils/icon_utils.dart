import 'package:flutter/material.dart';

class IconUtils {
  /// アイコン名からIconDataを取得する
  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'work':
        return Icons.work;
      case 'business':
        return Icons.business;
      case 'school':
        return Icons.school;
      case 'home':
        return Icons.home;
      case 'store':
        return Icons.store;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'computer':
        return Icons.computer;
      case 'phone_android':
        return Icons.phone_android;
      case 'account_balance':
        return Icons.account_balance;
      case 'attach_money':
        return Icons.attach_money;
      case 'monetization_on':
        return Icons.monetization_on;
      case 'payment':
        return Icons.payment;
      case 'credit_card':
        return Icons.credit_card;
      case 'account_circle':
        return Icons.account_circle;
      case 'person':
        return Icons.person;
      case 'engineering':
        return Icons.engineering;
      case 'construction':
        return Icons.construction;
      case 'handyman':
        return Icons.handyman;
      case 'build':
        return Icons.build;
      default:
        return Icons.help;
    }
  }
} 