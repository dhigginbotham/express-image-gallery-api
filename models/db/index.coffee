mongoose = require "mongoose"
conf = require "../../conf"
paginate = require('paginate')({
    mongoose: mongoose
});

mongoose.set "debug", true if conf.debug.mongo == true
# connection sharing thanks to [connection-sharing mongoose examples](https://github.com/LearnBoost/mongoose/tree/master/examples/express/connection-sharing)
global.db = mongoose.createConnection(conf.db.mongoUrl);

