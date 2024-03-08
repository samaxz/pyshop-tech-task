import 'package:flutter/material.dart';

class PhotoButton extends StatelessWidget {
  const PhotoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        bottom: 30,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Material(
          shape: const CircleBorder(),
          // this is for the splash to not go behind
          // the child's constraints
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // TODO implement onTap()
            onTap: () {},
            // TODO implement onLongPress()
            onLongPress: () {},
            splashColor: Colors.grey,
            child: Container(
              width: 76,
              height: 76,
              padding: const EdgeInsets.all(5),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
