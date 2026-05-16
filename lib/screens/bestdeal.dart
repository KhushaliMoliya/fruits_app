import 'package:flutter/material.dart';
import 'package:fruits_app/screens/favourite.dart';

class BestDealPage extends StatefulWidget {
  const BestDealPage({super.key});

  @override
  State<BestDealPage> createState() => _BestDealPageState();
}

class _BestDealPageState extends State<BestDealPage> {
  final List<Map<String, String>> bestDeals = const [
    {
      'name': 'Almonds',
      'image': 'assets/almond.webp',
      'price': '₹350',
      'old': '₹380',
    },
    {
      'name': 'Fortune Ahaar Dal (Toor Dal)',
      'image': 'assets/toordal.webp',
      'price': '₹59',
      'old': '₹62',
    },
    {
      'name': 'Green Tea',
      'image': 'assets/greentea.jpg',
      'price': '₹30',
      'old': '₹32',
    },
    {
      'name': 'maggie',
      'image': 'assets/maggie.jpg',
      'price': '₹10',
      'old': '₹12',
    },

    // additional deals can be added here
  ];

  final Set<String> favouritedNames = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Deals'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: bestDeals.length > 4 ? 4 : bestDeals.length,
          itemBuilder: (context, index) {
            final deal = bestDeals[index];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        favouritedNames.contains(deal['name'])
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favouritedNames.contains(deal['name'])
                            ? Colors.green
                            : null,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          final name = deal['name']!;
                          if (favouritedNames.contains(name)) {
                            favouritedNames.remove(name);
                            FavouritePage.favouritedItems.removeWhere(
                              (item) => item['name'] == name,
                            );
                          } else {
                            favouritedNames.add(name);
                            FavouritePage.favouritedItems.add(deal);
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(deal['image']!, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal['name']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '500 ml',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        deal['price']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        deal['old']!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
