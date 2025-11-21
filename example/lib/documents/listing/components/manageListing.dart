import 'package:example/storage/components/multiFileUpload.dart';
import 'package:flutter/material.dart';

class ManageListing extends StatefulWidget {
  const ManageListing({super.key});

  @override
  State<ManageListing> createState() => _ManageListingState();
}

class _ManageListingState extends State<ManageListing> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // preview
        // editor
      ],
    );
  }
}

class EditListing extends StatefulWidget {
  const EditListing({super.key});

  @override
  State<EditListing> createState() => _EditListingState();
}

class _EditListingState extends State<EditListing> {
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 450,
              height: 650,
              // color: Colors.red.withOpacity(0.2),
              child: FileUpload(),
            ),
            SizedBox(
              width: 8,
            ), // to bring images to this widget
            SizedBox(
              width: 450,
              height: 650,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // address1
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
                            : inputDecoration(
                                'Sqft',
                                _descriptionFocus.hasFocus,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    MouseRegion(
                      onEnter: (_) => setState(() => _isHovering = true),
                      onExit: (_) => setState(() => _isHovering = false),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _isHovering
                              ? Colors.black
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
