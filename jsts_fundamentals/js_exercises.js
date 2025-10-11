// JavaScript Coding Exercises
// ==========================

// 1. Scope & Hoisting
// Q1: What will the following code output? Why?
// (No code to implement)

// Q2: Rewrite the following code so that 'i' is block-scoped and the output is 0 1 2 (not 3 3 3):
// for (var i = 0; i < 3; i++) {
//   setTimeout(() => console.log(i), 0);
// }
// (No code to implement)

// 3. Closures
// Q3: Write a function 'makeCounter' that returns a function which increments and returns a private counter.
function makeCounter() {
  // TODO: implement closure counter
}

// 4. Pass-by-value/reference
// Q4: What will the following code output? Why?
// (No code to implement)

// 5. Array/Object Manipulation
// Q5: Write a function 'doubleEvens' that takes an array of numbers and returns a new array with only the even numbers, each doubled.
function doubleEvens(arr) {
  // TODO: implement
}

// 6. Promises & Async/Await
// Q6: Write an async function 'fetchData' that takes a URL and returns the JSON response. Use try/catch for error handling.
async function fetchData(url) {
  // TODO: implement
}

// 7. Prototypes & Inheritance
// Q7: Write a constructor function 'Person' with a method 'greet' on its prototype that returns 'Hello, my name is <name>'.
function Person(name) {
  // TODO: implement
}
// Add greet to Person.prototype
// TODO: implement 