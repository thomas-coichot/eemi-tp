import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../models/product_model.dart';
import '../provider/product_provider.dart';
import '../services/api_service.dart';
import '../services/toast_service.dart';
import 'buttons/loading_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final ProductModel product;
  final void Function(String id) onDelete;
  final void Function(ProductModel) onEdit;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.onSurface.withAlpha(20);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final response = await context.push('/products/${product.id}');

        if (response is ProductModel) {
          onEdit(response);
        }
      },
      onLongPress: () {
        _openDeleteModal(context);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${product.price.toStringAsFixed(2)}€',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDeleteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                'Supprimer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Êtes-vous sur de vouloir supprimer le produit : ${product.name} ?'),
              Row(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LoadingButton(
                    label: 'Annuler',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  LoadingButton(
                    color: Colors.red,
                    label: 'Supprimer',
                    onPressed: _onDelete,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onDelete() async {
    try {
      await ProductProvider().delete(product.id);

      onDelete(product.id);
    } on ApiException catch (e) {
      ToastService.show(message: e.message, type: ToastificationType.error);
    }
  }
}
