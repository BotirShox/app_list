
import 'package:api_list/page/first_page.dart';
import 'package:api_list/theme/color.dart';
import 'package:flutter/material.dart';

void main() => runApp(

    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: primary
      ),
      home: LazyLoad(),
    )
);

