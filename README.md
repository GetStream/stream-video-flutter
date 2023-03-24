# Official Flutter packages for the [Stream Video SDK](https://getstream.io/video/sdk/flutter/)

## Quick Links

- [Register](https://getstream.io/video/) to get an API key for Stream Video
- [Sample apps](https://github.com/GetStream/stream-video-flutter/tree/main/examples)

This repository contains code for our [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/) video clients.

We use [melos](https://melos.invertase.dev) to manage this repository.

## Understanding the structure of the repository

* The `packages` folder contains the packages and plugins that the SDK consists of.
* The `examples` folder holds the samples created using the Flutter Video SDK.
* The `docusaurus` folder contains the documentation and guides.
* The `dogfooding` folder contains a complete example app that implements all of the features of the SDK.

## Process to get started with this repository

1. Clone the base repository
2. All API keys and users used in the sample apps are to be stored in a filed named '.env' at the root of the project. 
3. You will find a template for the env file entitled 'env.sample' at the root of the project. Fill out this template and store it as '.env'.
4. Run `melos postclean` to clean the project.
5. Run `melos bootstrap` to fetch dependencies for all projects.
6. Run `melos generate:all` to generate the required env files. If there are any changes in the '.env' file, regenerate this.
7. You can now run any app in the project or start making changes to the SDK.

If you see any unexpected behaviour in the repository, feel free to [file an issue](https://github.com/GetStream/stream-video-flutter/issues/new) in the repository.

