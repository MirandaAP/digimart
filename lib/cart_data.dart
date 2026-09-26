import 'package:flutter/material.dart';

class CartData {
  static final List<Map<String, dynamic>> items = [];

  static void addItem({
    required String name,
    required String price,
    required IconData icon,
  }) {
    final existingIndex = items.indexWhere(
      (item) => item['name'] == name,
    );

    if (existingIndex != -1) {
      items[existingIndex]['quantity']++;
    } else {
      items.add({
        'name': name,
        'price': price,
        'icon': icon,
        'quantity': 1,
      });
    }
  }

  static void increaseQuantity(int index) {
    if (index >= 0 && index < items.length) {
      items[index]['quantity']++;
    }
  }

  static void decreaseQuantity(int index) {
    if (index >= 0 && index < items.length) {
      if (items[index]['quantity'] > 1) {
        items[index]['quantity']--;
      } else {
        items.removeAt(index);
      }
    }
  }

  static void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  static void clearCart() {
    items.clear();
  }
}