mongoose = require 'mongoose'
counter_name = null
db = null

exports.loadAutoIncr = (database, options) ->
  options = options || {}
  counter_name = options.counterName || 'Counter'

  db = database

  schema = new mongoose.Schema
    field:
      type: String
      unique: true
    c:
      type: Number
      default: 0

  mongoose.model(counter_name, schema)

base_36 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

toBase36 = (input, output, cb) ->
  if input > 0
    remainder = input % 36
    input = Math.floor(input / 36)
    output = base_36[remainder] + output
    toBase36(input, output, cb)
  else
    cb(output)

exports.plugin = (schema, options) ->
  # Check for required options
  if (!options.modelName)
    throw new Error('Missing required parameter: modelName')

  model_name = options.modelName.toLowerCase()
  Counter = db.model counter_name

  schema.add
    url_id:
      type: String
      unique: true

  schema.pre 'save', (next) ->
    self = this
    if not self.url_id
      Counter.collection.findAndModify
        field: model_name, [], {$inc: {c: 1}}
          new: true
          upsert: true
        , (err, doc) =>
          count = doc.c
          return next(err) if err
          toBase36(count, "", (result) ->
            self.url_id = result
            next()
          )
    else
      next()