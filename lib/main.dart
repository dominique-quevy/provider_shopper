// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart'
    show
        MaterialApp,
        runApp,
        Widget,
        WidgetsFlutterBinding,
        BuildContext,
        /*
        Size,
        Rect,
        */
        StatelessWidget;
import 'package:go_router/go_router.dart' show GoRouter, GoRoute;
import 'package:provider/provider.dart'
    show Provider, ChangeNotifierProxyProvider, MultiProvider;
/*
        https://pub.dev/documentation/provider/latest/provider/Provider-class.html
         
        Provider<T> class
          A Provider that manages the lifecycle of the value it provides
          by delegating to a pair of Create and Dispose.

          It is usually used to avoid making a StatefulWidget for something trivial,
          such as instantiating a BLoC.

          Provider is the equivalent of a State.initState combined with State.dispose.
          Create is called only once in State.initState. 
          We cannot use InheritedWidget as it requires the value
          to be constructor-initialized and final.
*/

import 'package:provider_shopper/common/theme.dart';

import 'package:provider_shopper/models/cart.dart';
import 'package:provider_shopper/models/catalog.dart';

import 'package:provider_shopper/screens/cart.dart';
import 'package:provider_shopper/screens/catalog.dart';
import 'package:provider_shopper/screens/login.dart';

/*
import 'package:window_size/window_size.dart';
  //Desktop Embedding for Flutter
  //https://github.com/google/flutter-desktop-embedding
  //This project was originally created to develop Windows, macOS, and Linux embeddings of Flutter.
  //That work has since become part of Flutter, and all that remains here are experimental,
  //early-stage desktop plugins.
  //If you want to get started with Flutter on desktop, 
  //the place to start is now the Flutter documentation, 
  //rather than this project. 
  //You will already need to have followed the instructions there to get an application 
  //running on desktop before using any of the plugins here.
*/

void main() {
  setupWindow();
  runApp(const MyApp());
}

const double windowWidth = 400;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    /*
    setWindowTitle('Provider Demo');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
    */
  }
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const MyLogin(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const MyCatalog(),
        routes: [
          GoRoute(
            path: 'cart',
            builder: (context, state) => const MyCart(),
          ),
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Provider Demo',
        theme: appTheme,
        routerConfig: router(),
      ),
    );
  }
}
