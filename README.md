mongoose-autoincr-base36 - autoincrement base36 support for Mongoose
======================================================

This is a plugin for Mongoose to have an extra `url_id` number attribute that autoincrements.

The url_id is to be used for URL shortening, and is a base 36 number (alphanumeric).

This plugin will also create an extra table `counters` or named by you
to keep track of the counters across all tables.

### Installation
    npm install mongoose-autoincr-base36

### Using the plugin
First, you have to make sure that you initialize the plugin first.
    var mongoose = require("mongoose");
      , mongooseIncr = require("mongoose-autoincr-base36");

    var db = mongoose.createConnection("mongodb://localhost/test");
    mongooseIncr.loadAutoIncr(db); // Pass the Mongoose Connection

Now, when you define your schema, make sure you include the plugin:

    var UserSchema = new Schema({
        username: String
    });

    UserSchema.plugin(mongooseIncr.plugin, {modelName: 'User'});

## Public Methods
* `loadAutoIncr({counterName: name})`: `counterName` is optional, default
as `counters`, this is the table name that is created to store counters for different tables.

* `plugin({modelName: name})`: `modelName` is required, this is used to
store in the field of the counters table. Make sure that it is unique.

## Tests
To run tests:
    mocha test

### License
MIT License

---
### Author
[Chris Baik](https://github.com/chrisjbaik)

### Company
[Seelio](http://seelio.com)

### Forked from 
[Teng Siong Ong](https://github.com/siong1987/)