// Generated by CoffeeScript 1.8.0
(function() {
  var db, expect, mongoose;

  expect = require('expect.js');

  mongoose = require('mongoose');

  db = mongoose.createConnection('mongodb://localhost/mongoose_autoincr_test');

  describe('autoincrement test', function() {
    return it('should create optional counterName model', function(done) {
      var Seq;
      require('../').loadAutoIncr(mongoose, {
        counterName: 'Seq'
      });
      Seq = db.model('Seq');
      return Seq.remove({}, function(err) {
        var count;
        count = new Seq({
          field: 'user'
        });
        return count.save(function(err) {
          expect(count.isNew).to.not.be.ok();
          return Seq.remove({}, done);
        });
      });
    });
  });

}).call(this);
