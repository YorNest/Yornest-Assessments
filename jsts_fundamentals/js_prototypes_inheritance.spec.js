const { Person } = require('./js_prototypes_inheritance');

describe('Person', () => {
  it('should greet with the correct name', () => {
    const p = new Person('Shaq');
    expect(p.greet()).toBe('Hello, my name is Shaq');
    const q = new Person('Alex');
    expect(q.greet()).toBe('Hello, my name is Alex');
  });
}); 