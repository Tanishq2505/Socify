import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socify/model/data/post.dart';
import 'package:socify/model/data/user.dart';
import 'package:socify/model/services/firebase_auth.dart';
import 'package:socify/view_model/respositories/post_repository.dart';

class ProfileScreen extends StatefulWidget {
  final String id;
  const ProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<PostDataList?> postListByUser;

  @override
  void initState() {
    super.initState();
    postListByUser = PostRepositories(context).getPostListByUser(
      id: widget.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = context.watch<UserData>();
    FirebaseAuthMethods methods = context.read<FirebaseAuthMethods>();
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        "Profile",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            methods.signOut(context);
          },
          icon: Icon(
            Icons.logout_outlined,
          ),
        )
      ],
    );
    var size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          appBar,
          SizedBox(
            height: size.height * 0.86,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: 50,
                        backgroundColor: Colors.black38,
                        foregroundColor: Colors.transparent,
                        child: CircleAvatar(
                          maxRadius: 49,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: Image.network(
                              userData.picture!,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userData.firstName! + " " + userData.lastName!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        userData.email!,
                        style: TextStyle(
                          fontSize: 24 / 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: FutureBuilder(
                      future: postListByUser,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            break;
                          case ConnectionState.active:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              PostDataList? data = snapshot.data;
                              if (data == null ||
                                  data.data == null ||
                                  data.data!.length < 1) break;
                              List<PostData> list = data.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Your Posts",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 9,
                                    child: GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 150,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 6,
                                        mainAxisSpacing: 6,
                                      ),
                                      itemBuilder: (itemBuilder, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                          ),
                                          child: Text(
                                            index.toString(),
                                          ),
                                        );
                                      },
                                      itemCount:
                                          (list.length > 0) ? list.length : 0,
                                    ),
                                  )
                                ],
                              );
                            }
                        }
                        return Center(
                          child: Text("No data found"),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
