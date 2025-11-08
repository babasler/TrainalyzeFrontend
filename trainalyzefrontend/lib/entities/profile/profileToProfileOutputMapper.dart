import 'package:trainalyzefrontend/entities/profile/profile.dart';

ProfileOutputDTO mapProfileToProfileOutputDTO(
    Profile profile) {
  return ProfileOutputDTO(
    profileId: profile.profileId,
    weightIncreaseType: profile.weightIncreaseType,
    increaseWeight: profile.increaseWeight,
    increaseAtReps: profile.increaseAtReps,
    workoutSelection: profile.workoutSelection,
    selectedTrainingsplan: profile.selectedTrainingsplan,
    handleMissingWorkout: profile.handleMissingWorkout,
    bodyWeight: profile.bodyWeight,
    bodyHeight: profile.bodyHeight,
  );
}