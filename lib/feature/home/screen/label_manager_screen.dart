import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/home/model/label_model.dart';
import 'package:quan_ly_chi_tieu/feature/home/screen/create_or_update_label.dart';
import 'package:quan_ly_chi_tieu/product/constants/icon/icon_constants.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';

import '../../../product/base/bloc/base_bloc.dart';
import '../../../product/services/api_services.dart';
import '../bloc/home_bloc.dart';

class LabelManagerScreen extends StatefulWidget {
  const LabelManagerScreen({super.key, required this.value});
  final int value;
  @override
  State<LabelManagerScreen> createState() => _LabelManagerScreenState();
}

class _LabelManagerScreenState extends State<LabelManagerScreen> {
  late HomeBloc homeBloc;
  APIServices apiServices = APIServices();
  bool isMoneySpent = true;
  bool isDeleteDisplay = false;
  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of(context);
  }

  void onClickDeleteLabel(LabelModel label) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Center(child: Text("Thông báo")),
          content: Row(
            children: [
              Text("Bạn có chắc chắn muốn xóa "),
              Text(
                label.name!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("?")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text("Hủy bỏ"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: homeBloc.streamIsMoneySpend,
      builder: (context, isMoneySpendSnapshot) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(widget.value == 0
                ? "Chỉnh sửa tiền chi"
                : "Chỉnh sửa tiền thu"),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  isDeleteDisplay = !isDeleteDisplay;
                  homeBloc.sinkIsDeleledDisplay.add(isDeleteDisplay);
                },
                child: Text("Chỉnh sửa"),
              )
            ],
          ),
          body: StreamBuilder<List<LabelModel>>(
            stream: homeBloc.streamLabelsByCategory,
            builder: (context, labelsSnapshot) {
              if (labelsSnapshot.data == null) {
                homeBloc.getLabelByCategory(context, widget.value);
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return StreamBuilder<bool>(
                  stream: homeBloc.streamIsDeleledDisplay,
                  initialData: isDeleteDisplay,
                  builder: (context, isDeleteDisplaySnapshot) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: context.paddingLow,
                        child: Column(
                          children: [
                            Card(
                              child: ListTile(
                                onTap: () {
                                  createOrUpdateLabel(context, LabelModel(),
                                      homeBloc, widget.value);
                                },
                                title: Text("Thêm danh mục"),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                            Divider(),
                            ...labelsSnapshot.data!.map(
                              (label) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      createOrUpdateLabel(context, label,
                                          homeBloc, widget.value);
                                    },
                                    leading: isDeleteDisplaySnapshot.data!
                                        ? SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: IconButton(
                                              onPressed: () =>
                                                  onClickDeleteLabel(label),
                                              icon: Icon(
                                                Icons.remove,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        Colors.red),
                                              ),
                                            ),
                                          )
                                        : null,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          IconConstants.instance
                                              .getIcon(label.iconName!),
                                          width: 25,
                                          height: 25,
                                          color: Color(int.parse(label.color!)),
                                        ),
                                        SizedBox(width: context.lowValue),
                                        Text(label.name!),
                                      ],
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
