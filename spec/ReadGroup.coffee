noflo = require 'noflo'

unless noflo.isBrowser()
  chai = require 'chai' unless chai
  ReadGroup = require '../components/ReadGroup.coffee'
else
  ReadGroup = require 'noflo-groups/components/ReadGroup.js'

describe 'ReadGroup component', ->
  c = null
  ins = null
  group = null

  beforeEach ->
    c = ReadGroup.getComponent()
    ins = noflo.internalSocket.createSocket()
    group = noflo.internalSocket.createSocket()
    c.inPorts.in.attach ins
    c.outPorts.group.attach group

  describe 'when instantiated', ->
    it 'should have input ports', ->
      chai.expect(c.inPorts.in).to.be.an 'object'

    it 'should have an output port', ->
      chai.expect(c.outPorts.group).to.be.an 'object'

  describe 'read groups', ->
    it 'test reading a group', (done) ->
      group.once 'data', (data) ->
        chai.expect(data).to.equal 'foo'
        done()
      ins.beginGroup 'foo'
      ins.send 'hello'

    it 'test reading a subgroup', (done) ->
      group.once 'data', (data) ->
        chai.expect(data).to.equal 'foo:bar'
        done()
      ins.beginGroup 'foo'
      ins.beginGroup 'bar'
      ins.send 'hello'
