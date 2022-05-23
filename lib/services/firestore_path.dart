class FirestorePath {
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  static String book(String bid) => 'books/$bid';
  static String books() => 'books';
  static String page(String pid) => 'pages/$pid';
  static String pages() => 'pages';
  static String verse(String vid) => 'verses/$vid';
}
