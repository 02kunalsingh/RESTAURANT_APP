
class Item {
  final String name;
  final String description;
  final double price;
  final String delivery;
  final double rating;
  final String distance;

  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.delivery,
    required this.rating,
    required this.distance,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'delivery': delivery,
      'rating': rating,
      'distance': distance,
    };
  }
}