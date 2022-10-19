import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//text fields for email, password login and signup textfield.
textFieldWidget(
  TextEditingController controller,
  String hint,
  bool? obscureText,
  validate,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    child: TextFormField(
      validator: validate,
      keyboardType: TextInputType.emailAddress,
      obscureText: obscureText!,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    ),
  );
}

// Buttons for login with google,facebook, signin button, signup button etc.

class Buttons extends StatelessWidget {
  Buttons(
      {Key? key,
      required this.onPress,
      required this.child,
      required this.height,
      this.loading = false,
      required this.boxDecoration})
      : super(key: key);
  final bool loading;
  Function() onPress;
  Decoration boxDecoration;
  Widget child;
  double height;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
        child: InkWell(
          onTap: onPress,
          child: Container(
              decoration: boxDecoration,
              width: MediaQuery.of(context).size.width,
              height: height,
              child: Center(
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : child)),
        ));
  }
}

class toast {
  void toastMessage(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 15,
    );
  }
}

class ColorClass {
  Color themeColor = const Color(0xFF00D3A1);
  Color themeColor2 = const Color(0xFF13A6A7);
  Color skyThemeColor = const Color(0xFF13A6A7);
  Color white = Colors.white;
  Color black = Colors.black;
  Color blue = Colors.blue;
  Color red = Colors.red;
  Color grey = Colors.grey.shade700;
  Color black45 = Colors.black45;
  Color black38 = Colors.black38;
  Color black12 = Colors.black12;
  Color black54 = Colors.black54;
  Color blueGrey = Colors.blueGrey;
}

GestureDetector draft_post(Function() onPress, String text) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      height: 35,
      width: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorClass().themeColor2,
            ColorClass().themeColor,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
          color: ColorClass().white,
        ),
      )),
    ),
  );
}

class MyButtonList extends StatefulWidget {
  MyButtonList(
      {Key? key,
      required this.buttons1,
      required this.height,
      required this.width})
      : super(key: key);
  late double height, width;

  final List<ButtonData> buttons1;

  @override
  State<MyButtonList> createState() => _MyButtonListState();
}

class _MyButtonListState extends State<MyButtonList> {
  late List<bool> favoriateState;

  @override
  void initState() {
    favoriateState = List.generate(
        widget.buttons1.length, (index) => widget.buttons1[index].isFavorite);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < widget.buttons1.length; i++)
          Center(
            child: MyWidget(
              text: widget.buttons1[i].text,
              onPressed: () {
                for (var j = 0; j < favoriateState.length; j++) {
                  favoriateState[j] = false;
                }
                setState(() {
                  favoriateState[i] = true;
                  if (widget.buttons1[i].onPressed != null) {
                    widget.buttons1[i].onPressed!();
                  }
                });
              },
              isFavourte: favoriateState[i],
              width: widget.width,
              height: widget.height,
            ),
          ),
      ],
    );
  }
}

class ButtonData {
  final String text;
  final Function()? onPressed;
  final bool isFavorite;

  ButtonData({required this.text, this.onPressed, this.isFavorite = false});
}

class MyWidget extends StatelessWidget {
  const MyWidget(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.width,
      required this.height,
      this.isFavourte = false})
      : super(key: key);

  final String text;
  final Function()? onPressed;
  final bool isFavourte;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isFavourte ? ColorClass().themeColor2 : Colors.teal.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: ColorClass().white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////
class ButtonList2 extends StatefulWidget {
  ButtonList2(
      {Key? key,
      required this.buttons,
      required this.height,
      required this.width})
      : super(key: key);
  late double height, width;

  final List<Button2> buttons;

  @override
  State<ButtonList2> createState() => _ButtonList2State();
}

class _ButtonList2State extends State<ButtonList2> {
  late List<bool> favoriateState;

  @override
  void initState() {
    favoriateState = List.generate(
        widget.buttons.length, (index) => widget.buttons[index].isFavorite);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < widget.buttons.length; i++)
          Widget2(
            text1: widget.buttons[i].text,
            onPressed: () {
              for (var j = 0; j < favoriateState.length; j++) {
                favoriateState[j] = false;
              }
              setState(() {
                favoriateState[i] = true;
                if (widget.buttons[i].onPressed != null) {
                  widget.buttons[i].onPressed!();
                }
              });
            },
            isFavourte: favoriateState[i],
            width: widget.width,
            height: widget.height,
          ),
      ],
    );
  }
}

class Button2 {
  final String text;
  final Function()? onPressed;
  final bool isFavorite;

  Button2({required this.text, this.onPressed, this.isFavorite = false});
}

class Widget2 extends StatelessWidget {
  const Widget2(
      {Key? key,
      required this.text1,
      required this.onPressed,
      required this.width,
      required this.height,
      this.isFavourte = false})
      : super(key: key);

  final String text1;
  final Function()? onPressed;
  final bool isFavourte;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(0.2),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: isFavourte ? ColorClass().themeColor2 : ColorClass().white,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorClass().black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
