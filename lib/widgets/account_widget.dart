import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountWidget extends StatefulWidget {
  String title;
  String image;

  AccountWidget({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0.5,
        child: Container(
          height: 50.h,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Image.asset(
                widget.image,
                width: 30.w,
                height: 30.h,
              ),
              /* Icon(
                widget.icon,
                color: Colors.blue,
              ),*/
              SizedBox(
                width: 10.w,
              ),
              Expanded(child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
