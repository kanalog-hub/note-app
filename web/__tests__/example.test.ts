import { describe, it, expect } from 'vitest'

describe('Example Test', () => {
  it('should pass', () => {
    expect(1 + 1).toBe(2)
  })

  it('string concatenation', () => {
    expect('Hello' + ' ' + 'World').toBe('Hello World')
  })
})
