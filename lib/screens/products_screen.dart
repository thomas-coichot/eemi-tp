import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../models/product_model.dart';
import '../provider/model_provider.dart';
import '../provider/product_provider.dart';
import '../services/api_service.dart';
import '../services/toast_service.dart';
import '../utils.dart';
import '../widgets/fields/input_decoration.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<ProductModel> _products = [];

  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final largeScreen = isLargeScreen(context);

    return Scaffold(
      appBar: AppBar(title: Text('Articles')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final response = await context.push('/products/add');

          if (response is ProductModel) {
            setState(() {
              _products.insert(0, response);
            });
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: buildInputDecoration(
                colorScheme: colorScheme,
                label: 'Rechercher un produit',
                prefixIcon: Icons.search,
              ),

              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: largeScreen ? 4 : 2,
                mainAxisSpacing: 8,

                crossAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext ctx, int index) {
                ProductModel product = _products[index];

                return ProductCard(
                  product: product,
                  onEdit: (ProductModel updatedProduct) {
                    setState(() {
                      _products[index] = updatedProduct;
                    });
                  },
                  onDelete: (String id) {
                    setState(() {
                      _products.removeWhere((element) => element.id == id);
                    });
                    Navigator.pop(context);
                    ToastService.show(message: 'Produit supprimé avec succès', type: ToastificationType.success);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _loadData() async {
    try {
      final DataList response = await ProductProvider().getAll(
        queryParams: {
          if (_searchController.text.isNotEmpty) 'search': _searchController.text.trim(),
        },
      );
      setState(() {
        _products = response.rows.cast<ProductModel>();
      });
    } on ApiException catch (e) {
      ToastService.show(message: e.message, type: ToastificationType.error);
    }
  }

  void _onSearch(String text) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadData();
    });
  }
}
