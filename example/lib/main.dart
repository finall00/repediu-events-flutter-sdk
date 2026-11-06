import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repediu_events/repediu_events.dart';

Future<void> main() async {
  await Repediu.init(writeKey: 'STORE_WRITE_KEY', debug: kDebugMode);
  runApp(
    MaterialApp(
      navigatorObservers: [RepediuNavigatorObserver()],
      initialRoute: '/menu',
      routes: {
        '/menu': (_) => const MenuPage(),
        '/cart': (_) => const CartPage(),
      },
    ),
  );
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Menu')),
        body: ListTile(
          title: const Text('Pepperoni Pizza'),
          subtitle: const Text('R\$ 64.90'),
          onTap: () => Repediu.order.viewItem('pepperoni-pizza', 'Pepperoni Pizza', category: 'Pizzas', price: 64.9),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              Repediu.order.addToCart('pepperoni-pizza', 'Pepperoni Pizza', category: 'Pizzas', price: 64.9);
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ),
      );
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: Center(
          child: FilledButton(
            onPressed: () {
              Repediu.identify(phone: '11999998888', name: 'Maria');
              Repediu.order.placeOrder(
                'ORDER-1',
                64.9,
                paymentMethod: 'pix',
                deliveryType: DeliveryType.delivery,
                items: [
                  EcommerceItem(itemId: 'pepperoni-pizza', itemName: 'Pepperoni Pizza', price: 64.9, quantity: 1)
                ],
              );
            },
            child: const Text('Place order'),
          ),
        ),
      );
}
