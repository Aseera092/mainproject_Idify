const { Timestamp } = require("firebase-admin/firestore");
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
  homeId: {
    type: String,
  },
  wardNo: {
    type: String,
  },
}, { timestamps: true});

var NotificationModel = Mongoose.model("notification", Notificationschema);
module.exports = NotificationModel;
