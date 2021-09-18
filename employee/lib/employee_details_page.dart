import 'package:employee/employee_model.dart';
import 'package:flutter/material.dart';

const _gapBtwnFields = SizedBox(height: 5);
const _imageCornerRadius = Radius.circular(6);

class EmployeeDetailPage extends StatelessWidget {
  const EmployeeDetailPage({required this.employee}) : super();
  final EmployeeDetails employee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(employee.name)),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: _imageCornerRadius,
                        topRight: _imageCornerRadius),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/placeholder.png'),
                      image: NetworkImage(employee.profileImage),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text('Name: ${employee.name}'),
                _gapBtwnFields,
                Text('User name: ${employee.username}'),
                _gapBtwnFields,
                Text('Email address: ${employee.email}'),
                _gapBtwnFields,
                Text(
                    'Address: ${employee.address.suite}, ${employee.address.street}, ${employee.address.city}'),
                _gapBtwnFields,
                Text('Phone: ${employee.phone}'),
                _gapBtwnFields,
                Text('Website: ${employee.website}'),
                _gapBtwnFields,
                Text(
                    'Company Details: ${employee.company.name}, ${employee.company.catchPhrase}, ${employee.company.bs}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
