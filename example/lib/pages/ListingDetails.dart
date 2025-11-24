import 'package:flutter/material.dart';

class ListingDetails extends StatefulWidget {
  final double width;
  final double height;
  final Function(
    String address1,
    String address2,
    String price,
    String status,
    String beds,
    String baths,
    String sqft,
    String description,
  )
  onSave;
  const ListingDetails({
    super.key,
    required this.width,
    required this.height,
    required this.onSave,
  });

  @override
  State<ListingDetails> createState() => _ListingDetailsState();
}

class _ListingDetailsState extends State<ListingDetails> {
  var _isHovering = false;
  final _address1Focus = FocusNode();
  final _address1TextController = TextEditingController();
  final _address2Focus = FocusNode();
  final _address2TextController = TextEditingController();
  final _priceFocus = FocusNode();
  final _priceTextController = TextEditingController();
  final _statusFocus = FocusNode();
  final _statusTextController = TextEditingController();
  final _bedsFocus = FocusNode();
  final _bedsTextController = TextEditingController();
  final _bathsFocus = FocusNode();
  final _bathsTextController = TextEditingController();
  final _sqftFocus = FocusNode();
  final _sqftTextController = TextEditingController();
  final _descriptionFocus = FocusNode();
  final _descriptionTextController = TextEditingController();
  double width = 0;
  double height = 0;

  InputDecoration inputDecoration(String label, bool hasFocus) {
    return InputDecoration(
      labelText: hasFocus ? null : label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    for (var node in [
      _address1Focus,
      _address2Focus,
      _priceFocus,
      _statusFocus,
      _bedsFocus,
      _bathsFocus,
      _sqftFocus,
      _descriptionFocus,
    ]) {
      node.addListener(() => setState(() {}));
    }
  }

  void _triggerSave() {
    widget.onSave(
      _address1TextController.text,
      _address2TextController.text,
      _priceTextController.text,
      _statusTextController.text,
      _bedsTextController.text,
      _bathsTextController.text,
      _sqftTextController.text,
      _descriptionTextController.text,
    );
  }

  @override
  void dispose() {
    _address1Focus.dispose();
    _address2Focus.dispose();
    _priceFocus.dispose();
    _statusFocus.dispose();
    _bedsFocus.dispose();
    _bathsFocus.dispose();
    _sqftFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double formWidth;
    double formHeight;
    EdgeInsets padding;

    if (width < 600) {
      formWidth = width * 0.9; // mobile
      formHeight = height * 0.9;
      padding = const EdgeInsets.all(16);
    } else if (width < 1100) {
      formWidth = width * 0.7; // tablet
      formHeight = height * 0.9;
      padding = const EdgeInsets.all(24);
    } else {
      formWidth = width * 0.3; // desktop
      formHeight = height * 0.815;
      padding = const EdgeInsets.all(10);
    }

    final shadow = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 6,
          spreadRadius: -4,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return Container(
      width: formWidth,
      height: formHeight,
      // color: Colors.red.withOpacity(0.2),
      decoration: BoxDecoration(
        color: Colors.white, // needed for shadow visibility
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: padding,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: formHeight, // same as SizedBox height
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _address1Focus,
                      controller: _address1TextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _address1TextController.text.isNotEmpty
                          ? inputDecoration('', _address1Focus.hasFocus)
                          : inputDecoration(
                              'Address 1',
                              _address1Focus.hasFocus,
                            ),
                      onChanged: (_) => _triggerSave(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // address2
                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _address2Focus,
                      controller: _address2TextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _address2TextController.text.isNotEmpty
                          ? inputDecoration('', _address2Focus.hasFocus)
                          : inputDecoration(
                              'Address 2',
                              _address2Focus.hasFocus,
                            ),
                      onChanged: (_) => _triggerSave(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // price
                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _priceFocus,
                      controller: _priceTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _priceTextController.text.isNotEmpty
                          ? inputDecoration('', _priceFocus.hasFocus)
                          : inputDecoration(
                              'Asking Price',
                              _priceFocus.hasFocus,
                            ),
                      onChanged: (_) => _triggerSave(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // status
                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _statusFocus,
                      controller: _statusTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _statusTextController.text.isNotEmpty
                          ? inputDecoration('', _statusFocus.hasFocus)
                          : inputDecoration('Status', _statusFocus.hasFocus),
                      onChanged: (_) => _triggerSave(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // beds
                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _bedsFocus,
                      controller: _bedsTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _bedsTextController.text.isNotEmpty
                          ? inputDecoration('', _bedsFocus.hasFocus)
                          : inputDecoration('Beds', _bedsFocus.hasFocus),
                      onChanged: (_) => _triggerSave(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // baths
                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _bathsFocus,
                      controller: _bathsTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _bathsTextController.text.isNotEmpty
                          ? inputDecoration('', _bathsFocus.hasFocus)
                          : inputDecoration('Baths', _bathsFocus.hasFocus),
                      onChanged: (_) => _triggerSave(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // sqft
                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _sqftFocus,
                      controller: _sqftTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _sqftTextController.text.isNotEmpty
                          ? inputDecoration('', _sqftFocus.hasFocus)
                          : inputDecoration('Sqft', _sqftFocus.hasFocus),
                      onChanged: (_) => _triggerSave(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // description
                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _descriptionFocus,
                      controller: _descriptionTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      maxLines: 10,
                      decoration: _descriptionTextController.text.isNotEmpty
                          ? inputDecoration('', _descriptionFocus.hasFocus)
                          : inputDecoration('Sqft', _descriptionFocus.hasFocus),
                      onChanged: (_) => _triggerSave(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
