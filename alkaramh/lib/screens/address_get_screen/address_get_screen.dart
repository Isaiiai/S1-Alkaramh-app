import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/models/order_model.dart';
import 'package:alkaramh/screens/address_get_screen/payment_methord.dart';
import 'package:alkaramh/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressGetScreen extends StatefulWidget {
  const AddressGetScreen({super.key});

  @override
  State<AddressGetScreen> createState() => _AddressGetScreenState();
}

class _AddressGetScreenState extends State<AddressGetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _districtController = TextEditingController();
  final _landmarkController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSharedPreferance();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _getSharedPreferance() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('user_name') ?? '';
    _phoneController.text = prefs.getString('phone_number') ?? '';
    _addressController.text = prefs.getString('address') ?? '';
    _districtController.text = prefs.getString('district') ?? '';
    _landmarkController.text = prefs.getString('landmark') ?? '';
  }

  Future<void> _saveAddressDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('phone_number', _phoneController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('district', _districtController.text);
    await prefs.setString('landmark', _landmarkController.text);
  }

  @override
  Widget build(BuildContext context) {
    OrderBloc orderBloc = BlocProvider.of<OrderBloc>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBackGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate('address'),
                      textAlign: TextAlign.center,
                      style: MyTextTheme.body.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .translate('full_name'),
                            labelStyle: MyTextTheme.normal,
                            hintStyle: MyTextTheme.body,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('please_enter');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .translate('phone_number'),
                            labelStyle: MyTextTheme.normal,
                            hintStyle: MyTextTheme.body,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('please_enter');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .translate('address'),
                            labelStyle: MyTextTheme.normal,
                            hintStyle: MyTextTheme.body,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('please_enter');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _districtController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .translate('district'),
                            labelStyle: MyTextTheme.normal,
                            hintStyle: MyTextTheme.body,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('please_enter');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _landmarkController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .translate('landmark'),
                            labelStyle: MyTextTheme.normal,
                            hintStyle: MyTextTheme.body,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Submit Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: BlocConsumer<OrderBloc, OrderState>(
                bloc: orderBloc,
                listener: (context, state) {
                  if (state is OrderSuccessState) {
                    Navigator.pop(context, true);
                    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                    cartBloc.add(ClearCartEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          AppLocalizations.of(context)!.translate('success'),
                          style: MyTextTheme.body.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is OrderLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _saveAddressDetails();
                        final address = AddressModel(
                          name: _nameController.text,
                          phoneNumber: _phoneController.text,
                          address: _addressController.text,
                          district: _districtController.text,
                          landMark: _landmarkController.text,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentMethodScreen(
                              totalAmount: orderBloc.totalAmount,
                              address: address,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate('submit'),
                      style: MyTextTheme.headline.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
