import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/User_Info_model.dart';

class UserInfoCubit extends Cubit<UserInfoModel> {
  UserInfoCubit() : super(const UserInfoModel());

  UserInfoModel get data => state;

  void update(UserInfoModel newData) => emit(newData);

  void updateUsername(String? value) => emit(data.copyWith(username: value));

  void updateAddictionType(String? value) =>
      emit(data.copyWith(addictionType: value));

  void updateStartDate(DateTime? value) =>
      emit(data.copyWith(startDate: value));

  void updateConsumptionDayPerWeek(int? value) =>
      emit(data.copyWith(consumptionDayPerWeek: value));

  void updateConsumptionPerDay(int? value) =>
      emit(data.copyWith(consumptionPerDay: value));

  void updateGoals(List<String>? value) => emit(data.copyWith(goals: value));

  void updateMainMotivation(String? value) =>
      emit(data.copyWith(mainMotivation: value));

  void updateImportanceForUser(String? value) =>
      emit(data.copyWith(importanceForUser: value));

  void updateImpliedPeople(String? value) =>
      emit(data.copyWith(impliedPeople: value));

  void updateFirstMilestone(String? value) =>
      emit(data.copyWith(firstMilestone: value));

  void updateDailyReview(DateTime? value) =>
      emit(data.copyWith(dailyReview: value));
}
