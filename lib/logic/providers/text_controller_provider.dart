import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_controller_provider.g.dart';

@riverpod
TextEditingController textController(TextControllerRef ref) {
  return TextEditingController();
}
