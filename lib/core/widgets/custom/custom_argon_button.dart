import 'dart:ui';

import 'package:flutter/material.dart';

enum ButtonState {
  busy,
  idle,
}

class CustomArgonButton extends StatefulWidget {
  final double height;
  final double? width;
  final double minWidth;
  final Widget? loader;
  final Duration animationDuration;
  final Curve curve;
  final Curve reverseCurve;
  final Widget child;
  final Function(Function startLoading, Function stopLoading, ButtonState btnState)? onPressed;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Brightness? colorBrightness;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final EdgeInsetsGeometry padding;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool roundLoadingShape;
  final double borderRadius;
  final BorderSide borderSide;
  final double? disabledElevation;
  final bool disabledBtn;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? textColor;
  final ButtonTextTheme? textTheme;

  const CustomArgonButton(
      {super.key,
      this.height = 56.0,
      this.width,
      this.minWidth = 0,
      this.loader,
      this.animationDuration = const Duration(milliseconds: 450),
      this.curve = Curves.easeInOutCirc,
      this.reverseCurve = Curves.easeInOutCirc,
      required this.child,
      this.onPressed,
      this.color,
      this.focusColor,
      this.hoverColor,
      this.highlightColor,
      this.splashColor,
      this.colorBrightness,
      this.elevation,
      this.focusElevation,
      this.hoverElevation,
      this.highlightElevation,
      this.padding = const EdgeInsets.all(0),
      this.borderRadius = 0.0,
      this.clipBehavior = Clip.none,
      this.focusNode,
      this.materialTapTargetSize,
      this.roundLoadingShape = true,
      this.borderSide = const BorderSide(color: Colors.transparent, width: 0),
      this.disabledElevation,
      this.disabledColor,
      this.disabledTextColor,
      this.textColor,
      this.textTheme,
      this.disabledBtn = false})
      : assert(elevation == null || elevation >= 0.0),
        assert(focusElevation == null || focusElevation >= 0.0),
        assert(hoverElevation == null || hoverElevation >= 0.0),
        assert(highlightElevation == null || highlightElevation >= 0.0),
        assert(disabledElevation == null || disabledElevation >= 0.0);

  @override
  _ArgonButtonState createState() => _ArgonButtonState();
}

class _ArgonButtonState extends State<CustomArgonButton> with TickerProviderStateMixin {
  double? loaderWidth;

  late Animation<double> _animation;
  late AnimationController _controller;
  ButtonState btn = ButtonState.idle;

  final GlobalKey _buttonKey = GlobalKey();
  double _minWidth = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.animationDuration);

    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve, reverseCurve: widget.reverseCurve));

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          btn = ButtonState.idle;
        });
      }
    });

    minWidth = widget.height;
    loaderWidth = widget.height;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animateForward() {
    setState(() => btn = ButtonState.busy);
    _controller.forward();
  }

  void animateReverse() {
    _controller.reverse();
  }

  lerpWidth(a, b, t) {
    if (a == 0.0 || b == 0.0) {
      return null;
    } else {
      return a + (b - a) * t;
    }
  }

  double get minWidth => _minWidth;

  set minWidth(double w) {
    if (widget.minWidth == 0) {
      _minWidth = w;
    } else {
      _minWidth = widget.minWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          width: lerpWidth(widget.width ?? MediaQuery.of(context).size.width, minWidth, _animation.value),
          child: ButtonTheme(
            height: widget.height,

            shape: RoundedRectangleBorder(
              side: widget.borderSide,
              borderRadius: BorderRadius.circular(widget.roundLoadingShape
                  ? lerpDouble(widget.borderRadius, widget.height / 2, _animation.value)!
                  : widget.borderRadius),
            ),

            // data: ElevatedButtonThemeData(
            //
            //     style:ElevatedButton.styleFrom(
            //   elevation: widget.elevation,
            //   shape: const StadiumBorder(),
            //   maximumSize: const Size(double.infinity, 56),
            //   minimumSize: const Size(double.infinity, 56),
            //
            // ),
            //
            //
            // ),
            child: MaterialButton(
                key: _buttonKey,
                /*   style: ElevatedButton.styleFrom(
              elevation: widget.elevation,
              backgroundColor: widget.color,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
              padding: widget.padding,
              // color: widget.color,
              // focusColor: widget.focusColor,
              // hoverColor: widget.hoverColor,
              // highlightColor: widget.highlightColor,
              // splashColor: widget.splashColor,
              // colorBrightness: widget.colorBrightness,
              // elevation: widget.elevation,
              // focusElevation: widget.focusElevation,
              // hoverElevation: widget.hoverElevation,
              // highlightElevation: widget.highlightElevation,




              // clipBehavior: widget.clipBehavior,
              // focusNode: widget.focusNode,
              // materialTapTargetSize: widget.materialTapTargetSize,
              // disabledElevation: widget.disabledElevation,
              // disabledColor: widget.disabledColor,
              // disabledTextColor: widget.disabledTextColor,




            ),*/

                elevation: widget.elevation,
                shape: btn == ButtonState.busy
                    ? const StadiumBorder()
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        side: widget.borderSide,
                      ),

                // maximumSize: const Size(double.infinity, 56),
                // minimumSize: const Size(double.infinity, 56),
                minWidth: widget.width ?? MediaQuery.of(context).size.width,
                textColor: widget.textColor,
                textTheme: widget.textTheme,
                padding: widget.padding,
                color: widget.color,
                focusColor: widget.focusColor,
                hoverColor: widget.hoverColor,
                highlightColor: widget.highlightColor,
                splashColor: widget.splashColor,
                colorBrightness: widget.colorBrightness,
                focusElevation: widget.focusElevation,
                hoverElevation: widget.hoverElevation,
                highlightElevation: widget.highlightElevation,
                clipBehavior: widget.clipBehavior,
                focusNode: widget.focusNode,
                materialTapTargetSize: widget.materialTapTargetSize,
                disabledElevation: widget.disabledElevation,
                disabledColor: widget.disabledColor,
                disabledTextColor: widget.disabledTextColor,
                onPressed: widget.disabledBtn
                    ? null
                    : () {
                        widget.onPressed!(() => animateForward(), () => animateReverse(), btn);
                        // btnClicked();
                      },
                child: btn == ButtonState.idle ? widget.child : widget.loader),
          ),
        );
      },
    );
  }
}
