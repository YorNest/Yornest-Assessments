const { fetchData } = require('./js_promises_async');

global.fetch = jest.fn();

describe('fetchData', () => {
  beforeEach(() => {
    fetch.mockClear();
  });

  it('returns JSON response on success', async () => {
    fetch.mockResolvedValueOnce({
      json: () => Promise.resolve({ foo: 'bar' })
    });
    const data = await fetchData('http://example.com');
    expect(data).toEqual({ foo: 'bar' });
  });

  it('handles fetch errors', async () => {
    fetch.mockRejectedValueOnce(new Error('fail'));
    await expect(fetchData('http://fail')).resolves.toBeNull();
  });
}); 