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
                    showDialog(
                      context: bottomSheetContext,
                      builder: ((dialogContext) {
                        return AlertDialog(
                          title: Text("Xóa ảnh"),
                          content:
                              Text("Bạn chắc chắn muốn ảnh của ghi chú này?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: Text(
                                "Hủy",
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.pop(bottomSheetContext, true);
                              },
                              child: Text(
                                "Xác nhận",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                    // Trả về true
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
