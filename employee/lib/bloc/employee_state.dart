part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeInitialLoadingState extends EmployeeState {
  @override
  List<Object> get props => [];
}

class EmployeePageLoadedState extends EmployeeState {
  EmployeePageLoadedState({required this.key, required this.employeeDetails});
  final List<EmployeeDetails> employeeDetails;
  final Key key;

  @override
  List<Object> get props => [key];
}

class EmployeeErrorState extends EmployeeState {
  EmployeeErrorState(this.errorMessage);
  final String errorMessage;

  @override
  List<Object> get props => [];
}
