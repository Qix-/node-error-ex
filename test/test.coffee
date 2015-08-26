should = require 'should'
errorEx = require '../'

Error.stackTraceLimit = Infinity

it 'should create a default error type', ->
  TestError = errorEx()
  err = new TestError 'herp derp'
  err.should.be.instanceOf TestError
  err.should.be.instanceOf Error
  err.name.should.equal Error.name
  err.message.should.equal 'herp derp'

it 'should create a new error type', ->
  TestError = errorEx 'TestError'
  err = new TestError 'herp derp'
  err.should.be.instanceOf TestError
  err.should.be.instanceOf Error
  err.name.should.equal 'TestError'
  testLine = err.stack.toString().split(/\r?\n/g)[0]
  testLine.should.equal 'TestError: herp derp'

it 'should add a custom property line', ->
  TestError = errorEx 'TestError', foo:line: -> 'bar'
  err = new TestError 'herp derp'
  testLine = err.stack.toString().split(/\r?\n/g)[1]
  testLine.should.equal '    bar'

it 'should allow properties', ->
  TestError = errorEx 'TestError', foo:line: (v)-> "foo #{v}" if v
  err = new TestError 'herp derp'
  testLine = err.stack.toString().split(/\r?\n/g)[1]
  testLine.substr(0, 3).should.not.equal 'foo'
  err.foo = 'bar'
  testLine = err.stack.toString().split(/\r?\n/g)[1]
  testLine.should.equal '    foo bar'

it 'should allow direct editing of the stack', ->
  TestError = errorEx 'TestError',
    foo:stack: (v, stack)-> stack[0] += " #{v}" if v
  err = new TestError 'herp derp'
  err.foo = 'magerp'
  testLine = err.stack.toString().split(/\r?\n/g)[0]
  testLine.should.equal 'TestError: herp derp magerp'

it 'should work on existing errors', ->
  originalErr = new Error 'herp derp'
  TestError = errorEx 'TestError', foo:line: (v)-> "foo #{v}"
  TestError.call originalErr
  originalErr.message.should.equal 'herp derp'
  originalErr.name.should.equal 'TestError'
  originalErr.foo = 'bar'
  testLine = originalErr.stack.toString().split(/\r?\n/g)[1]
  testLine.should.equal '    foo bar'

it 'should take in an existing error to the constructor', ->
  originalErr = new Error 'herp derp'
  TestError = errorEx 'TestError'
  newErr = new TestError originalErr
  newErr.message.should.equal originalErr.message

describe 'helpers', ->
  describe 'append', ->
    it 'should append to the error string', ->
      TestError = errorEx 'TestError', fileName: errorEx.append 'in %s'
      err = new TestError 'error'
      err.fileName = '/a/b/c/foo.txt'
      testLine = err.stack.toString().split(/\r?\n/g)[0]
      testLine.should.equal 'TestError: error in /a/b/c/foo.txt'

    it 'should append to a multi-line error string', ->
      TestError = errorEx 'TestError', fileName: errorEx.append 'in %s'
      err = new TestError 'error\n}\n^'
      err.fileName = '/a/b/c/foo.txt'
      testLine = err.stack.toString().split(/\r?\n/g)[0]
      testLine.should.equal 'TestError: error in /a/b/c/foo.txt'
      err.message.should.equal 'error in /a/b/c/foo.txt\n}\n^'

    it 'should append and use toString()', ->
      TestError = errorEx 'TestError', fileName: errorEx.append 'in %s'
      err = new TestError 'error'
      err.fileName = '/a/b/c/foo.txt'
      err.toString().should.equal 'TestError: error in /a/b/c/foo.txt'
      err.message.should.equal 'error in /a/b/c/foo.txt'

    it 'should append and use toString() on existing error', ->
      TestError = errorEx 'TestError', fileName: errorEx.append 'in %s'
      err = new Error 'error'
      TestError.call err
      err.fileName = '/a/b/c/foo.txt'
      err.toString().should.equal 'TestError: error in /a/b/c/foo.txt'
      err.message.should.equal 'error in /a/b/c/foo.txt'

  describe 'line', ->
    it 'should create a new line', ->
      TestError = errorEx 'TestError', fileName: errorEx.line 'in %s'
      err = new TestError 'error'
      err.fileName = '/a/b/c/foo.txt'
      testLine = err.stack.toString().split(/\r?\n/g)[1]
      testLine.should.equal '    in /a/b/c/foo.txt'
