import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../models/product_model.dart';
import '../provider/product_provider.dart';
import '../services/api_service.dart';
import '../services/toast_service.dart';
import '../widgets/buttons/loading_button.dart';
import '../widgets/fields/custom_text_field.dart';
import '../widgets/fields/number_field.dart';
import '../widgets/responsive_box.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({this.productId, super.key});

  final String? productId;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  late bool _isLoading = true;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();

    if (widget.productId == null) {
      _isLoading = false;
      return;
    }

    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.productId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier' : 'Ajouter un produit'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: ResponsiveBox(
                size: ResponsiveBoxSize.md,
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      CustomTextField(
                        label: 'Nom du produit',
                        controller: _nameController,
                      ),
                      CustomTextField(
                        label: 'Description',
                        multiline: true,
                        controller: _descriptionController,
                        required: false,
                      ),
                      NumberField(
                        label: 'Prix',
                        controller: _priceController,
                      ),
                      CustomTextField(
                        label: 'Url de l\'image',
                        type: TextFieldType.url,
                        controller: _imageController,
                      ),
                      LoadingButton(
                        label: isEditing ? 'Modifier' : 'Ajouter',
                        onPressed: _onSubmit,
                        isSubmitted: _isSubmitted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _loadData() async {
    try {
      final ProductModel product = await ProductProvider().get(widget.productId!);

      _nameController.text = product.name;
      _descriptionController.text = product.description ?? '';
      _priceController.text = product.price.toString();
      _imageController.text = product.image;

      setState(() {
        _isLoading = false;
      });
    } on ApiException catch (e) {
      ToastService.show(message: e.message, type: ToastificationType.error);
    }
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitted = true;
    });

    try {
      final ProductModel response = await ProductProvider().addOrUpdate(
        data: {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'image': _imageController.text,
        },
        id: widget.productId,
      );

      if (!mounted) {
        return;
      }

      ToastService.show(
        message: 'Produit ${widget.productId != null ? 'modifié' : 'ajouté'} avec succès',
      );

      context.pop(response);
    } on ApiException catch (e) {
      ToastService.show(message: e.message, type: ToastificationType.error);
    } finally {
      setState(() {
        _isSubmitted = false;
      });
    }
  }
}
