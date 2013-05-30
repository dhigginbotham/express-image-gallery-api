mongoose = require "mongoose"

paginate = require('paginate')({
    mongoose: mongoose
});
# debug setting for development
mongoose.set "debug", true if process.env.NODE_ENV == "development"

DB_CONNECTION_STRING = process.env.MGIVE_STRING || "mongodb://localhost/imgapi"
db = global.db = mongoose.createConnection(DB_CONNECTION_STRING);

db.on "error", console.error.bind console, "connection error:"
