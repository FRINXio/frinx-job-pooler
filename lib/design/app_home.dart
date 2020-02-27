import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/design/tabs/job_pool_tab.dart';
import 'package:frinx_job_pooler/design/tabs/my_jobs_tab.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';

const TAB_TEXT_PADDING = ' ';

class AppHome extends StatefulWidget {
  @override
  _HomeAppTabsState createState() => _HomeAppTabsState();
}

class _HomeAppTabsState extends State<AppHome>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    var constants = GlobalAppConstants.of(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Row(
              children: <Widget>[
                Text(constants.appTitle),
                Container(
                    child: Image(
                        fit: BoxFit.fitWidth,
                        width: constants.frinxLogoWidth,
                        image: AssetImage('images/row_logo.png'))),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            backgroundColor: Colors.blueGrey[900],
            snap: true,
            floating: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Row(
                    children: <Widget>[
                      Icon(Icons.home),
                      Text(TAB_TEXT_PADDING + constants.tabMyJobsName)
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: <Widget>[
                      Icon(Icons.format_list_numbered),
                      Text(TAB_TEXT_PADDING + constants.tabJobPoolName)
                    ],
                  ),
                ),
              ],
              controller: _controller,
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                MyJobsTab(),
                JobPoolTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
