const mongoose = require("mongoose");

const EventSchema = new mongoose.Schema(
  {
    Date: {
      type: Date,
      required: true,
    },
    Time: {
      type: String,
      required: true,
    },
    upload_event: { // Choose one of these.
      type: String,
      required: true,
    },
    NameofEvent: { // Consistent camelCase.
      type: String,
      required: true,
    },
    Description: {
      type: String,
      required: true,
    },
    Location: {
      type: String,
      required: true,
    },
    WardNoSelection: { // Consistent camelCase.
      type: Number,
      required: true,
    },
  },
  { timestamps: true } // Add timestamps.
);

const EventModel = mongoose.model("Event", EventSchema);

module.exports = EventModel;