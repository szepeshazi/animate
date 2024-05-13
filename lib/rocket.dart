import 'package:flutter/material.dart';

class SkyWidget extends StatelessWidget {
  const SkyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: const Center(
          child: Stack(
            children: [RocketWidget()],
          ),
        ));
  }
}

class RocketWidget extends StatefulWidget {
  const RocketWidget({Key? key}) : super(key: key);

  @override
  State<RocketWidget> createState() => _RocketWidgetState();
}

class _RocketWidgetState extends State<RocketWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 100,
      child: Container(
        color: Colors.red,
        width: 25,
        height: 25,
      ),
    );
  }
}
