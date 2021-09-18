import 'dart:convert';
import 'package:employee/employee_model.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial());
  List<EmployeeDetails> employeeList = [];

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    switch (event.runtimeType) {
      case EmployeeInitialEvent:
        yield* _loadEmployeeListingPage(event as EmployeeInitialEvent);
        break;
      case SearchEmployeeEvent:
        yield* _searchEmployee(event as SearchEmployeeEvent);
        break;
      default:
        break;
    }
  }

  ///handles the initial loading
  Stream<EmployeeState> _loadEmployeeListingPage(
      EmployeeInitialEvent event) async* {
    try {
      yield EmployeeInitialLoadingState();
      final response = await _fetchEmployees();
      employeeList = [EmployeeDetails.fromJson(jsonDecode(response.body))];
      yield EmployeePageLoadedState(
          key: UniqueKey(), employeeDetails: employeeList);
    } catch (error) {
      employeeList = [
        EmployeeDetails(
            id: 1,
            name: 'name',
            username: 'username',
            email: 'email',
            profileImage: 'https://randomuser.me/api/portraits/men/1.jpg',
            address: Address(
                street: 'street',
                suite: 'suite',
                city: 'city',
                zipcode: 'zipcode',
                geo: Geo(lat: 'lat', lng: 'lng')),
            phone: 'phone',
            website: 'website',
            company: Company(name: 'name', catchPhrase: 'ca', bs: 'bs'))
      ];
      // yield EmployeePageLoadedState(
      //     key: UniqueKey(), employeeDetails: employeeList);
      yield EmployeeErrorState('Something went wrong');
    }
  }

  ///invoke the api to get the employee list
  Future<http.Response> _fetchEmployees() {
    return http
        .get(Uri.parse('https://www.mocky.io/v2/5d565297300000680030a986'));
  }

  ///handles the employee search
  Stream<EmployeeState> _searchEmployee(SearchEmployeeEvent event) async* {
    String keyword = event.searchKeyWord.toLowerCase();
    List<EmployeeDetails> searchedEmployeeList = employeeList
        .where((employee) =>
            employee.name.toLowerCase().contains(keyword) ||
            employee.email.toLowerCase().contains(keyword))
        .toList();
    yield EmployeePageLoadedState(
        key: UniqueKey(), employeeDetails: searchedEmployeeList);
  }
}
