import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:coderjava_image_editor_pro/modules/all_emojies.dart';
import 'package:coderjava_image_editor_pro/modules/bottombar_container.dart';
import 'package:coderjava_image_editor_pro/modules/color_filter_generator.dart';
import 'package:coderjava_image_editor_pro/modules/colors_picker.dart';
import 'package:coderjava_image_editor_pro/modules/emoji.dart';
import 'package:coderjava_image_editor_pro/modules/sliders.dart';
import 'package:coderjava_image_editor_pro/modules/text_add_edit.dart';
import 'package:coderjava_image_editor_pro/modules/textview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

TextEditingController heightController = TextEditingController();
TextEditingController widthController = TextEditingController();
var width = 300;
var height = 300;
List<Map?> widgetJson = [];
var howmuchwidgetis = 0;
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller =
    SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class CoderJavaImageEditorPro extends StatefulWidget {
  final Color? appBarColor;
  final Color? bottomBarColor;
  final Directory? pathSave;
  final double? pixelRatio;
  final String? defaultPathImage;
  final bool isShowingChooseImage;
  final bool isShowingBrush;
  final bool isShowingText;
  final bool isShowingFlip;
  final bool isShowingRotate;
  final bool isShowingBlur;
  final bool isShowingEraser;
  final bool isShowingFilter;
  final bool isShowingEmoji;

  CoderJavaImageEditorPro({
    this.appBarColor,
    this.bottomBarColor,
    this.pathSave,
    this.pixelRatio,
    this.defaultPathImage,
    this.isShowingChooseImage = true,
    this.isShowingBrush = true,
    this.isShowingText = true,
    this.isShowingFlip = true,
    this.isShowingRotate = true,
    this.isShowingBlur = true,
    this.isShowingEraser = true,
    this.isShowingFilter = true,
    this.isShowingEmoji = true,
  });

  @override
  _CoderJavaImageEditorProState createState() =>
      _CoderJavaImageEditorProState();
}

var slider = 0.0;

class _CoderJavaImageEditorProState extends State<CoderJavaImageEditorPro> {
  // Create some values
  Color pickerColor = Color(0xFF443A49);
  Color currentColor = Color(0xFF443A49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller =
        SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset?> _points = <Offset?>[];
  List type = [];
  List alignment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  File? _image;
  ScreenshotController screenshotController = ScreenshotController();
  late Timer timeprediction;

  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.defaultPathImage != null &&
          widget.defaultPathImage!.isNotEmpty) {
        var fileImage = File(widget.defaultPathImage!);
        if (fileImage.existsSync()) {
          final decodedImage =
              await decodeImageFromList(fileImage.readAsBytesSync());
          setState(() {
            width = decodedImage.width;
            height = decodedImage.height;
            _image = File(fileImage.path);
            _controller.clear();
          });
        }
      }
    });

    timers();
    _controller.clear();
    type.clear();
    offsets.clear();
    howmuchwidgetis = 0;
    super.initState();
  }

  @override
  void dispose() {
    timeprediction.cancel();
    _controller.clear();
    widgetJson.clear();
    heightController.clear();
    widthController.clear();
    super.dispose();
  }

  double flipValue = 0;
  int rotateValue = 0;
  double blurValue = 0;
  double opacityValue = 0;
  Color colorValue = Colors.transparent;

  double hueValue = 0;
  double brightnessValue = 0;
  double saturationValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaf,
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        actions: [
          widget.isShowingChooseImage
              ? IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => bottomsheets(),
                )
              : Container(),
          TextButton(
            child: Text('SAVE'),
            onPressed: () {
              screenshotController
                  .capture(pixelRatio: widget.pixelRatio ?? 1.5)
                  .then((binaryIntList) async {
                final paths = widget.pathSave ?? await getTemporaryDirectory();
                final file = await File(
                        '${paths.path}/' + DateTime.now().toString() + '.jpg')
                    .create();
                file.writeAsBytesSync(binaryIntList!);
                Navigator.pop(context, file);
              }).catchError((onError) {
                print(onError);
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
        backgroundColor: widget.appBarColor ?? Colors.black87,
      ),
      bottomNavigationBar:
          openbottomsheet ? Container() : _buildWidgetListMenu(),
      body: Screenshot(
        controller: screenshotController,
        child: Center(
          child: RotatedBox(
            quarterTurns: rotateValue,
            child: imageFilterLatest(
              hue: hueValue,
              brightness: brightnessValue,
              saturation: saturationValue,
              child: Container(
                margin: EdgeInsets.all(20),
                color: Colors.white,
                width: width.toDouble(),
                height: height.toDouble(),
                child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: [
                      _image != null
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(flipValue),
                              child: ClipRect(
                                child: Container(
                                  width: width.toDouble(),
                                  height: height.toDouble(),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment.center,
                                      fit: BoxFit.fitHeight,
                                      image: FileImage(
                                        File(_image!.path),
                                      ),
                                    ),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: blurValue,
                                      sigmaY: blurValue,
                                    ),
                                    child: Container(
                                      color:
                                          colorValue.withOpacity(opacityValue),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        child: GestureDetector(
                          onPanUpdate: (DragUpdateDetails details) {
                            setState(() {
                              RenderBox object =
                                  context.findRenderObject() as RenderBox;
                              var _localPosition =
                                  object.globalToLocal(details.globalPosition);
                              _points = List.from(_points)..add(_localPosition);
                            });
                          },
                          onPanEnd: (DragEndDetails details) {
                            _points.add(null);
                          },
                          child: Signat(),
                        ),
                      ),
                      Stack(
                        children: widgetJson.asMap().entries.map((f) {
                          return type[f.key] == 1
                              ? EmojiView(
                                  left: offsets[f.key].dx,
                                  top: offsets[f.key].dy,
                                  ontap: () {
                                    scaf.currentState!
                                        .showBottomSheet((context) {
                                      return Sliders(
                                        index: f.key,
                                        mapValue: f.value,
                                      );
                                    });
                                  },
                                  onpanupdate: (details) {
                                    setState(() {
                                      offsets[f.key] = Offset(
                                          offsets[f.key].dx + details.delta.dx,
                                          offsets[f.key].dy + details.delta.dy);
                                    });
                                  },
                                  mapJson: f.value,
                                )
                              : type[f.key] == 2
                                  ? TextView(
                                      left: offsets[f.key].dx,
                                      top: offsets[f.key].dy,
                                      ontap: () {
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) {
                                              return TextAddEdit(
                                                index: f.key,
                                                mapValue: f.value,
                                                isEdit: true,
                                              );
                                            });
                                      },
                                      onpanupdate: (details) {
                                        setState(() {
                                          offsets[f.key] = Offset(
                                            offsets[f.key].dx +
                                                details.delta.dx,
                                            offsets[f.key].dy +
                                                details.delta.dy,
                                          );
                                        });
                                      },
                                      mapJson: f.value,
                                    )
                                  : Container();
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {});
    var future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('Select Image Options'),
              ),
              SizedBox(height: 10),
              Divider(height: 1),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var image =
                            await (picker.pickImage(source: ImageSource.gallery)
                                as FutureOr<PickedFile>);
                        var decodedImage = await decodeImageFromList(
                            File(image.path).readAsBytesSync());
                        setState(() {
                          height = decodedImage.height;
                          width = decodedImage.width;
                          _image = File(image.path);
                        });
                        setState(() {
                          _controller.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library),
                            SizedBox(width: 10),
                            Text('Open Gallery'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    GestureDetector(
                      onTap: () async {
                        var image =
                            await (picker.pickImage(source: ImageSource.camera)
                                as FutureOr<PickedFile>);
                        var decodedImage = await decodeImageFromList(
                            File(image.path).readAsBytesSync());

                        setState(() {
                          height = decodedImage.height;
                          width = decodedImage.width;
                          _image = File(image.path);
                        });
                        setState(() => _controller.clear());
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt),
                            SizedBox(width: 10),
                            Text('Open Camera'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }

  Widget _buildWidgetListMenu() {
    final listMenu = <Widget>[];
    if (widget.isShowingBrush) {
      listMenu.add(
        BottomBarContainer(
          colors: widget.bottomBarColor,
          icons: FontAwesomeIcons.brush,
          title: 'Brush',
          ontap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          setState(() => currentColor = pickerColor);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          },
        ),
      );
    }

    if (widget.isShowingText) {
      listMenu.add(
        BottomBarContainer(
          title: 'Text',
          colors: widget.bottomBarColor,
          icons: Icons.text_fields,
          ontap: () async {
            type.add(2);
            final defaultText = {
              'name': 'Insert your message',
              'color': Colors.black,
              'size': 12.0,
              'align': TextAlign.left,
            };
            widgetJson.add(defaultText);
            offsets.add(Offset.zero);
            howmuchwidgetis++;
            var value = await showModalBottomSheet(
              context: context,
              builder: (context) {
                return TextAddEdit(
                  index: widgetJson.length - 1,
                  mapValue: defaultText,
                  isEdit: false,
                );
              },
            );
            if (value == null) {
              widgetJson.removeLast();
            }
          },
        ),
      );
    }

    if (widget.isShowingFlip) {
      listMenu.add(
        BottomBarContainer(
          title: 'Flip',
          colors: widget.bottomBarColor,
          icons: Icons.flip,
          ontap: () {
            setState(() {
              flipValue = flipValue == 0 ? math.pi : 0;
            });
          },
        ),
      );
    }

    if (widget.isShowingRotate) {
      listMenu.add(
        BottomBarContainer(
          title: 'Rotate Left',
          colors: widget.bottomBarColor,
          icons: Icons.rotate_left,
          ontap: () {
            setState(() {
              rotateValue--;
            });
          },
        ),
      );
      listMenu.add(
        BottomBarContainer(
            title: 'Rotate Right',
            colors: widget.bottomBarColor,
            icons: Icons.rotate_right,
            ontap: () {
              setState(() {
                rotateValue++;
              });
            }),
      );
    }

    if (widget.isShowingBlur) {
      listMenu.add(
        BottomBarContainer(
          title: 'Blur',
          colors: widget.bottomBarColor,
          icons: Icons.blur_on,
          ontap: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setS) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      height: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'Slider Filter Color'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 20),
                          Text(
                            'Slider Color',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
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
                                    setS(() {
                                      setState(() {
                                        colorValue = Color(value);
                                      });
                                    });
                                  },
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    setS(() {
                                      colorValue = Colors.transparent;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Slider Blur',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  value: blurValue,
                                  min: 0.0,
                                  max: 10.0,
                                  onChanged: (v) {
                                    setS(() {
                                      setState(() {
                                        blurValue = v;
                                      });
                                    });
                                  },
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setS(() {
                                    setState(() {
                                      blurValue = 0.0;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Slider Opacity',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  value: opacityValue,
                                  min: 0.00,
                                  max: 1.0,
                                  onChanged: (v) {
                                    setS(() {
                                      setState(() {
                                        opacityValue = v;
                                      });
                                    });
                                  },
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setS(() {
                                    setState(() {
                                      opacityValue = 0.0;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      );
    }

    if (widget.isShowingEraser) {
      listMenu.add(
        BottomBarContainer(
          colors: widget.bottomBarColor,
          icons: FontAwesomeIcons.eraser,
          ontap: () {
            _controller.clear();
            howmuchwidgetis = 0;
          },
          title: 'Eraser',
        ),
      );
    }

    if (widget.isShowingFilter) {
      listMenu.add(
        BottomBarContainer(
          title: 'Filter',
          colors: widget.bottomBarColor,
          icons: Icons.photo,
          ontap: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              context: context,
              builder: (context) {
                return Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setS) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            'Slider Hue',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  value: hueValue,
                                  min: -10.0,
                                  max: 10.0,
                                  onChanged: (v) {
                                    setS(() {
                                      setState(() {
                                        hueValue = v;
                                      });
                                    });
                                  },
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setS(() {
                                    setState(() {
                                      blurValue = 0.0;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Slider Saturation',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Slider(
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.grey,
                                    value: saturationValue,
                                    min: -10.0,
                                    max: 10.0,
                                    onChanged: (v) {
                                      setS(() {
                                        setState(() {
                                          saturationValue = v;
                                        });
                                      });
                                    }),
                              ),
                              TextButton(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setS(() {
                                    setState(() {
                                      saturationValue = 0.0;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Slider Brightness',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  value: brightnessValue,
                                  min: 0.0,
                                  max: 1.0,
                                  onChanged: (v) {
                                    setS(() {
                                      setState(() {
                                        brightnessValue = v;
                                      });
                                    });
                                  },
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setS(() {
                                    setState(() {
                                      brightnessValue = 0.0;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      );
    }

    if (widget.isShowingEmoji) {
      listMenu.add(
        BottomBarContainer(
          title: 'Emoji',
          colors: widget.bottomBarColor,
          icons: FontAwesomeIcons.faceSmile,
          ontap: () {
            var getemojis = showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Emojies();
              },
            );
            getemojis.then((value) {
              if (value['name'] != null) {
                type.add(1);
                widgetJson.add(value);
                offsets.add(Offset.zero);
                howmuchwidgetis++;
              }
            });
          },
        ),
      );
    }

    if (listMenu.length < 4) {
      return Row(
        children: listMenu.map((element) => Expanded(child: element)).toList(),
      );
    } else {
      // TODO: tampilkan bottom navigation bar untuk jumlah item lebih dari 4
      return Text('Coming soon');
    }
  }
}

Widget imageFilterLatest(
    {required brightness, required saturation, required hue, child}) {
  return ColorFiltered(
    colorFilter: ColorFilter.matrix(
      ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      ),
    ),
    child: ColorFiltered(
      colorFilter: ColorFilter.matrix(
        ColorFilterGenerator.saturationAdjustMatrix(
          value: saturation,
        ),
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(
          ColorFilterGenerator.hueAdjustMatrix(
            value: hue,
          ),
        ),
        child: child,
      ),
    ),
  );
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    // debug mode
    // _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Signature(
          controller: _controller,
          height: height.toDouble(),
          width: width.toDouble(),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
