import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/volume_control.dart';

class VolumeControlSlider extends StatefulWidget {
  @override
  _VolumeControlSliderState createState() => _VolumeControlSliderState();
}

class _VolumeControlSliderState extends State<VolumeControlSlider> {
  double _currentSliderValue = 0.2;

  @override
  void initState() {
    super.initState();
    initVolumeState();
  }

  //init volume_control plugin
  Future<void> initVolumeState() async {
    if (!mounted) return;

    //read the current volume
    try {
      _currentSliderValue = await VolumeControl.volume;
    } catch (e) {
      Get.snackbar("Error", "No sound device found");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        height: 50,
        width: Get.mediaQuery.size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Theme.of(context).accentColor,
        ),
        child: Column(
          children: [
            // Text("Volume Slider", style: TextStyle(color: Colors.black),),
            Slider(
              value: _currentSliderValue,
              min: 0,
              max: 1,
              divisions: 10,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
                VolumeControl.setVolume(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
