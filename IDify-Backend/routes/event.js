const express = require("express");
const { addEvent, getEvent, deleteEvent, updateEvent } = require("../controller/eventController");

const router = express.Router();

router.post("/", addEvent); 
router.get("/", getEvent);  
router.route('/:id')
    .put(updateEvent)
    .delete(deleteEvent)

module.exports = router;
