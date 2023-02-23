import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socify/model/data/comment.dart';
import 'package:socify/model/data/user.dart';
import 'package:socify/view/widgets/show_snackbar.dart';
import 'package:socify/view_model/respositories/comment_repository.dart';

showCommentSheet(BuildContext context, Size size, String id, UserData owner) {
  TextEditingController controller = TextEditingController();
  FocusNode node = FocusNode();
  return showModalBottomSheet(
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (builder) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(builder).viewInsets.bottom),
        child: Container(
          height: size.height * 0.6,
          width: size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 11,
                child: FutureBuilder(
                  future: CommentRepositories(context).getCommentListByPost(
                    id: id,
                  ),
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        break;
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          CommentListData? data = snapshot.data;
                          if (data == null ||
                              data.data == null ||
                              data.data!.isEmpty) break;
                          List<CommentData> commentList = data.data!;

                          return Padding(
                            padding: EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 12,
                            ),
                            child: ListView.separated(
                              itemBuilder: (itemBuilder, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "${commentList[index].owner!.firstName!} ${commentList[index].owner!.lastName!}",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: size.height * 0.05,
                                        child: Text(
                                          commentList[index].message.toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: commentList.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 2,
                              ),
                            ),
                          );
                        }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("No Data Found!"),
                    );
                  },
                ),
              ),
              Divider(),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 6,
                        child: TextField(
                          focusNode: node,
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: "Enter comment",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () async {
                            if (controller.text.isNotEmpty) {
                              await CommentRepositories(context).createComment(
                                commentData: {
                                  "owner": owner.id,
                                  "post": id,
                                  "message": controller.text
                                },
                              );
                              controller.text = "";
                              node.unfocus();
                              showSnackBar(
                                builder,
                                "Comment added",
                                Colors.green,
                              );
                            } else {
                              showSnackBar(
                                builder,
                                "No comment",
                                Colors.red,
                              );
                            }
                          },
                          icon: Icon(
                            CupertinoIcons.paperplane,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
