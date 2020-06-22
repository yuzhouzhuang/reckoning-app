import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddEventModal extends StatefulWidget {
  static const routeName = '/addEventPage';
  final ScrollController scrollController;

  AddEventModal({Key key, this.scrollController}) : super(key: key);

  @override
  _AddEventModalState createState() => _AddEventModalState();
}

class _AddEventModalState extends State<AddEventModal> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                    'accept_terms': false,
                  },
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: "age",
                        decoration: InputDecoration(labelText: "Age"),
                        validators: [
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.max(70),
                        ],
                      ),
                      FormBuilderSwitch(
                        label: Text('I Accept the tems and conditions'),
                        attribute: "accept_terms_switch",
                        initialValue: true,
                      ),
                      FormBuilderChoiceChip(
                        attribute: "favorite_ice_cream",
                        options: [
                          FormBuilderFieldOption(
                              child: Text("Vanilla"),
                              value: "vanilla"
                          ),
                          FormBuilderFieldOption(
                              child: Text("Chocolate"),
                              value: "chocolate"
                          ),
                          FormBuilderFieldOption(
                              child: Text("Strawberry"),
                              value: "strawberry"
                          ),
                          FormBuilderFieldOption(
                              child: Text("Peach"),
                              value: "peach"
                          ),
                        ],
                      ),
                      FormBuilderFilterChip(
                        attribute: "pets",
                        options: [
                          FormBuilderFieldOption(
                              child: Text("Cats"),
                              value: "cats"
                          ),
                          FormBuilderFieldOption(
                              child: Text("Dogs"),
                              value: "dogs"
                          ),
                          FormBuilderFieldOption(
                              child: Text("Rodents"),
                              value: "rodents"
                          ),
                          FormBuilderFieldOption(
                              child: Text("Birds"),
                              value: "birds"
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                      child: Text("Submit"),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value);
                        }
                      },
                    ),
                    MaterialButton(
                      child: Text("Reset"),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
