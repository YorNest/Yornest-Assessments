import { first } from './ts_generics';

describe('first', () => {
  it('returns the first element of a number array', () => {
    expect(first([1,2,3])).toBe(1);
  });
  it('returns the first element of a string array', () => {
    expect(first(['a','b','c'])).toBe('a');
  });
  it('returns undefined for empty array', () => {
    expect(first([])).toBeUndefined();
  });
}); 