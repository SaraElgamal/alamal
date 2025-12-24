import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/case_model.dart';

abstract class CasesService {
  Future<void> addCase(CaseModel caseModel);
  Future<List<CaseModel>> getCases({int? limit, String? lastCaseId});
  Future<CaseModel> getCaseById(String id);
  Future<void> deleteCase(String id);
  Future<void> deleteAllCases();
  Future<void> updateCase(CaseModel caseModel);
}

class CasesServiceImpl implements CasesService {
  final FirebaseFirestore firestore;

  CasesServiceImpl({required this.firestore});

  @override
  Future<void> addCase(CaseModel caseModel) async {
    // We use the ID from the model or generate a new one if empty,
    // but usually we let Firestore generate it or use a specific logic.
    // Here we assume the ID is generated before or we use .doc().set()
    // If ID is empty, we might want to use .add() and update the model.
    // For simplicity, let's assume we use .doc(id).set() if id is provided,
    // or .collection().doc().set() if we generate it here.

    DocumentReference docRef;
    if (caseModel.id.isEmpty) {
      docRef = firestore.collection('registrationDataForUsers').doc();
    } else {
      docRef = firestore
          .collection('registrationDataForUsers')
          .doc(caseModel.id);
    }

    // We might need to update the ID in the model if we generated it
    final caseWithId = CaseModel(
      id: docRef.id,
      applicant: caseModel.applicant,
      spouse: caseModel.spouse,
      caseDescription: caseModel.caseDescription,
      familyMembers: caseModel.familyMembers,
      rationCardCount: caseModel.rationCardCount,
      pensionCount: caseModel.pensionCount,
      manualTotalFamilyIncome: caseModel.manualTotalFamilyIncome,
      expenses: caseModel.expenses,
      aidHistory: caseModel.aidHistory,
      createdAt: caseModel.createdAt,
    );

    await docRef.set(caseWithId.toJson());
  }

  @override
  Future<List<CaseModel>> getCases({int? limit, String? lastCaseId}) async {
    Query query = firestore
        .collection('registrationDataForUsers')
        .orderBy('createdAt', descending: true);

    if (lastCaseId != null) {
      final lastDoc = await firestore
          .collection('registrationDataForUsers')
          .doc(lastCaseId)
          .get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) =>
              CaseModel.fromJson(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  @override
  Future<CaseModel> getCaseById(String id) async {
    final doc = await firestore
        .collection('registrationDataForUsers')
        .doc(id)
        .get();
    if (doc.exists) {
      return CaseModel.fromJson(doc.data()!, doc.id);
    } else {
      throw Exception('Case not found');
    }
  }

  @override
  Future<void> deleteCase(String id) async {
    await firestore.collection('registrationDataForUsers').doc(id).delete();
  }

  @override
  Future<void> deleteAllCases() async {
    final batch = firestore.batch();
    final snapshot = await firestore
        .collection('registrationDataForUsers')
        .get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<void> updateCase(CaseModel caseModel) async {
    if (caseModel.id.isEmpty) {
      throw Exception('Case ID cannot be empty for update');
    }
    await firestore
        .collection('registrationDataForUsers')
        .doc(caseModel.id)
        .update(caseModel.toJson());
  }
}
