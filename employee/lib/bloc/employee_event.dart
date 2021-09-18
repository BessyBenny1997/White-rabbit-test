part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class EmployeeInitialEvent extends EmployeeEvent {
  EmployeeInitialEvent();
  @override
  List<Object> get props => [];
}

class SearchEmployeeEvent extends EmployeeEvent {
  SearchEmployeeEvent({required this.searchKeyWord});
  final String searchKeyWord;
  @override
  List<Object> get props => [];
}
