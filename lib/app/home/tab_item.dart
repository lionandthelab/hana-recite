import 'package:flutter/material.dart';
import 'package:hanarecite/constants/keys.dart';
import 'package:hanarecite/constants/strings.dart';

enum TabItem { books, entries, account }

class TabItemData {
  const TabItemData(
      {required this.key, required this.title, required this.icon});

  final String key;
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.books: TabItemData(
      key: Keys.booksTab,
      title: Strings.books,
      icon: Icons.book,
    ),
    // TabItem.jobs: TabItemData(
    //   key: Keys.jobsTab,
    //   title: Strings.jobs,
    //   icon: Icons.work,
    // ),
    TabItem.entries: TabItemData(
      key: Keys.entriesTab,
      title: Strings.entries,
      icon: Icons.view_headline,
    ),
    TabItem.account: TabItemData(
      key: Keys.accountTab,
      title: Strings.account,
      icon: Icons.person,
    ),
  };
}
