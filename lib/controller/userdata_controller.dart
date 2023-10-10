// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

/// A class responsible for managing user data using Firestore.
class UserDataController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  /// Retrieves a list of user names along with their total success points.
  ///
  /// Returns a list of maps containing 'userName' and 'successPoint'.
  Future<List<Map<String, dynamic>>> getAllUserNamesWithPoints() async {
    try {
      final QuerySnapshot snapshot = await usersCollection.get();
      final List<Map<String, dynamic>> userNamesWithPoints = [];

      for (final DocumentSnapshot doc in snapshot.docs) {
        final String? userName = doc['uName'];

        final QuerySnapshot successPointSnapshot = await usersCollection
            .doc(doc.id)
            .collection('uDailysuccesspoint')
            .get();

        int totalSuccessPoint = 0;
        for (final DocumentSnapshot successPointDoc
            in successPointSnapshot.docs) {
          final int successPoint = successPointDoc['uSuccessPoint'] ?? 0;
          totalSuccessPoint += successPoint;
        }

        if (userName != null) {
          final Map<String, dynamic> userWithPoint = {
            'userName': userName,
            'successPoint': totalSuccessPoint,
          };
          userNamesWithPoints.add(userWithPoint);
        }
      }

      userNamesWithPoints
          .sort((a, b) => b['successPoint'].compareTo(a['successPoint']));

      return userNamesWithPoints;
    } catch (e) {
      print('Error fetching user names with points: $e');
      return [];
    }
  }

  /// Retrieves daily calories data for a specific user and date.
  ///
  /// Returns a map containing daily calories data, or an empty map if data is not found.
  Future<Map<String, dynamic>> getDailyCaloriesData(
      String userId, String date) async {
    try {
      final DocumentReference userRef =
          firestore.collection('users').doc(userId);
      final DocumentReference caloriesRef = userRef
          .collection('uDailysuccesspoint')
          .doc(date)
          .collection('uCalories')
          .doc('data');

      final DocumentSnapshot caloriesSnapshot = await caloriesRef.get();
      if (caloriesSnapshot.exists) {
        final Map<String, dynamic> caloriesData =
            caloriesSnapshot.data() as Map<String, dynamic>;
        return caloriesData;
      }
    } catch (e) {
      print('Error getting daily calories: $e');
    }

    return {};
  }

  /// Retrieves daily success point data for a specific user and date.
  ///
  /// Returns a map containing daily success point data, or an empty map if data is not found.
  Future<Map<String, dynamic>> getDailySuccessPoint(
      String userId, String date) async {
    try {
      final DocumentReference userRef =
          firestore.collection('users').doc(userId);
      final DocumentReference successPointRef =
          userRef.collection('uDailysuccesspoint').doc(date);

      final DocumentSnapshot successPointSnapshot = await successPointRef.get();
      if (successPointSnapshot.exists) {
        final Map<String, dynamic> successPointData =
            successPointSnapshot.data() as Map<String, dynamic>;
        return successPointData;
      }
    } catch (e) {
      print('Error getting daily success point: $e');
    }

    return {};
  }

  /// Retrieves BMI data for a specific user.
  ///
  /// Returns a map containing BMI data, or an empty map if data is not found.
  Future<Map<String, dynamic>> getDataBMI(String userId) async {
    try {
      final DocumentReference userRef =
          firestore.collection('users').doc(userId);
      final DocumentReference dataBMIRef =
          userRef.collection('uBMI').doc('data');

      final DocumentSnapshot dataBMISnapshot = await dataBMIRef.get();
      if (dataBMISnapshot.exists) {
        final Map<String, dynamic> dataBMI =
            dataBMISnapshot.data() as Map<String, dynamic>;
        return dataBMI;
      }
    } catch (e) {
      print('Error getting BMI data: $e');
    }

    return {};
  }

  /// Retrieves the global rank of a specific user based on their success points.
  ///
  /// Returns the user's global rank as an integer.
  Future<int> getGlobalRank(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('uSuccessPoint', descending: true)
        .get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    int userRank = 0;

    for (int i = 0; i < documents.length; i++) {
      String documentUserId = documents[i].id;

      if (documentUserId == userId) {
        userRank = i + 1;
        break;
      }
    }

    return userRank;
  }

  /// Updates the BMI data for a specific user.
  ///
  /// Parameters:
  /// - userId: The ID of the user.
  /// - weight: The user's weight.
  /// - height: The user's height.
  /// - bmiResult: The calculated BMI result.
  /// - bmiCategory: The BMI category.
  /// - waterRecomendation: Recommended water intake.
  /// - sleepRecomendation: Recommended sleep duration.
  /// - exerciseRecomendation: Recommended exercise duration.
  /// - calorieRecomendation: Recommended daily calorie intake.
  Future<void> updateBMI(
    String userId,
    int weight,
    int height,
    double bmiResult,
    String bmiCategory,
    int waterRecomendation,
    int sleepRecomendation,
    int exerciseRecomendation,
    int calorieRecomendation,
  ) async {
    try {
      final DocumentReference userRef =
          firestore.collection('users').doc(userId);
      final DocumentReference dataBMIRef =
          userRef.collection('uBMI').doc('data');

      final DocumentSnapshot dataBMISnapshot = await dataBMIRef.get();
      if (!dataBMISnapshot.exists) {
        final Map<String, dynamic> dataBMI = {
          'uWeight': weight,
          'uHeight': height,
          'uBMIResult': bmiResult,
          'uBMICategory': bmiCategory,
          'uWaterRecomendation': waterRecomendation,
          'uSleepRecomendation': sleepRecomendation,
          'uExerciseRecomendation': exerciseRecomendation,
          'uCalorieRecomendation': calorieRecomendation,
        };

        await dataBMIRef.set(dataBMI);
      } else {
        await dataBMIRef.update({
          'uWeight': weight,
          'uHeight': height,
          'uBMIResult': bmiResult,
          'uBMICategory': bmiCategory,
          'uWaterRecomendation': waterRecomendation,
          'uSleepRecomendation': sleepRecomendation,
          'uExerciseRecomendation': exerciseRecomendation,
          'uCalorieRecomendation': calorieRecomendation,
        });
      }
    } catch (e) {
      print('Error updating BMI data: $e');
    }
  }

  /// Updates the daily success point data for a specific user and date.
  ///
  /// Parameters:
  /// - userId: The ID of the user.
  /// - date: The date for which the data should be updated.
  /// - hydrationLevel: The user's hydration level.
  /// - exerciseDuration: The duration of exercise.
  /// - calorieCount: The calorie count.
  /// - sleepDuration: The duration of sleep.
  Future<void> updateDailySuccessPoint(
      String userId,
      String date,
      int hydrationLevel,
      int exerciseDuration,
      int calorieCount,
      int sleepDuration) async {
    try {
      final DocumentReference userRef =
          firestore.collection('users').doc(userId);
      final DocumentReference successPointRef =
          userRef.collection('uDailysuccesspoint').doc(date);

      final DocumentSnapshot successPointSnapshot = await successPointRef.get();
      if (successPointSnapshot.exists) {
        final Map<String, dynamic> successPointData =
            successPointSnapshot.data() as Map<String, dynamic>;

        final int hydrationPoint = hydrationLevel >= 2000 ? 1 : 0;
        final int exercisePoint = exerciseDuration >= 30 ? 1 : 0;
        final int caloriePoint = calorieCount <= 2000 ? 1 : 0;
        final int sleepPoint = sleepDuration >= 7 ? 1 : 0;
        final int successPoint =
            hydrationPoint + exercisePoint + caloriePoint + sleepPoint;

        successPointData['uHydrationLevel'] = hydrationLevel;
        successPointData['uHydrationPoint'] = hydrationPoint;
        successPointData['uExerciseDuration'] = exerciseDuration;
        successPointData['uExercisePoint'] = exercisePoint;
        successPointData['uCalorieCount'] = calorieCount;
        successPointData['uCaloriePoint'] = caloriePoint;
        successPointData['uSleepDuration'] = sleepDuration;
        successPointData['uSleepPoint'] = sleepPoint;
        successPointData['uSuccessPoint'] = successPoint;

        await successPointRef.update(successPointData);
      }
    } catch (e) {
      print('Error updating daily success point: $e');
    }
  }
}
