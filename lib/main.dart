import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Text & Image Animation',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: FadingTextAnimation(
        toggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  const FadingTextAnimation({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  bool _isRounded = false;
  Color _textColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _startFadingAnimation();
  }

  void _startFadingAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isVisible = !_isVisible;
        });
        _startFadingAnimation();
      }
    });
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void toggleImageShape() {
    setState(() {
      _isRounded = !_isRounded;
    });
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _textColor,
              onColorChanged: (Color color) {
                setState(() {
                  _textColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        // First Page: Fading Text Animation
        Scaffold(
          appBar: AppBar(
            title: const Text('Fading Text Animation'),
            actions: [
              IconButton(
                icon: Icon(widget.isDarkMode
                    ? Icons.wb_sunny
                    : Icons.nightlight_round),
                onPressed: () => widget.toggleTheme(),
                tooltip: 'Toggle Theme',
              ),
              IconButton(
                icon: const Icon(Icons.color_lens),
                onPressed: _showColorPicker,
                tooltip: 'Change Text Color',
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: Text(
                    'Hello, Flutter!',
                    style: TextStyle(fontSize: 24, color: _textColor),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Swipe left for another animation →',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: toggleVisibility,
            backgroundColor: _textColor,
            child: const Icon(Icons.play_arrow),
          ),
        ),

        // Second Page: Animated Image with Rounded Corners
        Scaffold(
          appBar: AppBar(
            title: const Text('Animated Asset Image'),
            actions: [
              IconButton(
                icon: Icon(widget.isDarkMode
                    ? Icons.wb_sunny
                    : Icons.nightlight_round),
                onPressed: () => widget.toggleTheme(),
                tooltip: 'Toggle Theme',
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_isRounded ? 100 : 10),
                    image: const DecorationImage(
                      image: AssetImage('assets/cat.jpg'), // Using Asset Image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: toggleImageShape,
                  child: const Text('Animate Image'),
                ),
                const SizedBox(height: 30),
                const Text(
                  '← Swipe right to go back',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// A simple color picker widget to avoid dependency issues
class BlockPicker extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const BlockPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  _BlockPickerState createState() => _BlockPickerState();
}

class _BlockPickerState extends State<BlockPicker> {
  final List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [
          for (Color color in _colors)
            InkWell(
              onTap: () => widget.onColorChanged(color),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: widget.pickerColor == color ? Colors.white : color,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
