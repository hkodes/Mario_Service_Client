import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StripContainer extends StatelessWidget {
  final Widget child;

  const StripContainer({
    Key key,
    this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1c4cbcfc),
            offset: Offset(0, 3),
            blurRadius: 11,
          ),
        ],
      ),
      child: child,
    );
  }
}

class BaseContainer extends StatelessWidget {
  final Widget child;

  const BaseContainer({Key key, this.child})
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: const Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1c4cbcfc),
              offset: Offset(0, 3),
              blurRadius: 11,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  final bool isPositive;
  final bool enabled;
  final bool isCancel;

  const BottomButton({
    Key key,
    @required this.onTap,
    @required this.title,
    @required this.enabled,
    this.isPositive = true,
    this.isCancel = false,
  })  : assert(onTap != null),
        assert(title != null),
        assert(isPositive != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StripContainer(
      child: isPositive
          ? ElevatedButton(
              style: ButtonStyle(
                backgroundColor: isCancel
                    ? MaterialStateProperty.all(Colors.red)
                    : MaterialStateProperty.all(Colors.green),
                // side: MaterialStateProperty.all<BorderSide>(
                //   BorderSide(width: 2),
                // ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    side: BorderSide(width: 0),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: enabled ? onTap : null,
            )
          : TextButton(
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.resolveWith<Color>(
              //     (Set<MaterialState> states) {
              //       return ThemeLightColor.primary_color;
              //     },
              //   ),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      color: const Color(0xff4a4b4d),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: enabled ? onTap : null,
            ),
    );
  }
}

class BottomButton2 extends StatelessWidget {
  final Function() onTap;
  final String title;
  final bool isPositive;
  final bool enabled;

  const BottomButton2({
    Key key,
    @required this.onTap,
    @required this.title,
    @required this.enabled,
    this.isPositive = false,
  })  : assert(onTap != null),
        assert(title != null),
        assert(isPositive != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StripContainer(
      child: isPositive
          ? ElevatedButton(
              style: ButtonStyle(
                // side: MaterialStateProperty.all<BorderSide>(
                //   BorderSide(width: 2),
                // ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    side: BorderSide(width: 0),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: enabled ? onTap : null,
            )
          : TextButton(
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.resolveWith<Color>(
              //     (Set<MaterialState> states) {
              //       return ThemeLightColor.primary_color;
              //     },
              //   ),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: enabled ? onTap : null,
            ),
    );
  }
}

class AddressItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Map Function() onTap;

  const AddressItem(
      {Key key,
      @required this.iconData,
      @required this.title,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StripContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99.0),
                    child: Container(
                      width: 24,
                      height: 24,
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          iconData,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectionCard extends StatelessWidget {
  final Function() onTap;
  final String svgIcon;
  final String title;
  final int counter;
  final IconData iconData;

  const SelectionCard(
      {Key key,
      this.onTap,
      this.svgIcon,
      this.title,
      this.counter,
      this.iconData})
      : assert(onTap != null),
        assert(
          (svgIcon != null || iconData != null),
          'One of the parameters must be provided',
        ),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        children: [
          Container(
            child: SizedBox(
              width: 24,
              height: 24,
              child: svgIcon != null
                  ? SvgPicture.string(
                      svgIcon,
                      allowDrawingOutsideViewBox: true,
                      fit: BoxFit.contain,
                    )
                  : Center(
                      child: Icon(
                      iconData,
                      size: 24,

                      color: Colors.white,
                      // color: const Color(0xFF4a4b4d),
                    )),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          counter == null
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      counter.toString(),
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 12,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
        ],
      ),
      onPressed: onTap,
    );
  }
}

class SelectionCardBack extends StatelessWidget {
  final Function() onTap;
  final String svgIcon;
  final String title;
  final IconData iconData;

  const SelectionCardBack(
      {Key key, this.onTap, this.svgIcon, this.title, this.iconData})
      : assert(onTap != null),
        assert(
          (svgIcon != null || iconData != null),
          'One of the parameters must be provided',
        ),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 14,
                color: const Color(0xff4a4b4d),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Container(
            child: SizedBox(
              width: 24,
              height: 24,
              child: svgIcon != null
                  ? SvgPicture.string(
                      svgIcon,
                      allowDrawingOutsideViewBox: true,
                      fit: BoxFit.contain,
                    )
                  : Center(
                      child: Icon(
                      iconData,
                      size: 24,
                      // color: const Color(0xFF4a4b4d),
                    )),
            ),
          ),
        ],
      ),
      onPressed: onTap,
    );
  }
}

class PositiveButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onTap;

  const PositiveButton({Key key, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: null,
            elevation: 1,
            primary: const Color(0xfffc6011),
            onPrimary: const Color(0xffb46f4c),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
              // side: BorderSide(
              //   width: 1.0,
              //   color: const Color(0xfffc6011),
              // ),
            ),
          ),
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 16,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}

class NegativeButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onTap;

  const NegativeButton({Key key, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      child: TextButton(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFFFFFFF),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
              side: BorderSide(
                width: 1.0,
                color: const Color(0xfffc6011),
              ),
            ),
          ),
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 16,
                color: const Color(0xfffc6011),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

// }
}

class EditableTextField extends StatelessWidget {
  final String textBody;
  final String textTitle;
  final TextEditingController textEditingController;

  const EditableTextField(
      {Key key, this.textBody, this.textTitle, this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: TextFormField(
        // textAlignVertical: TextAlignVertical(y: .5),
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.zero,
          labelText: textTitle.toUpperCase(),
          labelStyle: Theme.of(context)
              .inputDecorationTheme
              .labelStyle
              .copyWith(color: const Color(0xff26282d)),
          isDense: false,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff85878b), width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff85878b), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff26282d), width: 1.5),
          ),
        ),
        controller: textEditingController,
      ),
    );
  }
}
