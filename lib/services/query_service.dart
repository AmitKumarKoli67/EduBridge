import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/query_model.dart';

class QueryService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('queries');

  // Real-time stream of queries for a specific parent/user (sorted client-side, no index needed)
  Stream<List<QueryModel>> getUserQueries(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) =>
              QueryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      list.sort((a, b) {
        if (a.createdAt == null) return -1;
        if (b.createdAt == null) return 1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return list;
    });
  }

  // Real-time stream of ALL queries (for Teachers, sorted client-side)
  Stream<List<QueryModel>> getAllQueries() {
    return _collection.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) =>
              QueryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      list.sort((a, b) {
        if (a.createdAt == null) return -1;
        if (b.createdAt == null) return 1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return list;
    });
  }

  // Submit new query (Parent)
  Future<void> submitQuery(QueryModel query) async {
    await _collection.add(query.toMap());
  }

  // Reply to query (Teacher)
  Future<void> answerQuery(String queryId, String reply) async {
    await _collection.doc(queryId).update({
      'reply': reply,
      'status': 'Answered',
      'answeredAt': FieldValue.serverTimestamp(),
    });
  }
}
