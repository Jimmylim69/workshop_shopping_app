import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/models/product.dart';

import '../data/cart_items.dart';
import '../widgets/quantity_selector.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(

                aspectRatio: 1,
                child: PageView(
                  children: widget.product.images.map((image) {
                    return Image.asset(image, fit: BoxFit.contain);
                  }).toList(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 12),

                    // Price
                    Text(
                      "RM ${widget.product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Sales & Rating Row
                    Row(
                      children: [
                        Text(
                          "${widget.product.sales} sold | ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        Text(
                            "${widget.product.rating}",
                            style: Theme.of(context).textTheme.bodyMedium
                        ),

                        const Icon(Icons.star, color: Colors.amber, size: 20),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // ========== DESCRIPTION SECTION ==========
                    Text(
                        "Product Description",
                        style: Theme.of(context).textTheme.titleMedium
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.product.description.isEmpty
                          ? "No description available."
                          : widget.product.description,
                      style: const TextStyle(height: 1.75),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(

        leading: IconButton(

          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),

        ),



        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border),



          ),
        ],
      ),
    );
  }
}

Widget _buildAddToCartBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [

        QuantitySelector(
            quantity: quantity,
            onIncrement: () => setState(() => quantity += 1),
            onDecrement: () => setState(() => quantity -= 1)
        ),

        // ========== ADD TO CART BUTTON ==========
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Create new item from current product
              final newItem = Item(
                productId: widget.product.id!,
                productName: widget.product.name,
                imageUrl: widget.product.images.first,
                price: widget.product.price,
                quantity: quantity,
              );

              // If item already exists in cart, override the item with new quantity
              if (cartItems.any((item) => item.productId == newItem.productId)) {
                final existingItemIndex = cartItems.indexWhere((item) => item.productId == newItem.productId);
                setState(() {
                  final existingItem = cartItems[existingItemIndex];
                  cartItems[existingItemIndex] = Item(
                    productId: existingItem.productId,
                    productName: existingItem.productName,
                    imageUrl: existingItem.imageUrl,
                    price: existingItem.price,
                    quantity: existingItem.quantity + quantity,
                  );
                });

                // Else, add new item into cart
              } else {
                setState(() {
                  cartItems.add(newItem);
                });
              }

              // Notify user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added to cart successfully!'),
                  duration: Duration(milliseconds: 500),
                ),
              );

            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Add to Cart"),
          ),
        ),


      ],
    ),
  );
}