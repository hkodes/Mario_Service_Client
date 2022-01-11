import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mario_service/utils/common_fun.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/profile/edit_profile/edit_profile.dart';

class Profile extends StatefulWidget {
  final Map<String, dynamic> userModel;
  Profile(this.userModel);
  @override
  State<StatefulWidget> createState() {
    return ProfileState(this.userModel);
  }
}

class ProfileState extends State<Profile> {
  // UserDetailBloc userDetailBloc = UserDetailBloc(
  //   getUserDetailUseCase: di(),
  //   editUserDetailUseCase: di(),
  // );

  final Map<String, dynamic> userModel;
  ProfileState(this.userModel);

  @override
  void initState() {
    // userDetailBloc.add(BLoadData());
    super.initState();
  }

  @override
  void dispose() {
    // userDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body:
          // BlocBuilder(
          // builder: (context, state) {
          // if (state is BLoadedState || state is UserDetailUpdatedState) {
          ProfileContent(this.userModel),
      // } else
      // return Container();
      // },
      // bloc: BlocProvider.of<UserDetailBloc>(context),
    );
  }
}

class ProfileContent extends StatelessWidget {
  // final UserDetailModel userDetailModel;
  final Map<String, dynamic> userModel;
  ProfileContent(this.userModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StripContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: this.userModel['picture'] ?? "",
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 75,
                                ),
                                width: 75,
                                height: 75,
                              ),
                            ),
                          ),
                        ),
                      ),
                      UnEditableTextField(
                        textTitle: "Name",
                        textBody: getFullName(this.userModel['first_name'],
                            this.userModel['last_name']),
                      ),
                      UnEditableTextField(
                        textTitle: "Email",
                        textBody: this.userModel['email'],
                      ),
                      UnEditableTextField(
                        textTitle: "Phone",
                        textBody: getPhone(this.userModel['country_code'],
                            this.userModel['mobile']),
                      ),
                      UnEditableTextField(
                        textTitle: "Gender",
                        textBody: this.userModel['gender'],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        BottomButton(
          title: 'Edit Profile',
          onTap: () => _navigateToEditProfile(
            context,
            //  userDetailModel
          ),
          enabled: true,
          isPositive: false,
        ),
      ],
    );
  }

  _navigateToEditProfile(BuildContext context
      // , UserDetailModel userDetailModel
      ) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditProfile(this.userModel)));
    // context.router.push(EditProfile(userDetailModel: userDetailModel));
  }
}

class UnEditableTextField extends StatelessWidget {
  final String textBody;
  final String textTitle;

  const UnEditableTextField({Key key, this.textBody, this.textTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _tE = TextEditingController(text: textBody);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: textTitle.toUpperCase(),
          contentPadding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
          isDense: false,
        ),
        controller: _tE,
      ),
    );
  }
}
