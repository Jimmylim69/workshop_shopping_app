import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workshop_shopping_app/data/cart_items.dart';
import 'package:workshop_shopping_app/data/order_data.dart';
import 'package:workshop_shopping_app/data/user_data.dart';
import 'package:workshop_shopping_app/models/item.dart';
import 'package:workshop_shopping_app/models/order.dart';
import 'package:workshop_shopping_app/widgets/quantity_selector.dart';
import 'package:uuid/uuid.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _incrementQuantity(int index) {
    setState(() {
      final item = cartItems[index];
      cartItems[index] = Item(
        productId: item.productId,
        productName: item.productName,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: item.quantity + 1,
      );
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final item = cartItems[index];
      cartItems[index] = Item(
        productId: item.productId,
        productName: item.productName,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: item.quantity - 1,
      );
    });
  }

  void _deleteItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  double _calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void _checkout() {
    // Create random orderId
    final orderId = const Uuid().v4();

    // Add new order into orders list
    orders.add(
        Order(
          id: orderId,
          userId: user.name,
          items: List<Item>.from(cartItems),
          totalAmount: _calculateTotal(),
          shippingAddress: user.address,
          createdAt: DateTime.now(),
        )
    );

    // Remove all items in cartItems list
    cartItems.clear();

    // Notify user
    if (!context.mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Checkout Successful'),
            content: Text('Order placed successfully! Order ID: ${orderId.substring(0, 8)}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          );
        }
    );

    // Refresh page
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItemCard(context, index);
              },
            ),
          ),

          // Add this line
          _buildCheckoutBar(context),

        ],
      ),
    );
  }
}

Widget _buildCheckoutBar(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Total Amount
        Text(
          "Total: RM ${_calculateTotal().toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Checkout Button
        ElevatedButton(
          onPressed: cartItems.isEmpty ? null : _checkout,
          child: const Text("Checkout"),
        )
      ],
    ),
  );
}