/// A class representing a food item with its name and calorie value.
class Food {
  /// The name of the food item.
  final String food;

  /// The number of calories in the food item.
  final double calories;

  /// Constructs a [Food] instance with the provided [food] and [calories].
  Food(this.food, this.calories);

  /// Factory method to create a [Food] object from a JSON map.
  ///
  /// The [json] parameter should contain keys 'food' and 'calories'.
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      json['food'] as String,
      json['calories'] as double,
    );
  }
}
