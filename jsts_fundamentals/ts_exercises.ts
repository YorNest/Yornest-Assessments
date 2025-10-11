// TypeScript Coding Exercises
// ===========================

// 1. Type Annotations
// Q1: Annotate the following function so that it only accepts an array of numbers and returns a number.
function sum(arr /* TODO: annotate */) /* TODO: annotate */ {
  return arr.reduce((a, b) => a + b, 0);
}

// 2. Generics
// Q2: Write a generic function 'first' that returns the first element of an array of any type.
function first<T>(arr: T[]): T | undefined {
  // TODO: implement
  return undefined;
}

// 3. Interfaces vs Types
// Q3: Define an interface 'User' with properties 'id' (number) and 'name' (string).
// TODO: define interface User

// 4. Union & Intersection Types
// Q4: Define a type 'StringOrNumber' that can be either a string or a number.
// TODO: define type StringOrNumber

// 5. Enums
// Q5: Define a numeric enum 'Direction' with values 'Up', 'Down', 'Left', 'Right'.
// TODO: define enum Direction

// 6. Type Guards
// Q6: Write a type guard function 'isString' that checks if a value is a string.
function isString(value: unknown): value is string {
  // TODO: implement
  return typeof value === 'string'; // placeholder, but correct
} 