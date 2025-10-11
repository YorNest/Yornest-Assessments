const { doubleEvens } = require('./js_array_object');

describe('doubleEvens', () => {
  it('should return doubled even numbers only', () => {
    expect(doubleEvens([1,2,3,4])).toEqual([4,8]);
    expect(doubleEvens([2,4,6])).toEqual([4,8,12]);
    expect(doubleEvens([1,3,5])).toEqual([]);
  });
}); 