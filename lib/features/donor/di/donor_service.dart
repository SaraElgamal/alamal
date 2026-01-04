import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/donor_model.dart';

abstract class DonorsService {
  Future<void> addDonor(DonorModel donorModel);
  Future<List<DonorModel>> getDonors();
}

class DonorsServiceImpl implements DonorsService {
  final FirebaseFirestore firestore;

  DonorsServiceImpl({required this.firestore});

  @override
  Future<void> addDonor(DonorModel donorModel) async {
    DocumentReference docRef = firestore.collection('donations').doc();

    final donorWithId = DonorModel(
      id: docRef.id,
      name: donorModel.name,
      phone: donorModel.phone,
      donationType: donorModel.donationType,
      amount: donorModel.amount,
      description: donorModel.description,
      date: donorModel.date,
    );

    await docRef.set(donorWithId.toJson());
  }

  @override
  Future<List<DonorModel>> getDonors() async {
    final snapshot = await firestore
        .collection('donations')
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => DonorModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
