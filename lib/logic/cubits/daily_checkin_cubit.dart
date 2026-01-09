// daily_checkin_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/check_in_repository.dart';
import '../../data/repositories/check_in_repository_abstract.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

// States
abstract class DailyCheckInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckInInitial extends DailyCheckInState {}

class CheckInInProgress extends DailyCheckInState {
  final String selectedMood;
  final double cravingLevel;
  final String journalEntry;
  final bool slipped;
  final int slipAmount;

  CheckInInProgress({
    this.selectedMood = '',
    this.cravingLevel = 0.5,
    this.journalEntry = '',
    this.slipped = false,
    this.slipAmount = 0,
  });

  @override
  List<Object?> get props => [selectedMood, cravingLevel, journalEntry, slipped, slipAmount];

  CheckInInProgress copyWith({
    String? selectedMood,
    double? cravingLevel,
    String? journalEntry,
    bool? slipped,
    int? slipAmount,
  }) {
    return CheckInInProgress(
      selectedMood: selectedMood ?? this.selectedMood,
      cravingLevel: cravingLevel ?? this.cravingLevel,
      journalEntry: journalEntry ?? this.journalEntry,
      slipped: slipped ?? this.slipped,
      slipAmount: slipAmount ?? this.slipAmount,
    );
  }

  bool get isValid {
    final hasMood = selectedMood.isNotEmpty;
    if (!hasMood) return false;
    if (slipped) {
      return slipAmount > 0;
    }
    return true;
  }
}

class CheckInSubmitting extends DailyCheckInState {
  final String selectedMood;
  final double cravingLevel;
  final String journalEntry;
  final bool slipped;
  final int slipAmount;

  CheckInSubmitting({
    required this.selectedMood,
    required this.cravingLevel,
    required this.journalEntry,
    required this.slipped,
    required this.slipAmount,
  });

  @override
  List<Object?> get props => [selectedMood, cravingLevel, journalEntry, slipped, slipAmount];
}

class CheckInCompleted extends DailyCheckInState {
  final DateTime completedAt;

  CheckInCompleted({required this.completedAt});

  @override
  List<Object?> get props => [completedAt];
}

class CheckInError extends DailyCheckInState {
  final String message;

  CheckInError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class DailyCheckInCubit extends Cubit<DailyCheckInState> {
  final CheckInRepository _checkInRepository = CheckInRepositoryImpl();

  DailyCheckInCubit() : super(CheckInInitial()) {
    _checkIfAlreadyCompletedToday();
  }

  // Check if check-in was already completed today
  Future<void> _checkIfAlreadyCompletedToday() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      final addictionId = await SharedPreferencesHelper.getAddictionId();

      if (userId == null || addictionId == null) {
        emit(CheckInInProgress());
        return;
      }

      final hasCheckedIn = await _checkInRepository.hasCheckedInToday(
        userId: userId,
        addictionId: addictionId,
      );

      if (hasCheckedIn) {
        emit(CheckInCompleted(completedAt: DateTime.now()));
      } else {
        emit(CheckInInProgress());
      }
    } catch (e) {
      print('Error checking if already completed: $e');
      emit(CheckInInProgress());
    }
  }

  void updateMood(String mood) {
    if (state is CheckInInProgress) {
      final currentState = state as CheckInInProgress;
      emit(currentState.copyWith(selectedMood: mood));
    }
  }

  void updateCravingLevel(double level) {
    if (state is CheckInInProgress) {
      final currentState = state as CheckInInProgress;
      emit(currentState.copyWith(cravingLevel: level));
    }
  }

  void updateSlipped(bool slipped) {
    if (state is CheckInInProgress) {
      final currentState = state as CheckInInProgress;
      // Reset slip amount when toggling off
      emit(
        currentState.copyWith(
          slipped: slipped,
          slipAmount: slipped
              ? (currentState.slipAmount <= 0 ? 1 : currentState.slipAmount)
              : 0,
        ),
      );
    }
  }

  void updateSlipAmount(int amount) {
    if (state is CheckInInProgress) {
      final currentState = state as CheckInInProgress;
      emit(currentState.copyWith(slipAmount: amount));
    }
  }

  void updateJournalEntry(String entry) {
    if (state is CheckInInProgress) {
      final currentState = state as CheckInInProgress;
      emit(currentState.copyWith(journalEntry: entry));
    }
  }

  Future<void> submitCheckIn(
    Future<bool> Function({
      required String mood,
      required double cravingLevel,
      required String journalEntry,
      required bool slipped,
      required int slipAmount,
    })
    submitFunction,
  ) async {
    if (state is! CheckInInProgress) return;

    final currentState = state as CheckInInProgress;

    // Validate that mood and craving level are selected
    if (!currentState.isValid) {
      // Note: Error message will be localized in the UI layer
      emit(CheckInError(message: 'VALIDATION_ERROR'));
      Future.delayed(const Duration(seconds: 2), () {
        emit(currentState);
      });
      return;
    }

    emit(
      CheckInSubmitting(
        selectedMood: currentState.selectedMood,
        cravingLevel: currentState.cravingLevel,
        journalEntry: currentState.journalEntry,
        slipped: currentState.slipped,
        slipAmount: currentState.slipAmount,
      ),
    );

    try {
      final success = await submitFunction(
        mood: currentState.selectedMood,
        cravingLevel: currentState.cravingLevel,
        journalEntry: currentState.journalEntry,
        slipped: currentState.slipped,
        slipAmount: currentState.slipAmount,
      );

      if (success) {
        emit(CheckInCompleted(completedAt: DateTime.now()));
      } else {
        emit(CheckInError(message: 'Failed to submit check-in'));
        // Return to in-progress state after error
        Future.delayed(const Duration(seconds: 2), () {
          emit(currentState);
        });
      }
    } catch (e) {
      emit(CheckInError(message: e.toString()));
      // Return to in-progress state after error
      Future.delayed(const Duration(seconds: 2), () {
        emit(currentState);
      });
    }
  }

  void resetCheckIn() {
    emit(CheckInInProgress());
  }
}
