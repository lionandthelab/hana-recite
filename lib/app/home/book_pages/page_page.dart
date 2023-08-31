import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hanarecite/app/home/book_pages/chant_page.dart';
import 'package:hanarecite/app/top_level_providers.dart';
import 'package:hanarecite/common_widgets/date_time_picker.dart';
import 'package:hanarecite/app/home/book_pages/format.dart';
import 'package:hanarecite/app/home/models/page.dart' as PageModel;
import 'package:hanarecite/app/home/models/book.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:hanarecite/routing/app_router.dart';
import 'package:hanarecite/services/firestore_database.dart';
import 'package:pedantic/pedantic.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PagePage extends ConsumerStatefulWidget {
  const PagePage({required this.book, this.page});
  final Book book;
  final PageModel.Page? page;

  static Future<void> show(
      {required BuildContext context,
      required Book book,
      PageModel.Page? page}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.pagePage,
      arguments: {
        'book': book,
        'page': page,
      },
    );
  }

  @override
  _PagePageState createState() => _PagePageState();
}

class _PagePageState extends ConsumerState<PagePage> {
  late String _title;
  late String _bgUrl;
  late String _voiceUrl;
  late String _verseList;
  late String _chantVidList;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    audioPlayer = AudioPlayer();

    _title = widget.page?.title ?? '';
    _bgUrl = widget.page?.bgUrl ?? '';
    _voiceUrl = widget.page?.voiceUrl ?? '';
    _verseList = widget.page?.verseList ?? '';
    _chantVidList = widget.page?.chantVidList ?? '';
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    audioPlayer.pause();
    audioPlayer.stop();
    super.dispose();
  }

  PageModel.Page _pageFromState() {
    final id = widget.page?.id ?? documentIdFromCurrentDate();
    return PageModel.Page(
      id: id,
      bookId: widget.book.id,
      pageIndex: widget.page?.pageIndex as int,
      title: _title,
      bgUrl: _bgUrl,
      voiceUrl: _voiceUrl,
      verseList: _verseList,
      chantVidList: _chantVidList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            widget.page!.chantVidList != ""
                ? Positioned(
                    top: 10,
                    right: 60,
                    child: Container(
                        height: 40.0,
                        width: 40.0,
                        child: FittedBox(
                            child: FloatingActionButton(
                          onPressed: () {
                            ChantPage.show(
                                context: context,
                                vid: widget.page?.chantVidList ?? '');
                          },
                          child: const Icon(
                            Icons.music_note_outlined,
                            size: 30,
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
                    onPressed: () async {
                      await audioPlayer.play(
                          'https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/voices%2F${widget.page?.bookId}_${widget.page?.pageIndex}.mp3?alt=media&token=14ee6ccb-f14d-48ff-a564-a2d203d1fc5a.png');
                    },
                    child: const Icon(
                      Icons.record_voice_over_outlined,
                      size: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ))),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                  height: 40.0,
                  width: 40.0,
                  child: FittedBox(
                      child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ))),
            ),
          ],
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0), // here the desired height
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text(widget.page?.title ?? ''),
            actions: <Widget>[],
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return SingleChildScrollView(
              child: Container(
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // _buildStartDate(),
                // _buildEndDate(),
                // const SizedBox(height: 8.0),
                // _buildDuration(),
                // const SizedBox(height: 8.0),
                // _buildComment(),
                // const SizedBox(height: 8.0),
                // _buildVerseList(),
                _buildBgImage(orientation),
              ],
            ),
          ));
        }));
  }

  // Widget _buildStartDate() {
  //   return DateTimePicker(
  //     labelText: 'Start',
  //     selectedDate: _startDate,
  //     selectedTime: _startTime,
  //     onSelectedDate: (date) => setState(() => _startDate = date),
  //     onSelectedTime: (time) => setState(() => _startTime = time),
  //   );
  // }

  // Widget _buildEndDate() {
  //   return DateTimePicker(
  //     labelText: 'End',
  //     selectedDate: _endDate,
  //     selectedTime: _endTime,
  //     onSelectedDate: (date) => setState(() => _endDate = date),
  //     onSelectedTime: (time) => setState(() => _endTime = time),
  //   );
  // }

  // Widget _buildDuration() {
  //   final currentPage = _pageFromState();
  //   final durationFormatted = Format.hours(currentPage.durationInHours);
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Text(
  //         'Duration: $durationFormatted',
  //         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildComment() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Text(
  //         '$_comment',
  //         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildVerseList() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Text(
  //         '$_verseList',
  //         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBgImage(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return CachedNetworkImage(
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${widget.page?.bookId}_${widget.page?.pageIndex}_port.png?alt=media&token=0610af7d-0010-482e-931d-65a26501354a",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
      // return Image.network(
      //   "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${widget.page?.bookId}_${widget.page?.pageIndex}_port.png?alt=media&token=0610af7d-0010-482e-931d-65a26501354a",
      //   fit: BoxFit.cover,
      //   loadingBuilder: (BuildContext context, Widget child,
      //       ImageChunkEvent? loadingProgress) {
      //     if (loadingProgress == null) {
      //       return child;
      //     }
      //     return Center(
      //       child: CircularProgressIndicator(
      //         value: loadingProgress.expectedTotalBytes != null
      //             ? loadingProgress.cumulativeBytesLoaded /
      //                 loadingProgress.expectedTotalBytes!
      //             : null,
      //       ),
      //     );
      //   },
      // );
    } else {
      return CachedNetworkImage(
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${widget.page?.bookId}_${widget.page?.pageIndex}_land.png?alt=media&token=0610af7d-0010-482e-931d-65a26501354a",
        // imageBuilder: (context, imageProvider) => Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: imageProvider,
        //         fit: BoxFit.cover,
        //         colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        //   ),
        // ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
      // return Image.network(
      //   "https://firebasestorage.googleapis.com/v0/b/hana0re.appspot.com/o/bgImages%2F${widget.page?.bookId}_${widget.page?.pageIndex}_land.png?alt=media&token=0610af7d-0010-482e-931d-65a26501354a",
      //   fit: BoxFit.cover,
      //   loadingBuilder: (BuildContext context, Widget child,
      //       ImageChunkEvent? loadingProgress) {
      //     if (loadingProgress == null) {
      //       return child;
      //     }
      //     return Center(
      //       child: CircularProgressIndicator(
      //         value: loadingProgress.expectedTotalBytes != null
      //             ? loadingProgress.cumulativeBytesLoaded /
      //                 loadingProgress.expectedTotalBytes!
      //             : null,
      //       ),
      //     );
      //   },
      // );
    }
  }
}
