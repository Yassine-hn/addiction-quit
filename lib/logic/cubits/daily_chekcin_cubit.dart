// daily_checkin_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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

  CheckInInProgress({
    this.selectedMood = '',
    this.cravingLevel = 0.5,
    this.journalEntry = '',
  });

  @override
  List<Object?> get props => [selectedMood, cravingLevel, journalEntry];

  CheckInInProgress copyWith({
    String? selectedMood,
    double? cravingLevel,
    String? journalEntry,
  }) {
    return CheckInInProgress(
      selectedMood: selectedMood ?? this.selectedMood,
      cravingLevel: cravingLevel ?? this.cravingLevel,
      journalEntry: journalEntry ?? this.journalEntry,
    );
  }
}

class CheckInSubmitting extends DailyCheckInState {
  final String selectedMood;
  final double cravingLevel;
  final String journalEntry;

  CheckInSubmitting({
    required this.selectedMood,
    required this.cravingLevel,
    required this.journalEntry,
  });

  @override
  List<Object?> get props => [selectedMood, cravingLevel, journalEntry];
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
  DailyCheckInCubit() : super(CheckInInitial()) {
    _checkIfAlreadyCompletedToday();
  }

  // Check if check-in was already completed today
  void _checkIfAlreadyCompletedToday() {
    // TODO: Implement check with your backend/local storage
    // For now, we'll start fresh each time
    emit(CheckInInProgress());
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
    })
    submitFunction,
  ) async {
    if (state is! CheckInInProgress) return;

    final currentState = state as CheckInInProgress;

    emit(
      CheckInSubmitting(
        selectedMood: currentState.selectedMood,
        cravingLevel: currentState.cravingLevel,
        journalEntry: currentState.journalEntry,
      ),
    );

    try {
      final success = await submitFunction(
        mood: currentState.selectedMood,
        cravingLevel: currentState.cravingLevel,
        journalEntry: currentState.journalEntry,
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

  // Helper method to check if completed today
  bool isCompletedToday() {
    if (state is CheckInCompleted) {
      final completedState = state as CheckInCompleted;
      final now = DateTime.now();
      final completedDate = completedState.completedAt;
      return now.year == completedDate.year &&
          now.month == completedDate.month &&
          now.day == completedDate.day;
    }
    return false;
  }
}
