import 'package:flutter/material.dart';

import '../coderjava_image_editor_pro.dart';

class TextAddEdit extends StatefulWidget {
  final int? index;
  final Map? mapValue;
  final bool? isEdit;

  const TextAddEdit({
    Key? key,
    this.mapValue,
    this.index,
    this.isEdit,
  }) : super(key: key);

  @override
  _TextAddEditState createState() => _TextAddEditState();
}

class _TextAddEditState extends State<TextAddEdit> {
  final formState = GlobalKey<FormState>();
  final textFieldController = TextEditingController();

  @override
  void initState() {
    if (widget.isEdit!) {
      textFieldController.text = widget.mapValue!['name'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final paddingBottom = mediaQueryData.padding.bottom;
    final insetBottom = mediaQueryData.viewInsets.bottom;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          top: 16,
          right: 16,
          bottom: paddingBottom > 0
              ? paddingBottom + insetBottom
              : 16 + insetBottom,
        ),
        child: Form(
          key: formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  widget.isEdit! ? 'Edit Text' : 'Add Text',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              TextFormField(
                controller: textFieldController,
                decoration: InputDecoration(
                  hintText: 'Insert your message',
                ),
                onChanged: (value) {
                  widgetJson[widget.index!]!['name'] = value;
                },
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please insert your message'
                      : null;
                },
              ),
              SizedBox(height: 8),
              Text('Size adjust'),
              Slider(
                  activeColor: Colors.black,
                  inactiveColor: Colors.grey,
                  value: widgetJson[widget.index!]!['size'],
                  min: 0.0,
                  max: 100.0,
                  onChangeEnd: (value) {
                    setState(() =>
                        widgetJson[widget.index!]!['size'] = value.toDouble());
                  },
                  onChanged: (value) {
                    setState(() {
                      slider = value;
                      widgetJson[widget.index!]!['size'] = value.toDouble();
                    });
                  }),
              SizedBox(height: 8),
              widget.isEdit!
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widgetJson.removeAt(widget.index!);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            child: Text('REMOVE'),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                            child: Text('UPDATE'),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formState.currentState!.validate()) {
                            Navigator.pop(context, true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        child: Text('SAVE TEXT'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
