expect = require 'expect.js'
mongoose = require 'mongoose'
db = mongoose.createConnection 'mongodb://localhost/mongoose_autoincr_test'

describe 'autoincrement test', ->
  it 'should create optional counterName model', (done) ->
    require('../').loadAutoIncr mongoose,
      counterName: 'Seq'

    Seq = db.model 'Seq'
    Seq.remove {}, (err) ->
      count = new Seq
        field: 'user'
      count.save (err) ->
        expect(count.isNew).to.not.be.ok()
        Seq.remove {}, done
