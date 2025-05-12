import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';

Future<bool> eventImage(BuildContext context, String url) async {
  bool isDeleteImage = false;
  isDeleteImage = await showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        builder: (bottomSheetContext) {
          return Scaffold(
            appBar: AppBar(
              leading: null,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(bottomSheetContext, true); // Trả về true
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
            body: Image.network(
              url,
              height: bottomSheetContext.height,
              width: bottomSheetContext.width,
            ),
          );
        },
      ) ??
      false; 

  return isDeleteImage;
}
