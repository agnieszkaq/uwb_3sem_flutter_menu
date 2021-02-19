# flutter_menu - Menu Restaurant list 

A new Flutter application.

## Table of contents
* [Getting Started](#getting-started)
* [Technologies](#technologies)
* [Setup](#setup)
* [Addictional Information](#addictional-information)
* [Functionality](#functionality)
* [View](#view)

## Getting Started

This project is a starting point for a Flutter application.
It' s my first project in Dart language and Flutter for android application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Technologies

1. Android Studio 4.1.1
2. Flutter 1.22.5 
3. Dart 2.10.4
4. Emulator: Galaxy Nexus API 23
5. Google Fonts:
   - Lobster-Regular
   - Pacifico-Regular

## Setup 
To run this project, please install the above-mentioned technologies, the version will be compatible with mine. 
Import project from my github. Before project start, check that your emulator is running. 
If, the main page shows text: "Loading...", check your phone Interent connection, or link to data from main.dart file.

## Addictional Information 
1. About Internet connection:
   - check that in your AnroidManifest.xml You add perrmistion to Internet use: 
      - <uses-permission android:name="android.permission.INTERNET"/>
2. Packages:
   - check that in your pubspec.yml, you add depenencies such as:
     - sdk: flutter
     - http: ^0.12.0
     - cached_network_image: ^ 2.0.0
     - flutter_cache_manager: ^1.1.3

## Functionality
* json data cached, using DefaultCacheManager(),
* Internet image cached, using CachedNetworkImageProvider(),
* getting json from gist.github,fill data from json to object, creating list od this data, 
* using FutureBuilder(), to build list of objects,
* use card widgets to show data

## View

#### The main page consist of list of a products, from JSON file:

![](/images/main_list.JPG)

#### When click on specific list, we are push to new page, that show ditails about this product: 

![](/images/meal.JPG)

#### We can also find information such as calories, macronutrients and exact information about the meal:
 ![](/images/meal_description.JPG)

#### When we don't have connection the Internet and our JSON is not cacheable yet, the default view is text: "Loading...": 
![](/images/loading.JPG)

