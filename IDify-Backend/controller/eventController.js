const EventModel = require("../model/Event");
const { validationResult } = require("express-validator");

const addEvent = async (req, res, next) => {
  try {
    console.log("Received request to add event:", req.body);

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      console.log("Validation errors:", errors.array());
      return res.status(400).json({
        status: false,
        errors: errors.array(),
        message: "Validation failed: Please ensure all required fields are provided.",
      });
    }

    const event = new EventModel(req.body);
    await event.save();
    console.log("Event created successfully:", event);

    res.status(201).json({
      status: true,
      message: "Event registered successfully",
      data: event,
    });
  } catch (error) {
    console.error("Error saving event:", error);
    res.status(500).json({
      status: false,
      message: "Error saving event. Please try again later.",
      error: error.message,
    });
  }
};

const getEvent = async (req, res, next) => {
  try {
    const events = await EventModel.find();
    res.status(200).json({
      status: true,
      data: events,
    });
  } catch (error) {
    console.error("Error fetching events:", error); // Added console.error
    res.status(500).json({
      status: false,
      message: "Error fetching events. Please try again later.",
      error: error.message,
    });
  }
};
// const getEvent = async (req, res) => {
//     try {
//       const wardNo = req.params.wardNo;
//       const events = wardNo ? await EventModel.find({ wardNo }) : await EventModel.find();
//       res.status(200).json({
//         status: true,
//         data: events,
//       });
//     } catch (error) {
//       console.error("Error fetching events:", error);
//       res.status(500).json({
//         status: false,
//         message: "Error fetching events. Please try again later.",
//         error: error.message,
//       });
//     }
//   };
// export const getEvents = async (wardNo) => {
//     try {
//       const url = wardNo ? `${SERVICE_URL}event?wardNo=${wardNo}` : `${SERVICE_URL}event`;
  
//       const response = await fetch(url, {
//         method: "GET",
//         headers: { "Content-Type": "application/json" },
//       });
  
//       if (!response.ok) {
//         throw new Error(`Failed to fetch events: ${response.statusText}`);
//       }
  
//       return await response.json();
//     } catch (error) {
//       console.error("Error fetching events:", error);
//       throw error;
//     }
//   };
  


const updateEvent = async (req, res, next) => {
    try {
      console.log("Received request to update event:", req.params.id, req.body);
      
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        console.log("Validation errors:", errors.array());
        return res.status(400).json({
          status: false,
          errors: errors.array(),
          message: "Validation failed: Please ensure all required fields are provided.",
        });
      }
      
      const eventId = req.params.id;
      const updatedEvent = await EventModel.findByIdAndUpdate(
        eventId,
        req.body,
        { new: true, runValidators: true }
      );
      
      if (!updatedEvent) {
        return res.status(404).json({
          status: false,
          message: "Event not found",
        });
      }
      
      console.log("Event updated successfully:", updatedEvent);
      
      res.status(200).json({
        status: true,
        message: "Event updated successfully",
        data: updatedEvent,
      });
    } catch (error) {
      console.error("Error updating event:", error);
      res.status(500).json({
        status: false,
        message: "Error updating event. Please try again later.",
        error: error.message,
      });
    }
  };
  
  const deleteEvent = async (req, res, next) => {
    try {
      console.log("Received request to delete event:", req.params.id);
      
      const eventId = req.params.id;
      const deletedEvent = await EventModel.findByIdAndDelete(eventId);
      
      if (!deletedEvent) {
        return res.status(404).json({
          status: false,
          message: "Event not found",
        });
      }
      
      console.log("Event deleted successfully:", deletedEvent);
      
      res.status(200).json({
        status: true,
        message: "Event deleted successfully",
        data: deletedEvent,
      });
    } catch (error) {
      console.error("Error deleting event:", error);
      res.status(500).json({
        status: false,
        message: "Error deleting event. Please try again later.",
        error: error.message,
      });
    }
  };
  

module.exports = { addEvent, getEvent,updateEvent,deleteEvent };