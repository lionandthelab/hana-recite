import 'package:flutter/material.dart';
import 'package:hanarecite/app/home/account/account_page.dart';
import 'package:hanarecite/app/home/cupertino_home_scaffold.dart';
import 'package:hanarecite/app/home/entries/entries_page.dart';
import 'package:hanarecite/app/home/jobs/jobs_page.dart';
import 'package:hanarecite/app/home/books/books_page.dart';
import 'package:hanarecite/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.books;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.books: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      // TabItem.jobs: (_) => JobsPage(),
      TabItem.books: (_) => BooksPage(),
      TabItem.entries: (_) => EntriesPage(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !(await navigatorKeys[_currentTab]!.currentState?.maybePop() ??
              false),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
