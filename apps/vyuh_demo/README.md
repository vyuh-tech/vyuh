# Vyuh Demo

A Universal Demo showcasing the Vyuh Framework

> This app is powered by the [Vyuh Framework](https://vyuh.tech).

## 👋 Overview

### Technologies at play

- Dart
- Flutter
- Node.js
- React
- Vyuh Framework

### Folder Structure

- All apps are in the `/apps` directory. This includes the Flutter App and the
  Sanity Studio.
  - The Flutter Demo app is in the `/apps/vyuh_demo` directory
  - The Sanity Studio is in the `/apps/demo-studio` directory
- All example features are in the `/examples` directory
- All shared packages are in the `/examples/shared` directory

## 🚀 Getting Started

### [Step 1] Melos setup

This project uses [Melos](https://invertase.docs.page/melos) to manage the
monorepo. Activate the Melos package using the following command.

```sh
dart pub global activate melos
```

### [Step 2] Bootstrap the project

- Now we are ready to bootstrap the project with Melos. Run the following
  command in the root directory of the project.

```sh
melos bootstrap
```

- Install all the NPM packages

We rely on [Sanity](https://sanity.io) to handle the CMS part of the project. To
install all the related NPM packages, run the following command in the root
directory of the project.

```sh
pnpm install
```

> **Note**
>
> We assume you are already using PNPM as the package manager. If not, you can
> install it using `npm install -g pnpm`. For more details on installing PNPM,
> visit https://pnpm.io/installation.

### [Step 3] Running the project 🚀

#### [3.1] Pre-requisites to run app locally

1. Create a file called `.env` inside `<vyuh-repo-directory>/apps/vyuh_demo`
2. Get the keys for the various APIs used in the project

- TMDB keys: https://www.themoviedb.org/
- Unsplash keys: https://unsplash.com/

3. Add these keys to the `.env` file

```
TMDB_API_KEY=<TMDB-API-KEY>
UNSPLASH_ACCESS_KEY=<UNSPLASH-ACCESS-KEY>
UNSPLASH_SECRET_KEY=<UNSPLASH-SECRET-KEY>
```

#### [3.2] Running the Apps

- To run the Flutter app, run the following command in the `apps/vyuh_demo`
  directory of the project.

```sh
flutter run
```

- To bring up the Sanity Studio, run the following command in the
  `apps/demo-studio` directory of the project.

```sh
pnpm run dev
```

#### Running on the Web

- Ensure you are passing `--web-port 8080` flag to `flutter run` command. This
  is required to ensure the Sanity pages are loaded correctly without any CORS
  issue.

## 👩🏻‍💻 Development

### Update Flutter dependencies

```sh
  melos exec -- flutter pub upgrade
```

### Update Node packages

```sh
  pnpm upgrade --recursive
```

### Format Dart files

```sh
melos exec -- dart format --set-exit-if-changed .
```
