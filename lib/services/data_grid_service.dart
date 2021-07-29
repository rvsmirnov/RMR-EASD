import 'package:MWPX/styles/mwp_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataGridService {
  DataGridSortDirection getsortDirectionValue(String string) {
    if (string == 'DataGridSortDirection.ascending') {
      return DataGridSortDirection.ascending;
    }
    // if (string == 'DataGridSortDirection.descending') {
    return DataGridSortDirection.descending;
    // }
  }

  static Widget getExecLight({String? value, Color? backgroundColor}) {
    bool red = false;
    bool yellow = false;
    bool green = false;

    // Что делать, если cl4 cl5 cl6?

    if (value == 'cl1red') {
      red = true;
    }
    if (value == 'cl2yellow') {
      yellow = true;
    }
    if (value == 'cl3green') {
      green = true;
    }

    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black87, // border color
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(2), // border width
              child: Container(
                // or ClipRRect if you need to clip the content
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: red ? Colors.red : Colors.grey, // inner circle color
                ),
                child: Container(), // inner content
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black87, // border color
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(2), // border width
              child: Container(
                // or ClipRRect if you need to clip the content
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: yellow
                      ? Colors.yellow
                      : Colors.grey, // inner circle color
                ),
                child: Container(), // inner content
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black87, // border color
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(2), // border width
              child: Container(
                // or ClipRRect if you need to clip the content
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      green ? Colors.green : Colors.grey, // inner circle color
                ),
                child: Container(), // inner content
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color getRowBackgroundColor(int index) {
    if (index % 2 != 0) {
      return MWPColors.mwpTableRowBackroundLight;
    }
    return MWPColors.mwpTableRowBackroundDark;
  }
}
