var express = require("express");
const {
  addNotification,
  getNotifications,
} = require("../controller/NotificationController");

var router = express.Router();

/* GET users listing. */
router.route("/").get(getNotifications).post(addNotification);

// router.post('/login', homeLogin);

module.exports = router;
