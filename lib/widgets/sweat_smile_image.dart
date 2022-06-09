import 'package:flutter/material.dart';

class SweatSmileImage extends StatelessWidget {
  final String? text;
  final Color? textBgColor;
  final TextStyle? textStyle;

  const SweatSmileImage({
    Key? key,
    this.text,
    this.textBgColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height / 4;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, h, 0, 0),
        child: Center(
          child: Column(children: [
            SizedBox.square(
              dimension: h,
              child: FittedBox(
                child: Image.network(
                    'https://png.pngitem.com/pimgs/s/106-1061780_emoji-transparent-download-smiling-with-sweat-emoji-covent.png'),
              ),
            ),
            if (text != null)
              Chip(
                label: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(text!),
                ),
                backgroundColor:
                    textBgColor ?? Theme.of(context).colorScheme.primary,
                labelStyle: textStyle ??
                    Theme.of(context).textTheme.headline6?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
              )
          ]),
        ),
      ),
    );
  }
}
