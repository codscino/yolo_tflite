    import 'package:flutter/services.dart';
    import 'package:tflite_flutter/tflite_flutter.dart';
    import 'package:image/image.dart' as img;
    
    testYolov8() async {
      img.Image? image = await _loadImage('assets/images/any_image.jpg');
      Interpreter _interpreter =
          await Interpreter.fromAsset('assets/models/yolov8s_float16.tflite');
      final input = _preProcess(image!);
    
      // output shape:
      // 1 : batch size
      // 4 + 80: left, top, right, bottom and probabilities for each class
      // 8400: num predictions
      final output = List<num>.filled(1 * 84 * 8400, 0).reshape([1, 84, 8400]);
      int predictionTimeStart = DateTime.now().millisecondsSinceEpoch;
      _interpreter.run([input], output);
      int predictionTime =
          DateTime.now().millisecondsSinceEpoch - predictionTimeStart;
      print('Prediction time: $predictionTime ms');
    }
    
    Future<img.Image?> _loadImage(String imagePath) async {
      final imageData = await rootBundle.load(imagePath);
      return img.decodeImage(imageData.buffer.asUint8List());
    }
    
    List<List<List<num>>> _preProcess(img.Image image) {
      final imgResized = img.copyResize(image, width: 640, height: 640);
    
      return convertImageToMatrix(imgResized);
    }
    
    // yolov8 requires input normalized between 0 and 1
    List<List<List<num>>> convertImageToMatrix(img.Image image) {
      return List.generate(
        image.height,
        (y) => List.generate(
          image.width,
          (x) {
            final pixel = image.getPixel(x, y);
            return [pixel.rNormalized, pixel.gNormalized, pixel.bNormalized];
          },
        ),
      );
    }