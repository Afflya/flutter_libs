library;

import 'package:flutter/material.dart';

const double kDefaultMaxWidth = 750;
const double kDefaultCornerRadius = 8;
const double kDefaultElevation = 2;

// TODO add card theme

class CardTile extends StatelessWidget {
  final double? maxWidth;
  final bool topCorner;
  final bool bottomCorner;
  final EdgeInsets? padding;

  final Color? backgroundColor;

  final double? cornerRadius;

  final String? titleText;

  //widget before card view. Typically used to show title text.
  final Widget? title;
  final Widget? child;

  final double? elevation;

  const CardTile({
    super.key,
    this.maxWidth,
    required this.topCorner,
    required this.bottomCorner,
    this.padding,
    this.backgroundColor,
    this.cornerRadius,
    this.titleText,
    this.title,
    this.child,
    this.elevation,
  });

  factory CardTile.header({
    Key? key,
    double? maxWidth,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? cornerRadius,
    double? elevation,
    String? titleText,
    Widget? title,
    Widget? child,
  }) {
    return CardTile(
      key: key,
      maxWidth: maxWidth,
      topCorner: true,
      bottomCorner: false,
      padding: padding,
      backgroundColor: backgroundColor,
      cornerRadius: cornerRadius,
      elevation: elevation,
      title: title,
      titleText: titleText,
      child: child,
    );
  }

  factory CardTile.footer({
    Key? key,
    double? maxWidth,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? cornerRadius,
    double? elevation,
    Widget? child,
  }) {
    return CardTile(
      key: key,
      maxWidth: maxWidth,
      topCorner: false,
      bottomCorner: true,
      padding: padding,
      backgroundColor: backgroundColor,
      cornerRadius: cornerRadius,
      elevation: elevation,
      child: child,
    );
  }

  factory CardTile.tile({
    Key? key,
    double? maxWidth,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? cornerRadius,
    double? elevation,
    Widget? child,
  }) {
    return CardTile(
      key: key,
      maxWidth: maxWidth,
      topCorner: false,
      bottomCorner: false,
      padding: padding,
      backgroundColor: backgroundColor,
      cornerRadius: cornerRadius,
      elevation: elevation,
      child: child,
    );
  }

  factory CardTile.card({
    Key? key,
    double? maxWidth,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? cornerRadius,
    double? elevation,
    String? titleText,
    Widget? title,
    Widget? child,
  }) {
    return CardTile(
      key: key,
      maxWidth: maxWidth,
      topCorner: true,
      bottomCorner: true,
      padding: padding,
      backgroundColor: backgroundColor,
      cornerRadius: cornerRadius,
      elevation: elevation,
      title: title,
      titleText: titleText,
      child: child,
    );
  }

  factory CardTile.divider({
    Key? key,
    double? maxWidth,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? elevation,
  }) {
    return CardTile(
      key: key,
      maxWidth: maxWidth,
      padding: padding,
      backgroundColor: backgroundColor,
      elevation: elevation,
      topCorner: false,
      bottomCorner: false,
      child: Divider(),
      // child: const ListDivider(
      //   padding: EdgeInsets.only(left: 16.0, right: 16.0),
      // ),
    );
  }

  factory CardTile.subtitle({
    Key? key,
    required String text,
    bool topCorner = false,
    double? maxWidth,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? cornerRadius,
    double? elevation,
  }) {
    return CardTile(
      key: key,
      maxWidth: maxWidth,
      padding: padding,
      backgroundColor: backgroundColor,
      cornerRadius: cornerRadius,
      elevation: elevation,
      topCorner: topCorner,
      bottomCorner: false,
      child: CardTileTitleText(text: text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = this.padding?.copyWith(
              top: topCorner ? this.padding?.top : 0.0,
              bottom: bottomCorner ? this.padding?.bottom : 0.0,
            ) ??
        EdgeInsets.zero;

    final borderRadius = BorderRadius.only(
      topLeft: topCorner ? Radius.circular(cornerRadius ?? kDefaultCornerRadius) : Radius.zero,
      topRight: topCorner ? Radius.circular(cornerRadius ?? kDefaultCornerRadius) : Radius.zero,
      bottomLeft: bottomCorner ? Radius.circular(cornerRadius ?? kDefaultCornerRadius) : Radius.zero,
      bottomRight: bottomCorner ? Radius.circular(cornerRadius ?? kDefaultCornerRadius) : Radius.zero,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: maxWidth ?? kDefaultMaxWidth,
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              if (title != null) title! else if (titleText != null) CardTileTitleText(text: titleText!),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                elevation: elevation ?? kDefaultElevation,
                // color: backgroundColor,
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Material(color: Colors.transparent, child: child),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardTileTitle extends StatelessWidget {
  final String text;
  final double? maxWidth;
  final EdgeInsets padding;
  final TextStyle? style;

  const CardTileTitle({
    super.key,
    required this.text,
    this.maxWidth,
    this.padding = EdgeInsets.zero,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: maxWidth ?? kDefaultMaxWidth,
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              CardTileTitleText(text: text, style: style),
            ],
          ),
        ),
      ),
    );
  }
}

class CardTileTitleText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CardTileTitleText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
        child: Text(
          text,
          style: style ?? Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
