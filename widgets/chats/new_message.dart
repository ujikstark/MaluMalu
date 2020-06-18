import 'package:UjikChat/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String groupChatId;

  NewMessage(this.currentUserId, this.receiverId, this.groupChatId);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  DatabaseServices _db = DatabaseServices();
  var _enteredMessage = '';

  var _isLoading = false;
  bool _getTapSticker = false;

  List<String> gifData = [
    'assets/images/mimi1.gif',
    'assets/images/mimi2.gif',
    'assets/images/mimi3.gif',
    'assets/images/mimi4.gif',
    'assets/images/mimi5.gif',
    'assets/images/mimi6.gif',
    'assets/images/mimi7.gif',
    'assets/images/mimi8.gif',
    'assets/images/mimi9.gif',
  ];

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    Navigator.of(context).pop();
    try {
      setState(() {
        _isLoading = true;
      });
      _db.sendImage(
          source, widget.currentUserId, widget.receiverId, widget.groupChatId);
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.84,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        color: Colors.grey,
                        onPressed: () {
                          Scaffold.of(context).showBottomSheet(
                            (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        iconSize: 30,
                                        color: Theme.of(context).primaryColor,
                                        icon: Icon(Icons.camera_alt),
                                        onPressed: () {
                                           _getImage(ImageSource.camera);
                                        },
                                      ),
                                      SizedBox(height: 5),
                                      Text('Camera'),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: IconButton(
                                          iconSize: 30,
                                          color: Colors.white,
                                          icon: Icon(Icons.photo_library),
                                          onPressed: () {
                                            _getImage(ImageSource.gallery);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text('Gallery'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                              hintText: 'Send a message...',
                              border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _enteredMessage = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.gif,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _getTapSticker = !_getTapSticker;
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CircleAvatar(
              child: IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.white,
                  onPressed: () {
                    _enteredMessage.trim().isEmpty
                        ? null
                        : _db.sendMessage(
                            _enteredMessage,
                            0,
                            widget.currentUserId,
                            widget.receiverId,
                            widget.groupChatId);
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                  }),
            ),
          ],
        ),
        if (_getTapSticker)
          Container(
            color: Colors.grey[200],
            child: GridView.builder(
              itemCount: gifData.length,
              itemBuilder: (ctx, i) {
                return InkWell(
                  onTap: () {
                    _db.sendMessage(gifData[i], 2, widget.currentUserId,
                        widget.receiverId, widget.groupChatId);
                  },
                  child: Image.asset(gifData[i]),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.1,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
            ),
          ),
      ],
    );
  }
}
