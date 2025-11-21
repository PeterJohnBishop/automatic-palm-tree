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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            FileUpload(),
            Column(
              children: [

              ],
            )
          ],
        )
      ],
    );
  }
}