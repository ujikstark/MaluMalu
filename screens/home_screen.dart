import 'package:UjikChat/models/user.dart';
import 'package:UjikChat/models/user_data.dart';
import 'package:UjikChat/services/database_services.dart';
import 'package:UjikChat/widgets/home/recent_message_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Stream<List<User>> _users;
  String _currentUserId;
  
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getAllUsersData();
  }

  _getAllUsersData() {
    String currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
    Stream<List<User>> users =  Provider.of<DatabaseServices>(context, listen: false).streamUsers(currentUserId);
    if (mounted) {
      setState(() {
        _users = users;
        _currentUserId = currentUserId;
      });
    }
  }
  

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AfterSummer'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 2.5,
            labelPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.02,
                horizontal: MediaQuery.of(context).size.height * 0.06),
            isScrollable: true,
            tabs: [
              Text('CHATS'),
              Text('STATUS'),
              Text('CALLS'),
            ],
          ),
        ),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              }),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RecentMessageItem(_users, _currentUserId),
          Center(child: Icon(Icons.cancel)),
          Center(child: Icon(Icons.import_export))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.message,
          color: Colors.white,
        ),
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
