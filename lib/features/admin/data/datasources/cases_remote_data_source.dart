import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/case_model.dart';

abstract class CasesRemoteDataSource {
  Future<void> addCase(CaseModel caseModel);
  Future<List<CaseModel>> getCases();
  Future<CaseModel> getCaseById(String id);
}

class CasesRemoteDataSourceImpl implements CasesRemoteDataSource {
  final FirebaseFirestore firestore;

  CasesRemoteDataSourceImpl({required this.firestore});

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
      docRef = firestore.collection('cases').doc();
    } else {
      docRef = firestore.collection('cases').doc(caseModel.id);
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
      expenses: caseModel.expenses,
      aidHistory: caseModel.aidHistory,
      createdAt: caseModel.createdAt,
    );

    await docRef.set(caseWithId.toJson());
  }

  @override
  Future<List<CaseModel>> getCases() async {
    final snapshot = await firestore.collection('cases').orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => CaseModel.fromJson(doc.data(), doc.id)).toList();
  }

  @override
  Future<CaseModel> getCaseById(String id) async {
    final doc = await firestore.collection('cases').doc(id).get();
    if (doc.exists) {
      return CaseModel.fromJson(doc.data()!, doc.id);
    } else {
      throw Exception('Case not found');
    }
  }
}
