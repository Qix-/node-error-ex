should = require 'should'
errorEx = require '../'

Error.stackTraceLimit = Infinity

it 'should create a new error type', ->
  TestError = errorEx 'TestError'
  err = new TestError('herp derp')
  err.name.should.equal 'TestError'
  testLine = err.stack.toString().split(/[\r\n]+/g)[0]
  testLine.should.equal 'TestError: herp derp'

it 'should add a custom property line', ->
  TestError = errorEx 'TestError', foo: -> 'bar'
  err = new TestError('herp derp')
  testLine = err.stack.toString().split(/[\r\n]+/g)[1]
  testLine.should.equal '    bar'

it 'should allow properties', ->
  TestError = errorEx 'TestError', foo: (v)-> "foo #{v}" if v
  err = new TestError('herp derp')
  testLine = err.stack.toString().split(/[\r\n]+/g)[1]
  testLine.substr(0, 3).should.not.equal 'foo'
  err.foo = 'bar'
  testLine = err.stack.toString().split(/[\r\n]+/g)[1]
  testLine.should.equal '    foo bar'

it 'should allow direct editing of the stack', ->
  TestError = errorEx 'TestError', foo: (v, stack)-> stack[0] += " #{v}" if v
  err = new TestError('herp derp')
  err.foo = 'magerp'
  testLine = err.stack.toString().split(/[\r\n]+/g)[0]
  testLine.should.equal 'TestError: herp derp magerp'

describe 'helpers', ->
  it 'should append to the error string', ->
    TestError = errorEx 'TestError', fileName: errorEx.append 'in %s'
    err = new TestError 'error'
    err.fileName = '/a/b/c/foo.txt'
    testLine = err.stack.toString().split(/[\r\n]+/g)[0]
    testLine.should.equal 'TestError: error in /a/b/c/foo.txt'

  it 'should create a new line', ->
    TestError = errorEx 'TestError', fileName: errorEx.line 'in %s'
    err = new TestError 'error'
    err.fileName = '/a/b/c/foo.txt'
    testLine = err.stack.toString().split(/[\r\n]+/g)[1]
    testLine.should.equal '    in /a/b/c/foo.txt'
