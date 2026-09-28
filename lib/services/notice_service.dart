import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/notice_model.dart';

class NoticeService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('notices');

  // Real-time stream of notices (sorted client-side)
  Stream<List<NoticeModel>> getNotices() {
    return _collection.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) =>
              NoticeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      list.sort((a, b) {
        if (a.createdAt == null) return -1;
        if (b.createdAt == null) return 1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return list;
    });
  }

  // Add new notice
  Future<void> addNotice(NoticeModel notice) async {
    await _collection.add(notice.toMap());
  }
}
