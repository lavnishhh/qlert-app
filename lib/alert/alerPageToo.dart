import 'package:flutter/material.dart';

class Alerting extends StatefulWidget {
  @override
  _AlertingState createState() => _AlertingState();
}

class _AlertingState extends State<Alerting>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Alerting the Authorities!'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.red,
              gradient: RadialGradient(
                colors: [Colors.red, Colors.black],
                radius: _animation.value,
              ),
            ),
            child: Center(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.6),
                border: Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(50),
              ),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_rounded,
                            size: 30,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Upload pictures',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )),
                ),
              ),
            )),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
