import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Text Animation',
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

  FadingTextAnimation({required this.toggleTheme, required this.isDarkMode});

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _startFadingAnimation();
  }

  void _startFadingAnimation() {
    // Automatically toggle visibility every 2 seconds.
    Future.delayed(Duration(seconds: 2), () {
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
        // First Animation Page
        Scaffold(
          appBar: AppBar(
            title: const Text('Fading Text Animation'),
            actions: [
              IconButton(
                icon: Icon(
                  widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                ),
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
            child: const Icon(Icons.play_arrow),
            backgroundColor: _textColor,
          ),
        ),

        // Second Animation Page with Different Duration
        Scaffold(
          appBar: AppBar(
            title: const Text('Different Fading Animation'),
            actions: [
              IconButton(
                icon: Icon(
                  widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                ),
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
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOut,
                  child: Text(
                    'Fancy Fading Animation!',
                    style: TextStyle(
                      fontSize: 24,
                      color: _textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '← Swipe right to go back',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: toggleVisibility,
            child: const Icon(Icons.play_arrow),
            backgroundColor: _textColor,
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
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
  }) : super(key: key);

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
    return Container(
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
