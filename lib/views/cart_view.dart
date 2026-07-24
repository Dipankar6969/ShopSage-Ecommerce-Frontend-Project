import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}


class _CartViewState extends State<CartView> {
  // Demo cart items
  final List<Map<String, dynamic>> cartItems = [
    {
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuBA76otF-tVr-Na_ZZlaPcMNznP_gg4ZnKUQLg7U2v5b7LgXS_lGOCGGG_PKl_pdSmdaYcT4Ctmz7SHIolRwjDMS-_yTka0HL1J272IXY0-AwLwyXD3Bee94VWSYdSMzrjlTbpRd2cxZAxMzz5R082WEVooDd4nKBJ9jglK2Di-4ws92J7Pm3TxOrfgtgQxktC0OnAyeNhKndCJPCR5u4dMU-FekJcYc_VVbqae-ccG8v6i0R9eYGhz",
      "name": "Titanium Core Smartwatch Series X",
      "variation": "Titanium Silver / 44mm",
      "price": 51045,
      "qty": 1,
      "selected": true,
    },
    {
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuCiSV5qxsfftFVrAIG4ltLrHuBxw3K8BFICz8chGkea_GEbm-3bn6Zs7Fz9hsnaf0E71wUQowIB6vD2Y8vz57ELmZRjycs11KY5vmIN-my7uRF_qRTQ2XNDjcUBqm5iz2X7d35IZtfiso_r4-h00OstE5zj7W4_aComKX3FeG3Wbc4Dhr83F9KcQ5MXRcRpiGAixYcoZZW0pTQabjmtEtSXivT4tX72QKMpyBk7mDzS-5fnotZJ4LRP",
      "name": "Aero-Pulse Over-Ear Wireless Headphones",
      "variation": "Deep Navy / Matte Finish",
      "price": 38517,
      "qty": 1,
      "selected": false,
    },
    {
      "image": "https://img01.ztat.net/article/spp-media-p1/0117d3f555064d619547338470ec2fcb/5aa562bb0b4b49d5bbabd3c1cd81a5d5.jpg",
      "name": "Nike Air Zoom Pegasus 38",
      "variation": "Black / White / Size 10",
      "price": 12000,
      "qty": 1,
      "selected": false,
    },
    {
      "image": "https://al-ikhsan.com/cdn/shop/files/f_b_fb5372-010_f.jpg",
      "name": "Nike Dri-FIT Club Unstructured Metal Swoosh Cap",
      "variation": "Black / Metallic Silver",
      "price": 4300,
      "qty": 1,
      "selected": false,
    }
  ];
  
  // Price Calculations
  double get subtotal {
    double total = 0;

    for (var item in cartItems) {
      if (item["selected"] == true) {
        total += (item["price"] as num) * (item["qty"] as num);
      }
    }

    return total;
  }

  double get shipping {
    // Free shipping for orders above Rs. 5000
    return subtotal >= 5000 ? 0 : 100;
  }

  double get discount {
    // No discount if subtotal is below Rs. 50000
    if (subtotal < 50000) {
      return 0;
    }

    return 500;
  }

  double get total {
    if (subtotal < 50000) {
      return subtotal + shipping;
    } else if (subtotal >= 50000) {
      return subtotal + shipping - discount;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(
          onPressed: null, // You can customize the back button action if needed
          color: Colors.black, // You can customize the color easily
        ),
        title: const Text("My Cart")),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Checkbox(
                  value: cartItems.every((item) => item["selected"]),
                  onChanged: (value) {
                    setState(() {
                      for (var item in cartItems) {
                        item["selected"] = value;
                      }
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Select All",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Cart Items
          ...List.generate(
            cartItems.length,
            (index) => buildCartItem(index),
          ),

          const SizedBox(height: 12),

          // Voucher
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Section
                Row(
                  children: const [
                    Icon(
                      Icons.confirmation_number_outlined,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Have a promo code?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Input + Button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "CODE10",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "APPLY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Shipping
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: ListTile(
              leading: const Icon(Icons.local_shipping_outlined),
              title: const Text("Shipping"),
              subtitle: const Text("Standard Delivery"),
              trailing: const Text("Rs. 100"),
            ),
          ),

          const SizedBox(height: 10),

          // Order Summary
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  summaryRow(
                    "Subtotal",
                    "Rs. ${subtotal.toStringAsFixed(0)}",
                  ),

                  summaryRow(
                    "Shipping",
                    shipping == 0 ? "FREE" : "Rs. ${shipping.toStringAsFixed(0)}",
                  ),

                  summaryRow(
                    "Discount",
                    "-Rs. ${discount.toStringAsFixed(0)}",
                  ),

                  const Divider(),

                  summaryRow(
                    "Total",
                    "Rs. ${total.toStringAsFixed(0)}",
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Recommended Products Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "You May Also Like",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return buildRecommendedItem(index);
              },
            ),
          ),

          const SizedBox(height: 100),

        ],
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Handle checkout action
          },
          child: const Text("Checkout"),
        ),
      )
    );
  }
  
  //widget to build summary row
  Widget summaryRow(
  String title,
  String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.black : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  //widget to build each cart item
  Widget buildCartItem(int index) {
    final item = cartItems[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Checkbox(
              value: item["selected"],
              onChanged: (value) {
                setState(() {
                  item["selected"] = value;
                });
              },
            ),
            Image.network(
              item["image"],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text("Variation: ${item["variation"]}"),
                  const SizedBox(height: 4),
                  Text(
                    "Rs. ${item["price"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF070707)
                    )
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (item["qty"] > 1) {
                        item["qty"]--;
                      }
                    });
                  },
                ),
                Text("${item["qty"]}"),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      item["qty"]++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget buildRecommendedItem(int index) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            "https://picsum.photos/200?random=$index",
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            "Product ${index + 1}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text("Rs. 999"),
        ],
      ),
    );
  }
}