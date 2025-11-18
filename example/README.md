# example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# set CORS on web instance test
create cors.json file at project root
[
  {
    "origin": ["*"],
    "method": ["GET", "POST", "PUT", "DELETE"],
    "maxAgeSeconds": 3600
  }
]
install gsutil -> brew install --cask google-cloud-sdk
authenticate gcloud access -> gcloud auth login
set project target -> gcloud config set project automatic-palm-tree
set cors -> gsutil cors set cors.json gs://automatic-palm-tree.firebasestorage.app

