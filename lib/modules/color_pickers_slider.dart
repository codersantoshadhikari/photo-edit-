import 'package:flutter/material.dart';

import 'colors_picker.dart';

class ColorPickersSlider extends StatefulWidget {
  @override
  _ColorPickersSliderState createState() => _ColorPickersSliderState();
}

class _ColorPickersSliderState extends State<ColorPickersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      padding: EdgeInsets.all(20),
      height: 240,
      child: Column(
        children: [
          Center(
            child: Text(
              'Slider Filter Color'.toUpperCase(),
            ),
          ),
          Divider(),
          SizedBox(height: 20.0),
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
                    setState(() {});
                  },
                ),
              ),
              TextButton(
                child: Text('Reset'),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Text('Slider Opacity'),
          SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Slider(
                  value: 0.1,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (v) {},
                ),
              ),
              TextButton(
                child: Text('Reset'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
