import 'package:employee/bloc/employee_bloc.dart';
import 'package:employee/employee_details_page.dart';
import 'package:employee/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _imageCornerRadius = Radius.circular(6);

class EmployeeDirectory extends StatefulWidget {
  EmployeeDirectory({required Key key}) : super(key: key);

  @override
  _EmployeeDirectoryState createState() => _EmployeeDirectoryState();
}

class _EmployeeDirectoryState extends State<EmployeeDirectory> {
  late EmployeeBloc _employeeBloc;

  @override
  void initState() {
    super.initState();
    _employeeBloc = EmployeeBloc();
    _employeeBloc.add(EmployeeInitialEvent());
  }

  ///returns the details of each employee with name and image
  Widget _employeeTile(EmployeeDetails employee) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmployeeDetailPage(employee: employee)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.red),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
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
            ),
            SizedBox(width: 50),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(employee.name),
                  Text(employee.company.name),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///widget for searching a employee with name or email
  Widget _searchEmployeeWidget(BuildContext context) => TextFormField(
        textAlign: TextAlign.left,
        decoration: InputDecoration(
            hintText: 'Search for an employee name/email ID',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )),
        onChanged: (String text) {
          BlocProvider.of<EmployeeBloc>(context)
              .add(SearchEmployeeEvent(searchKeyWord: text));
        },
      );

  ///layout for the employee listing page
  Widget _employeePageLayout(
          List<EmployeeDetails> employeeDetails, BuildContext context) =>
      Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _searchEmployeeWidget(context),
            employeeDetails.isEmpty
                ? Text('No employee found')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: employeeDetails.length,
                    separatorBuilder: (context, index) => SizedBox(height: 25),
                    itemBuilder: (context, employeeIndex) =>
                        _employeeTile(employeeDetails[employeeIndex]),
                  ),
          ],
        ),
      );

  ///listen whenever the state changes
  void _listenStateChanges(BuildContext context, EmployeeState state) {
    if (state is EmployeeErrorState) {
      showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
                content: Text(state.errorMessage),
                actions: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ));
    }
  }

  ///builder for every state changes
  Widget _rebuildUIForState(BuildContext context, EmployeeState state) {
    switch (state.runtimeType) {
      case EmployeeInitialLoadingState:
        return Center(child: CircularProgressIndicator());
      case EmployeePageLoadedState:
        return _employeePageLayout(
            (state as EmployeePageLoadedState).employeeDetails, context);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Directory')),
      body: BlocProvider.value(
          value: _employeeBloc,
          child: BlocConsumer<EmployeeBloc, EmployeeState>(
            builder: _rebuildUIForState,
            listener: _listenStateChanges,
          )),
    );
  }
}
