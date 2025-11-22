import 'package:example/documents/listing/ListingDocumentService.dart';
import 'package:example/documents/listing/components/ListingCover.dart';
import 'package:example/documents/listing/components/ListingDetails.dart';
import 'package:example/documents/listing/components/ListingImages.dart';
import 'package:flutter/material.dart';
class EditListing extends StatefulWidget {
  const EditListing({super.key});

  @override
  State<EditListing> createState() => _EditListingState();
}

class _EditListingState extends State<EditListing> {
  String selectedCover = "";
  List<String> selectedImages = [];


  // void saveListing(String selectedCover) {
  //   setState(() {
  //     listing = ListingDocument(
  //       id: "", 
  //       agent: agent, 
  //       address1: address1, 
  //       address2: address2, 
  //       price: price, 
  //       status: status, 
  //       beds: beds, 
  //       baths: baths, 
  //       sqft: sqft, 
  //       liked: liked, 
  //       loved: loved, 
  //       comments: comments, 
  //       description: description, 
  //       cover: cover, 
  //       assets: assets, 
  //       dateCreated: dateCreated, 
  //       dateUpdated: dateUpdated);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ListingCover(width: width, height: height),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ListingImages(width: width, height: height),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ListingDetails(width: width, height: height),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
