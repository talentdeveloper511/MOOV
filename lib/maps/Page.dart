
import 'package:flutter/material.dart';

abstract class Pager extends StatelessWidget {
  const Pager(this.leading, this.title);

  final Widget leading;
  final String title;
}