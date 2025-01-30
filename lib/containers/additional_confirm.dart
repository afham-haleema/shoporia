import 'package:flutter/material.dart';

class AdditionalConfirm extends StatefulWidget {
  final String contentType;
  final VoidCallback onYes, onNo;
  const AdditionalConfirm(
      {super.key,
      required this.contentType,
      required this.onNo,
      required this.onYes});

  @override
  State<AdditionalConfirm> createState() => _AdditionalConfirmState();
}

class _AdditionalConfirmState extends State<AdditionalConfirm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure'),
      content: Text(widget.contentType),
      actions: [
        TextButton(onPressed: widget.onNo, child: const Text('No')),
        TextButton(onPressed: widget.onYes, child: const Text('Yes'))
      ],
    );
  }
}
