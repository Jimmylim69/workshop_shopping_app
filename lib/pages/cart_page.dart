import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';

// Assuming these imports exist in your project structure
import 'package:workshop_shopping_app/data/cart_items.dart';
import 'package:workshop_shopping_app/data/order_data.dart';
import 'package:workshop_shopping_app/data/user_data.dart';
import 'package:workshop_shopping_app/models/item.dart';
import 'package:workshop_shopping_app/models/order.dart';
import 'package:workshop_shopping_app/widgets/quantity_selector.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // --- LOGIC METHODS ---

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
      // Prevent going below 1, or handle removal if desired
      if (item.quantity > 1) {
        cartItems[index] = Item(
          productId: item.productId,
          productName: item.productName,
          imageUrl: item.imageUrl,
          price: item.price,
          quantity: item.quantity - 1,
        );
      }
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
    final orderId = const Uuid().v4();

    orders.add(Order(
      id: orderId,
      userId: user.name,
      items: List<Item>.from(cartItems),
      totalAmount: _calculateTotal(),
      shippingAddress: user.address,
      createdAt: DateTime.now(),
    ));

    cartItems.clear();

    if (!context.mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Checkout Successful'),
            content: Text(
                'Order placed successfully! Order ID: ${orderId.substring(0, 8)}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        });

    setState(() {});
  }

  // --- BUILD METHOD ---

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
          _buildCheckoutBar(context),
        ],
      ),
    );
  }

  // --- WIDGET HELPER METHODS (MOVED INSIDE THE CLASS) ---

  Widget _buildCartItemCard(BuildContext context, int index) {
    final cartItem = cartItems[index];
    final quantity = cartItem.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.35,
          children: [
            SlidableAction(
              onPressed: (context) => _deleteItem(index), // Now this works!
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              flex: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  cartItem.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.productName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "RM ${cartItem.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        QuantitySelector(
                          quantity: quantity,
                          onIncrement: () => _incrementQuantity(index), // Now works
                          onDecrement: () => _decrementQuantity(index), // Now works
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total: RM ${_calculateTotal().toStringAsFixed(2)}", // Now works
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: cartItems.isEmpty ? null : _checkout, // Now works
            child: const Text("Checkout"),
          )
        ],
      ),
    );
  }
} // <--- End of class _CartPageState