import 'package:flutter/material.dart';
import '../extension/context_extension.dart';

InputDecoration borderRadiusTopLeftAndBottomRight(
        BuildContext context, String hintText) =>
    InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
        ));

InputDecoration borderRadiusAll(BuildContext context, String hintText) =>
    InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(context.normalRadius),
        ));
