import 'package:go_router/go_router.dart';

import 'screens/product_form_screen.dart';
import 'screens/products_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/products',
  routes: [
    GoRoute(
      path: '/products',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: ProductsScreen(),
        );
      },
      routes: [
        GoRoute(
          path: 'add',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: ProductFormScreen(),
            );
          },
        ),
        GoRoute(
          path: ':productId',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: ProductFormScreen(
                productId: state.pathParameters['productId'],
              ),
            );
          },
        ),
      ],
    ),
  ],
);
