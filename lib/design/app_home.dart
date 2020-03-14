import 'package:flutter/material.dart';

import '../widget_settings.dart';
import 'tabs/job_pool_tab.dart';
import 'tabs/my_jobs_tab.dart';

class AppHome extends StatefulWidget {
  @override
  _HomeAppTabsState createState() => _HomeAppTabsState();
}

class _HomeAppTabsState extends State<AppHome>
    with SingleTickerProviderStateMixin {
  static const FRINX_LOGO_PATH = 'images/frinx_logo.png';
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
    var constants = WidgetSettings.of(context);
    return Scaffold(
      backgroundColor: constants.colorOfBackground,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Row(
              children: <Widget>[
                Text(constants.titleOfAppBar),
                Container(
                    child: Image(
                        fit: BoxFit.fitWidth,
                        width: constants.widthOfFrinxLogo,
                        image: const AssetImage(FRINX_LOGO_PATH))),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            backgroundColor: constants.colorOfComponent,
            snap: true,
            floating: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Row(
                    children: <Widget>[
                      const Icon(Icons.home),
                      SizedBox(width: constants.intendIconFromText),
                      Text(constants.titleOfMyJobsTab)
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: <Widget>[
                      const Icon(Icons.format_list_numbered),
                      SizedBox(width: constants.intendIconFromText),
                      Text(constants.titleOfJobPoolTab)
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
