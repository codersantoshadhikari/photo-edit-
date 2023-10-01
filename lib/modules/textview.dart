import 'package:flutter/material.dart';

class TextView extends StatefulWidget {
  final double? left;
  final double? top;
  final Function? ontap;
  final Function(DragUpdateDetails)? onpanupdate;
  final Map? mapJson;
  const TextView({
    Key? key,
    this.left,
    this.top,
    this.ontap,
    this.onpanupdate,
    this.mapJson,
  }) : super(key: key);
  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: GestureDetector(
        onTap: widget.ontap as void Function()?,
        onPanUpdate: widget.onpanupdate,
        child: Text(
          widget.mapJson!['name'],
          textAlign: widget.mapJson!['align'],
          style: TextStyle(
            color: widget.mapJson!['color'],
            fontSize: widget.mapJson!['size'],
          ),
        ),
      ),
    );
  }
}
