import { isString } from './ts_type_guards';

describe('isString', () => {
  it('returns true for strings', () => {
    expect(isString('hello')).toBe(true);
    expect(isString(String('world'))).toBe(true);
  });
  it('returns false for non-strings', () => {
    expect(isString(123)).toBe(false);
    expect(isString({})).toBe(false);
    expect(isString([])).toBe(false);
    expect(isString(undefined)).toBe(false);
  });
}); 