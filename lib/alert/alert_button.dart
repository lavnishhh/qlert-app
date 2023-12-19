import 'package:flutter/material.dart';
import 'package:qlert/alert/alerPageToo.dart';

class BreathingButton extends StatefulWidget {
  @override
  _BreathingButtonState createState() => _BreathingButtonState();
}

class _BreathingButtonState extends State<BreathingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Create a tween for text size
        final textSizeTween =
            Tween<double>(begin: 20, end: 30).animate(_animationController);

        // Create a tween for text shadow opacity
        final shadowOpacityTween =
            Tween<double>(begin: 0.2, end: 0.8).animate(_animationController);

        return Hero(
          tag: 'alert-add',
          child: ElevatedButton(
            onPressed: () {
              // Add your button action here
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Alerting()));
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(32), // Larger padding for a bigger button
              primary: Colors.red, // Red button color
              shape: CircleBorder(), // Circular shape
              shadowColor: Colors.black.withOpacity(shadowOpacityTween.value),
              elevation: 30 * _animationController.value,
            ),
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 500),
              style: TextStyle(
                fontSize: textSizeTween.value,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(0, 0),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text('Alert!'),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
