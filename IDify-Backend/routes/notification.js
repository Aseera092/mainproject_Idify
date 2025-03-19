var express = require("express");
const {
  addNotification,
  getNotifications,
  getNotificationsbyHome,
} = require("../controller/NotificationController");

var router = express.Router();

/* GET users listing. */
router.route("/").get(getNotifications).post(addNotification);

router.route("/:homeId").get(getNotificationsbyHome)


// router.post('/login', homeLogin);

module.exports = router;
