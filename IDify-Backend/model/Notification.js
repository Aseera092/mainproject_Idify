const Mongoose = require("mongoose");
const Notificationschema = Mongoose.Schema({
//   Time: {
//     type: String,
//     required: true,
//   },
  Date: {
    type: Date,
    required: true,
  },
  title:{
    type: String,
    required: true,
  },
  body: {
    type: String,
    required: true,
  },
//   Homeid: {
//     type: Number,
//     required: true,
//   },
});

var NotificationModel = Mongoose.model("notification", Notificationschema);
module.exports = NotificationModel;
