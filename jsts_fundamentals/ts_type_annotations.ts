// Type Annotations Exercises
// =========================

// Q1: Annotate the following function so that it only accepts an array of numbers and returns a number.
function sum(arr: number[]): number {
  return arr.reduce((a, b) => a + b, 0);
}

export { sum }; 