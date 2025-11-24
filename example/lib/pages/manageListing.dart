import 'package:example/pages/AuthenticationService.dart';
import 'package:example/pages/ListingDocumentService.dart';
import 'package:example/pages/ListingCover.dart';
import 'package:example/pages/ListingDetails.dart';
import 'package:example/pages/ListingImages.dart';
import 'package:example/pages/StorageService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EditListing extends StatefulWidget {
  const EditListing({super.key});

  @override
  State<EditListing> createState() => _EditListingState();
}

class _EditListingState extends State<EditListing> {
  late ListingDocument finalListing;
  late String _agent = "";
  late String _address1 = "";
  late String _address2 = "";
  late String _price = "0.0";
  late String _status = "";
  late String _beds = "0.0";
  late String _baths = "0.0";
  late String _sqft = "0.0";
  late String _description = "";
  late String _cover = "";
  late List<String> _assets = [];
  double progress = 0.0;
  bool _isUploading = false;
  bool _coverUploaded = false;
  bool _assetsUploaded = false;
  bool _detailsSaved = false;
  var _isHovering = false;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Save Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _saveListing() {
    if (_coverUploaded && _assetsUploaded && _detailsSaved) {
      setState(() {
        finalListing = ListingDocument(
          id: "",
          agent: _agent,
          address1: _address1,
          address2: _address2,
          price: _price,
          status: _status,
          beds: _beds,
          baths: _baths,
          sqft: _sqft,
          liked: [],
          loved: [],
          comments: [],
          description: _description,
          cover: _cover,
          assets: _assets,
          dateCreated: DateTime.now(),
          dateUpdated: DateTime.now(),
        );
      });
    }
  }

  void _saveDetails(
    String address1,
    String address2,
    String price,
    String status,
    String beds,
    String baths,
    String sqft,
    String description,
  ) {
    setState(() {
      _address1 = address1;
      _address2 = address2;
      _price = price;
      _status = status;
      _beds = beds;
      _baths = baths;
      _sqft = sqft;
      _description = description;
      _detailsSaved = true;
    });
  }

  void _saveImages(List<String> assets) {
    setState(() {
      _assets = assets;
      _assetsUploaded = true;
    });
  }

  void _saveCover() async {
    try {
      var file = await StorageService().pickFiles(false);
      setState(() {
        _isUploading = true;
      });
      var url = await StorageService().upload(
        file[0],
        onProgress: (p) {
          setState(() {
            progress = p;
          });
        },
      );
      setState(() {
        _cover = url;
      });
    } on FirebaseException catch (e) {
      if (!context.mounted) return;
      _showErrorDialog(context, e.message ?? 'Error uploading!');
    }
    setState(() {
      _isUploading = false;
      _coverUploaded = true;
    });
  }

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
                      child: ListingCover(
                        width: width,
                        height: height,
                        imageUrl: _cover,
                        onUploadPressed: _saveCover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ListingImages(
                        width: width,
                        height: height,
                        onUploadComplete: _saveImages,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ListingDetails(
                        width: width,
                        height: height,
                        onSave: _saveDetails,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                _coverUploaded && _assetsUploaded && _detailsSaved
                    ? MouseRegion(
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
                          onPressed: () async {
                            final currentUser =
                                AuthenticationService().currentUser;
                            if (currentUser != null) {
                              _agent = currentUser.email!;
                            }
                            final listing = ListingDocument(
                              id: "",
                              agent: _agent,
                              address1: _address1,
                              address2: _address2,
                              price: _price,
                              status: _status,
                              beds: _beds,
                              baths: _baths,
                              sqft: _sqft,
                              liked: [],
                              loved: [],
                              comments: [],
                              description: _description,
                              cover: _cover,
                              assets: _assets,
                              dateCreated: DateTime.now(),
                              dateUpdated: DateTime.now(),
                            );
                            try {
                              finalListing = await ListingDocumentService()
                                  .createListing(listing);
                            } on FirebaseException catch (e) {
                              if (!context.mounted) return;
                              _showErrorDialog(
                                context,
                                e.message ?? "Authentication failed.",
                              );
                            }
                          },
                          child: Text("Save"),
                        ),
                      )
                    : SizedBox(), // add preview and cancel options
              ],
            ),
          ],
        );
      },
    );
  }
}
