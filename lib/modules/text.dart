import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'colors_picker.dart';

class TextEditorImage extends StatefulWidget {
  @override
  _TextEditorImageState createState() => _TextEditorImageState();
}

class _TextEditorImageState extends State<TextEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.black;
  double slider = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          align == TextAlign.left
              ? GestureDetector(
                  onTap: () {
                    setState(() => align = null);
                  },
                  child: Container(
                    child: Center(
                      child: Icon(FontAwesomeIcons.alignLeft),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(FontAwesomeIcons.alignLeft),
                  onPressed: () {
                    setState(
                      () {
                        align = TextAlign.left;
                      },
                    );
                  },
                ),
          align == TextAlign.center
              ? GestureDetector(
                  onTap: () {
                    setState(() => align = null);
                  },
                  child: Container(
                    child: Center(
                      child: Icon(FontAwesomeIcons.alignCenter),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(FontAwesomeIcons.alignCenter),
                  onPressed: () {
                    setState(() {
                      align = TextAlign.center;
                    });
                  },
                ),
          align == TextAlign.right
              ? GestureDetector(
                  onTap: () {
                    setState(() => align = null);
                  },
                  child: Container(
                    child: Center(
                      child: Icon(FontAwesomeIcons.alignRight),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(FontAwesomeIcons.alignRight),
                  onPressed: () {
                    setState(() {
                      align = TextAlign.right;
                    });
                  },
                ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: TextButton(
          child: Text('Add Text'),
          onPressed: () {
            Navigator.pop(context, {
              'name': name.text,
              'color': currentColor,
              'size': slider.toDouble(),
              'align': align,
            });
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Insert Your Message',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    alignLabelWithHint: true,
                  ),
                  scrollPadding: EdgeInsets.all(20),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 99999,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: true,
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Slider Color'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: BarColorPicker(
                            width: 300,
                            thumbColor: Colors.white,
                            cornerRadius: 10,
                            pickMode: PickMode.Color,
                            colorListener: (int value) {
                              setState(() {
                                currentColor = Color(value);
                              });
                            },
                          ),
                        ),
                        TextButton(
                          child: Text('Reset'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Text('Slider White Black Color'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: BarColorPicker(
                            width: 300,
                            thumbColor: Colors.white,
                            cornerRadius: 10,
                            pickMode: PickMode.Grey,
                            colorListener: (int value) {
                              setState(() {
                                currentColor = Color(value);
                              });
                            },
                          ),
                        ),
                        TextButton(
                          child: Text('Reset'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Size Adjust'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            value: slider,
                            min: 0.0,
                            max: 100.0,
                            onChangeEnd: (v) {
                              setState(() => slider = v);
                            },
                            onChanged: (v) {
                              setState(() => slider = v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextAlign? align;
}
