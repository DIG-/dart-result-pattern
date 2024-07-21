import 'dart:math';

import 'package:result_pattern/async.dart';
import 'package:result_pattern/result.dart';

class Person {
  final String name;
  final int age;
  const Person(this.name, this.age);
}

Result<String> taskThatCanFail() {
  if (Random().nextInt(6) == 0) {
    return Result.failure(Error());
  }
  return Result.success('It is success');
}

FutureResult<List<Person>> getAllPeople() async {
  // simulate some repository access
  return const Result.success([
    Person('Adonis', 30),
    Person('Simon', 25),
    Person('Pistis', 20),
    Person('Selene', 15),
    Person('Polyphemos', 10),
  ]);
}

FutureResult<List<Person>> getPeopleAboveAge(int age) => getAllPeople().next(
      (people) => Result.success(
        people.where((person) => person.age > age).toList(),
      ),
    );

FutureResult<List<Person>> getPeopleBellowAge(int age) async {
  final people = await getAllPeople();
  return switch (people) {
    ResultSuccess<List<Person>>() => Result.success(
        people.value.where((person) => person.age < age).toList(),
      ),
    ResultFailure<List<Person>>() => people,
  };
}

void main() {
  taskThatCanFail().then((str) => Result.success(str.length)).fold((value) {
    print('Success: $value');
  }, onError: (error) {
    print('Error: $error');
  });

  getPeopleAboveAge(20).fold((people) {
    print('People above 20:');
    for (final person in people) {
      print('  ${person.name}');
    }
  }, onError: (error) {
    print('Some error happen: $error');
  });

  getPeopleBellowAge(20).fold((people) {
    print('People bellow 20:');
    for (final person in people) {
      print('  ${person.name}');
    }
  }, onError: (error) {
    print('Some error happen: $error');
  });
}
