import 'package:meta/meta.dart';

/// How the order reaches the customer: [delivery], [pickup], or any other mode the store offers, such as
/// `DeliveryType('dine_in')`.
@immutable
class DeliveryType {
  const DeliveryType(this.name);

  static const delivery = DeliveryType('delivery');
  static const pickup = DeliveryType('pickup');

  /// Value sent as `delivery_type`.
  final String name;

  @override
  bool operator ==(Object other) => other is DeliveryType && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

/// A line of a cart or an order.
class EcommerceItem {
  const EcommerceItem({
    required this.itemId,
    required this.itemName,
    this.category,
    this.price,
    this.quantity,
    this.currency,
  });

  /// Product id in the store catalog.
  final String itemId;

  /// Product name shown to the customer.
  final String itemName;

  /// Menu category, such as `Pizzas`.
  final String? category;

  /// Unit price.
  final double? price;

  /// Number of units.
  final int? quantity;

  /// ISO 4217 code, such as `BRL`.
  final String? currency;

  Map<String, Object?> toJson() => {
        'item_id': itemId,
        'item_name': itemName,
        'category': category,
        'price': price,
        'quantity': quantity,
        'currency': currency,
      }..removeWhere((_, value) => value == null);
}

typedef TrackFunction = void Function(String event, Map<String, Object?> properties);

/// Typed ecommerce events. Use the instance at `Repediu.order`.
class RepediuOrder {
  @internal
  const RepediuOrder(this._track);

  final TrackFunction _track;

  /// The customer opened product [id], named [name].
  void viewItem(String id, String name, {String? category, double? price, String? currency}) => _track('view_item',
      _compact({'item_id': id, 'item_name': name, 'category': category, 'price': price, 'currency': currency}));

  /// The customer added [quantity] units of product [id] to the cart.
  void addToCart(String id, String name, {String? category, double? price, int quantity = 1, String? currency}) =>
      _track(
        'add_to_cart',
        _compact({
          'item_id': id,
          'item_name': name,
          'quantity': quantity,
          'category': category,
          'price': price,
          'currency': currency,
        }),
      );

  /// The whole current cart. Send it on every change, including when the cart becomes empty.
  void cartSync(List<EcommerceItem> items) =>
      _track('cart_sync', {'items': items.map((item) => item.toJson()).toList()});

  /// The customer opened the menu [category].
  void viewCategory(String category) => _track('view_category', {'category': category});

  /// The customer started checkout. [step] names the stage when checkout has several.
  void beginCheckout({
    String? step,
    double? value,
    String? currency,
    int? itemCount,
    String? coupon,
    DeliveryType? deliveryType,
  }) =>
      _track(
        'begin_checkout',
        _compact({
          'step': step,
          'value': value,
          'currency': currency,
          'item_count': itemCount,
          'coupon': coupon,
          'delivery_type': deliveryType?.name,
        }),
      );

  /// Order [orderId] was placed with total [value].
  ///
  /// Send it once, after the store confirms the order, with the order id the store uses.
  void placeOrder(
    String orderId,
    double value, {
    String currency = 'BRL',
    double? subtotal,
    double? shipping,
    double? discount,
    String? paymentMethod,
    String? coupon,
    DeliveryType? deliveryType,
    List<EcommerceItem>? items,
  }) =>
      _track(
        'purchase',
        _compact({
          'order_id': orderId,
          'value': value,
          'currency': currency,
          'subtotal': subtotal,
          'shipping': shipping,
          'discount': discount,
          'payment_method': paymentMethod,
          'coupon': coupon,
          'delivery_type': deliveryType?.name,
          'items': items?.map((item) => item.toJson()).toList(),
        }),
      );

  /// Order [orderId] was cancelled.
  void cancelOrder(String orderId, {String? reason, double? value, String? currency}) => _track(
      'order_cancelled', _compact({'order_id': orderId, 'reason': reason, 'value': value, 'currency': currency}));

  Map<String, Object?> _compact(Map<String, Object?> properties) =>
      properties..removeWhere((_, value) => value == null);
}
