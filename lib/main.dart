import 'package:flutter/material.dart';

void main() {
  runApp(const CharityApp());
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);
}

class Charity {
  List<Person> needyPeople = [];

  void addPerson(Person person) {
    needyPeople.add(person);
  }

  List<Person> getNeedyPeople() {
    return needyPeople;
  }

  void donateToPerson(Person person) {
    // Реалізація пожертви
  }
}

class CharityApp extends StatelessWidget {
  const CharityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Благодійність',
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  bool _isDonor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ім\'я та Прізвище'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Вік'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Я благодійник:'),
                Checkbox(
                  value: _isDonor,
                  onChanged: (value) {
                    _isDonor = value!;
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                int age = int.tryParse(_ageController.text) ?? 0;

                if (name.isNotEmpty && age > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharityScreen(
                        person: Person(name, age),
                        isDonor: _isDonor,
                      ),
                    ),
                  );
                } else {
                  // Повідомлення про помилку
                }
              },
              child: const Text('Продовжити'),
            ),
          ],
        ),
      ),
    );
  }
}

class CharityScreen extends StatelessWidget {
  final Person person;
  final bool isDonor;
  final Charity charity = Charity();

  CharityScreen({super.key, required this.person, required this.isDonor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isDonor ? 'Список потребуючих' : 'Пожертвувати'),
      ),
      body: isDonor
          ? ListView.builder(
        itemCount: charity.getNeedyPeople().length,
        itemBuilder: (context, index) {
          var needyPerson = charity.getNeedyPeople()[index];
          return ListTile(
            title: Text(needyPerson.name),
            subtitle: Text("Вік: ${needyPerson.age}"),
          );
        },
      )
          : Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Пожертва'),
                  content:
                  Text('Ви хочете пожертвувати ${person.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Відмінити'),
                    ),
                    TextButton(
                      onPressed: () {
                        charity.donateToPerson(person);
                        Navigator.pop(context);
                      },
                      child: const Text('Пожертвувати'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Пожертвувати'),
        ),
      ),
    );
  }
}
