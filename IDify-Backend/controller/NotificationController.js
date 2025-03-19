const HomeModel = require("../model/Home");
const NotificationModel = require("../model/Notification");
const { firebaseAdmin } = require("../util/firebase");

const addNotification = async (req, res, next) => {
  const { title, body, homeId, wardNo } = req.body;
  let message = {};

  if (homeId) {
    message = {
      notification: {
        title,
        body,
      },
      topic: homeId,
    };
  } else if (wardNo) {
    message = {
      notification: {
        title,
        body,
      },
      topic: `ward_${wardNo}`,
    };
  } else {
    message = {
      notification: {
        title,
        body,
      },
      topic: "global",
    };
  }

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
    const notifications = await NotificationModel.find().sort({ createdAt: -1 });;

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

const getNotificationsbyHome = async (req, res, next) => {
  const homeId = req.params.homeId;

  try {
    const home = await HomeModel.findOne({ homeId });
    console.log(home);
    
    const notifications = await NotificationModel.find({
      $or: [
      { homeId: homeId },
      { homeId: { $exists: false } },
      { wardNo: home.wardNo },
      ],
    }).sort({ createdAt: -1 });

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

module.exports = { addNotification, getNotifications,getNotificationsbyHome };
