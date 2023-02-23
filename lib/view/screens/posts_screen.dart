import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socify/model/data/post.dart';
import 'package:socify/view_model/respositories/post_repository.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late Future<PostDataList?> postList;
  int page = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postList = PostRepositories(context).getPostList(
      page: page.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Container(
        height: 30,
        child: Image(
          image: AssetImage(
            "assets/logo.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        appBar,
        Container(
          height: size.height * 0.86,
          child: FutureBuilder(
            future: postList,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<PostData> data = snapshot.data!.data!;
                    _onLoading() async {
                      page += 1;
                      PostDataList? newData = await PostRepositories(context)
                          .getPostList(page: page.toString());
                      List<PostData> list = newData!.data!;
                      data.addAll(list);
                      if (mounted) setState(() {});
                      _refreshController.loadComplete();
                    }

                    _onRefresh() async {
                      page = 0;
                      postList = PostRepositories(context).getPostList(
                        page: page.toString(),
                      );
                      if (mounted) setState(() {});
                      _refreshController.refreshCompleted();
                    }

                    return SmartRefresher(
                      enablePullUp: true,
                      enablePullDown: true,
                      onLoading: _onLoading,
                      onRefresh: _onRefresh,
                      controller: _refreshController,
                      child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemBuilder: (itemBuilder, index) => Container(
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(30),
                          //   color: Colors.grey.shade200,
                          // ),
                          height: size.width + (size.height * 0.15),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Divider(
                                  height: 0,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 4,
                                        ),
                                        CircleAvatar(
                                          foregroundColor: Colors.transparent,
                                          backgroundColor: Colors.black38,
                                          child: CircleAvatar(
                                            foregroundColor: Colors.grey,
                                            backgroundColor: Colors.grey,
                                            maxRadius: 19,
                                            child: ClipOval(
                                              child: Image(
                                                image: NetworkImage(data[index]
                                                    .owner!
                                                    .picture!),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          data[index].owner!.firstName! +
                                              " " +
                                              data[index].owner!.lastName!,
                                          style: GoogleFonts.questrial(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Divider(
                                  height: 0,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          data[index].image!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 4.0,
                                          sigmaY: 4.0,
                                        ),
                                        child: Image.network(
                                          data[index].image!,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 8),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Expanded(
                                            child: Text(
                                              data[index].text.toString(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.thumb_up_outlined,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  data[index].likes.toString(),
                                                ),
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Text("View Comments"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        itemCount: data.length,
                      ),
                    );
                  }
              }
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: () async {
                  page = 0;
                  postList = PostRepositories(context).getPostList(
                    page: page.toString(),
                  );
                  if (mounted) setState(() {});
                  _refreshController.refreshCompleted();
                },
                child: ListView(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
