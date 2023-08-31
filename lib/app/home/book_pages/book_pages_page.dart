import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hanarecite/app/home/book_pages/chant_page.dart';
import 'package:pedantic/pedantic.dart';
import 'package:hanarecite/app/home/book_pages/page_list_item.dart';
import 'package:hanarecite/app/home/book_pages/page_page.dart';
import 'package:hanarecite/app/home/books/long_list_items_builder.dart';
import 'package:hanarecite/app/home/models/page.dart' as PageModel;
import 'package:hanarecite/app/home/models/book.dart';
import 'package:hanarecite/app/top_level_providers.dart';
import 'package:hanarecite/routing/cupertino_tab_view_router.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BookPagesPage extends StatefulWidget {
  const BookPagesPage({required this.book});
  final Book book;

  static Future<void> show(BuildContext context, Book book) async {
    await Navigator.of(context).pushNamed(
      CupertinoTabViewRoutes.bookPagesPage,
      arguments: book,
    );
  }

  @override
  _BookPagesPageState createState() => _BookPagesPageState();
}

class _BookPagesPageState extends State<BookPagesPage> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.pause();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: BookPagesAppBarTitle(book: this.widget.book),
        centerTitle: true,
      ),
      body: BookPagesContents(book: this.widget.book),
    );
  }
}

final bookStreamProvider =
    StreamProvider.autoDispose.family<Book, String>((ref, bookId) {
  final database = ref.watch(databaseProvider)!;
  return database.bookStream(bookId: bookId);
});

class BookPagesAppBarTitle extends ConsumerWidget {
  const BookPagesAppBarTitle({required this.book});
  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsyncValue = ref.watch(bookStreamProvider(book.id));
    return bookAsyncValue.when(
      data: (book) => Text(book.title),
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
}

final bookPagesStreamProvider =
    StreamProvider.autoDispose.family<List<PageModel.Page>, Book>((ref, book) {
  final database = ref.watch(databaseProvider)!;
  return database.pagesStream(book: book);
});

class BookPagesContents extends ConsumerWidget {
  final Book book;
  BookPagesContents({required this.book});
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesStream = ref.watch(bookPagesStreamProvider(book));
    return LongListItemsBuilder<PageModel.Page>(
      data: pagesStream,
      itemBuilder: (context, page) {
        return Card(
            margin: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.grey[100],
            shadowColor: Colors.blueGrey,
            elevation: 10,
            child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerTop,
                floatingActionButton: Stack(
                  fit: StackFit.expand,
                  children: [
                    page.chantVidList != ""
                        ? Positioned(
                            top: 10,
                            right: 60,
                            child: Container(
                                height: 40.0,
                                width: 40.0,
                                child: FittedBox(
                                    child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    ChantPage.show(
                                        context: context,
                                        vid: page.chantVidList);
                                  },
                                  child: const Icon(
                                    Icons.music_note_outlined,
                                    size: 30,
                                    color: Colors.blueAccent,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ))),
                          )
                        : Container(),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                          height: 40.0,
                          width: 40.0,
                          child: FittedBox(
                              child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              await audioPlayer.play(
                                  'https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/voices%2F${page.bookId}_${page.pageIndex}.mp3?alt=media&token=14ee6ccb-f14d-48ff-a564-a2d203d1fc5a.png');
                            },
                            child: const Icon(
                              Icons.record_voice_over_outlined,
                              size: 30,
                              color: Colors.blueAccent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ))),
                    ),
                  ],
                ),
                body: OrientationBuilder(builder: (context, orientation) {
                  return SingleChildScrollView(
                      child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _buildBgImage(orientation, page),
                      ],
                    ),
                  ));
                })));
      },
    );
  }

  Widget _buildBgImage(Orientation orientation, PageModel.Page page) {
    if (orientation == Orientation.portrait) {
      return CachedNetworkImage(
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${page.bookId}_${page.pageIndex}_port.png?alt=media&token=0610af7d-0010-482e-931d-65a26501354a",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      return CachedNetworkImage(
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${page.bookId}_${page.pageIndex}_land.png?alt=media&token=0610af7d-0010-482e-931d-65a26501354a",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }
}
