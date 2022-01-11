import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final textEditingController;
  final String hint;
  final bool obscure;
  final FormFieldValidator<String> validator;
  final int maxLine;
final bool isPhone;
  const CustomTextField({
    Key key,
    this.textEditingController,
    this.hint,
    this.validator,
    this.obscure = false,
    this.isPhone = false,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: new TextFormField(
          obscureText: obscure,
          validator: validator,
          keyboardType:isPhone?TextInputType.phone:TextInputType.text,
   
          controller: textEditingController,
          maxLines: maxLine,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 14,
            color: const Color(0xff636565),
          ),
          decoration: new InputDecoration(
            focusColor: Colors.green,

            // You can use EdgeInsets.only() to add padding from top and/or bottom. But it will affect your TextField
            enabledBorder: new OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            focusedBorder: new OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            errorBorder: new OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            border: new OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),

            filled: true,
            hintStyle: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 14,
              color: const Color(0xffb6b7b7),
            ),
            hintText: hint,
            fillColor: const Color(0xfff2f2f2),
          ),
        ),
      ),
    );
  }
}

class OtpTemp extends StatelessWidget {
  final textEditingController;
  final String hint;
  final bool obscure;

  const OtpTemp(
      {Key key, this.textEditingController, this.hint, this.obscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: new TextField(
        obscureText: obscure,
        controller: textEditingController,
        obscuringCharacter: "*",
        style: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 14,
          color: const Color(0xff636565),
        ),
        decoration: new InputDecoration(
          focusColor: Colors.green,
          enabledBorder: new OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
          focusedBorder: new OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
          border: new OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2,
            ),
          ),
          filled: true,
          hintStyle: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 14,
            color: const Color(0xffb6b7b7),
          ),
          hintText: hint,
          fillColor: const Color(0xfff2f2f2),
        ),
      ),
    );
  }
}

class CustomSingleSearchField extends StatelessWidget {
  final textEditingController;
  final String hint;

  final IconData iconData;
  final Function(String text) function;

  const CustomSingleSearchField({
    Key key,
    this.textEditingController,
    this.hint,
    this.iconData,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      controller: textEditingController,
      style: TextStyle(
        fontFamily: 'Metropolis',
        fontSize: 14,
        color: const Color(0xff636565),
      ),
      onFieldSubmitted: function,
      decoration: new InputDecoration(
        focusColor: Colors.green,
        prefixIcon: iconData == null ? Container() : Icon(iconData),
        enabledBorder: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        // focusedBorder: new OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.transparent,
        //     width: 2,
        //   ),
        //   borderRadius: const BorderRadius.all(
        //     const Radius.circular(50.0),
        //   ),
        // ),
        errorBorder: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        border: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        filled: true,
        hintStyle: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 14,
          color: const Color(0xffb6b7b7),
        ),
        hintText: hint,
        fillColor: const Color(0xfff2f2f2),
      ),
    );
  }
}
