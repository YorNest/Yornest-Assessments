const { makeCounter } = require('./js_closures');

describe('makeCounter', () => {
  it('should increment the counter each time', () => {
    const counter = makeCounter();
    expect(counter()).toBe(1);
    expect(counter()).toBe(2);
    expect(counter()).toBe(3);
  });

  it('should keep counter private for each instance', () => {
    const c1 = makeCounter();
    const c2 = makeCounter();
    expect(c1()).toBe(1);
    expect(c2()).toBe(1);
    expect(c1()).toBe(2);
    expect(c2()).toBe(2);
  });
}); 