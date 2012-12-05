expect = require 'expect.js'
mongoose = require 'mongoose'

db = mongoose.createConnection 'mongodb://localhost/mongoose_autoincr_test'

describe 'Counter model test', ->
  autoIncr = require('../')
  autoIncr.loadAutoIncr(db)

  userSchema = new mongoose.Schema
    username: String

  userSchema.plugin autoIncr.plugin,
    modelName: 'User'
  mongoose.model('User', userSchema)

  cardSchema = new mongoose.Schema
    name: String

  cardSchema.plugin autoIncr.plugin,
    modelName: 'Card'
  mongoose.model('Card', cardSchema)

  User = null
  Counter = null
  Card = null

  before ->
    User = db.model('User')
    Card = db.model('Card')
    Counter = db.model('Counter')

  it 'should create user field on Counter db', (done) ->
    Counter.remove {}, (err) ->
      card = new Card
        name: 'john'
      card.save (err) ->
        Counter.findOne
          field: 'card'
          , (err, doc) ->
            expect(doc.c).to.be 1
            Card.remove {}, done

  it 'test autoincrement', (done) ->
    User.remove {}, (err) ->
      answers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
                 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
                 'x', 'y', 'z', '10', '11']
      usernames = []
      for i in [0..36]
        usernames.push('chris' + i)
      checkSequence = (next) ->
        if usernames.length is 0
          return next()
        username = usernames.pop()
        user = new User
          username: username
        user.save (err) ->
          User.findOne
            username: username
            , (err, doc) ->
              answer = answers.shift()
              expect(doc.url_id).to.be(answer)
              checkSequence(next)
      checkSequence ->
        User.remove {}, done
