import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mario_service/repositories/notifications/notification_repo.dart';
import 'package:mario_service/repositories/shared_data/shared_references.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/login_register/login_register.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationPageState();
  }
}

class NotificationPageState extends State<NotificationPage> {
  SharedReferences references = new SharedReferences();
  final NotificationRepo _notificationRepo = new NotificationRepo();
  List<Map<String, dynamic>> _allNotifications = [];
  bool isLoading = true;

  @override
  void initState() {
    getAllNotifications();
    super.initState();
  }

  getAllNotifications() async {
    _allNotifications = await _notificationRepo.getUserNotification();

    if (_allNotifications[0]['error'] == 'Login to Continue.') {
      await references.removeAccessToken();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterPage()),
          (route) => false);
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notification"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : NotificationList(_allNotifications));
  }
}

class NotificationList extends StatelessWidget {
  final List<Map<String, dynamic>> _allNotifications;

  NotificationList(this._allNotifications);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _allNotifications.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StripContainer(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: CachedNetworkImage(
                          imageUrl: _allNotifications[index]['image'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        _allNotifications[index]['description'],
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 16,
                          color: const Color(0xff4a4b4d),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: _allNotifications[index]['status'] == "active"
                          ? Colors.grey
                          : Colors.grey.shade200,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      parseDisplayDate(
                        DateTime.parse(_allNotifications[index]['expiry_date']),
                      ),
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 12,
                        color: const Color(0xff4a4b4d),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}
