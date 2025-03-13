const NotificationModel = require("../model/Notification");
const { firebaseAdmin } = require("../util/firebase");

const addNotification = async (req, res, next) => {
  const { title, body, deviceID } = req.body;
  const message = {
    notification: {
      title,
      body,
    },
    topic: "IDIFY-News",
    // token: deviceID,
  };

  try {
    await firebaseAdmin.messaging().send(message);

    const notification = new NotificationModel(req.body);
    await notification.save();

    res.status(201).json({
      status: true,
      data: notification,
      message: "Notification Sent successfully",
    });
  } catch (error) {
    res.status(500).json({
      status: false,
      message: error.message,
      error: "Error notification senting",
    });
  }
};

const getNotifications = async (req, res, next) => {
  try {
    const notifications = await NotificationModel.find();
    
    res.status(200).json({
        status: true,
        data: notifications,
      });
  } catch (error) {
    res.status(500).json({
      status: false,
      message: error.message,
      error: "Error notification senting",
    });
  }
};

module.exports = { addNotification, getNotifications };
