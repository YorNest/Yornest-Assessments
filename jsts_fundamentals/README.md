# JavaScript & TypeScript Interview Prep Exercises

This project contains standalone coding exercises and automated tests to help you practice core JavaScript and TypeScript concepts for interviews.

## Project Structure

- Each topic (e.g., closures, array methods, generics) has its own file.
- Each exercise file has a corresponding Jest test file (with `.spec.js` or `.spec.ts` extension).
- All files are standalone modules.

## Getting Started

### 1. Install Dependencies

```
npm install
```

### 2. Run All Tests

```
npx jest
```

- This will run all JavaScript and TypeScript tests and show you which exercises are passing or failing.

### 3. Implement Exercises

- Open any exercise file (e.g., `js_closures.js`, `ts_generics.ts`).
- Implement the function(s) as described in the comments.
- Re-run `npx jest` to check your progress.

### 4. Project Files

- **JavaScript:**
  - `js_closures.js` / `js_closures.spec.js`
  - `js_array_object.js` / `js_array_object.spec.js`
  - `js_promises_async.js` / `js_promises_async.spec.js`
  - `js_prototypes_inheritance.js` / `js_prototypes_inheritance.spec.js`
- **TypeScript:**
  - `ts_type_annotations.ts`
  - `ts_generics.ts` / `ts_generics.spec.ts`
  - `ts_interfaces_types.ts`
  - `ts_union_intersection.ts`
  - `ts_enums.ts`
  - `ts_type_guards.ts` / `ts_type_guards.spec.ts`

### 5. Notes

- All exercises start unimplemented. Tests will fail until you solve them.
- You can work on any file independently.
- If you add new exercises, create a matching `.spec.js` or `.spec.ts` file for tests.

---

Happy practicing! 