---
title: Adding Packages
description: Learn how to add new packages to your Vyuh project
---

# Adding Packages

When adding packages to your Dart projects, there are two ways in which these
packages can be referenced inside your `pubspec.yaml`.

## Adding a Package from pub.dev

To add a package from [pub.dev](https://pub.dev), you can simply add the package
name to the `dependencies` section of your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  vyuh_core: ^1.0.0
```

For a list of all the packages which are publicly available on `pub.dev`, refer
to the [Framework](/framework/) documentation.

## Adding a Package from the Enterprise Package Registry

Adding a package from the private pub registry requires you to set up a token
for the hosted provider. You will get this `token` during the onboarding process
for the enterprise plan. Once you have this token, follow these steps:

1. **Keep the details handy**

   Keep the details of the hosted provider handy. You will need the URL of the
   hosted provider and the token to authenticate requests:

   - `<token>`: secret token to authenticate requests to the hosted provider
   - `<private-pub-registry>`: URL of the hosted provider

2. **Add the hosted provider**

   Use the `<token>` given to you during the onboarding stage:

   ```shell
   dart pub token add https://<private-pub-registry>
   Enter secret token: <Type token on stdin>
   Requests to "https://<private-pub-registry>" will now be
   authenticated using the secret token.
   ```

   ::: tip
   For more details on how to add a token, refer to the official Dart
   documentation on
   [adding a token](https://dart.dev/tools/pub/cmd/pub-token).
   :::

3. **Add the package to your `pubspec.yaml`**

   You can now add the package from the hosted provider:

   ```shell
   dart pub add --hosted-url=https://<private-pub-registry> <package-name>
   ```

   An easier way is to copy this snippet for each enterprise package and paste
   into your `pubspec.yaml`:

   ```yaml
   <package-name>:
     hosted: https://<private-pub-registry>
     version: ^1.0.0
   ```

4. **Bootstrap with Melos**

   Now when you run `melos bootstrap` inside your project, the package will be
   fetched from the hosted provider.

## Summary

This guide covers how to add packages from both the public and private package
registries. The private package registry requires you to set up a token for the
hosted provider. Once done, you can add the package to your `pubspec.yaml` and
run `melos bootstrap` to fetch the package.
