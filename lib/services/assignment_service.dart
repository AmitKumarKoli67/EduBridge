import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/assignment_model.dart';

class AssignmentService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('assignments');

  // Real-time stream of all assignments (sorted by dueDate)
  Stream<List<AssignmentModel>> getAssignments() {
    return _collection
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                AssignmentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Add new assignment (Teacher)
  Future<void> addAssignment(AssignmentModel assignment) async {
    await _collection.add(assignment.toMap());
  }

  // Update assignment status or feedback
  Future<void> updateAssignment(String id, Map<String, dynamic> data) async {
    await _collection.doc(id).update(data);
  }
}
