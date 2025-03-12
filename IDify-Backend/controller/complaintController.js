const ComplaintModel = require("../model/complaint");

const addComplaint = async (req, res, next) => {
  try {
    // Create a new Home record and save it
    const complaint = new ComplaintModel(req.body);
    await complaint.save();

    res.status(201).json({
      status: true,
      message: "Registered successfully",
      data: complaint,
    });
  } catch (error) {
    console.error(error);
    return res.status(501).json({
      status: false,
      message: "Error saving EmailId",
      error: error.message,
    });
  }
};

const getComplaints = async (req, res, next) => {
  try {
    const complaint = await ComplaintModel.find();
    res.status(200).json({
      status: true,
      data: complaint,
    });
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Error fetching data",
      error: error.message,
    });
  }
};
const getForwarded = async (req, res, next) => {
    try {
      const complaint = await ComplaintModel.find({status:'Forwarded'});
      res.status(200).json({
        status: true,
        data: complaint,
      });
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error fetching data",
        error: error.message,
      });
    }
};

const getComplaintsForMember = async (req, res, next) => {
    try {
    const wardNo = req.params.ward;
    const complaint = await ComplaintModel.find({ 
        userId: { $in: (await UserModel.find({ wardNo })).map(user => user._id) },
    });
      res.status(200).json({
        status: true,
        data: complaint,
      });
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error fetching data",
        error: error.message,
      });
    }
};

const getComplaintsByUser = async (req, res, next) => {
    try {
      const userId = req.params.user;
      const complaint = await ComplaintModel.find({userId});
      res.status(200).json({
        status: true,
        data: complaint,
      });
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error fetching data",
        error: error.message,
      });
    }
  };

const updateComplaint = async (req, res, next) => {
  try {
    const complaint = await ComplaintModel.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!complaint) {
      return res.status(404).json({
        status: false,
        message: "user not found",
      });
    }
    res.status(200).json({
      status: true,
      message: "User updated successfully",
      data: complaint,
    });
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Error updating user data",
      error: error.message,
    });
  }
};


const updateStatus = async (req, res, next) => {
    try {
      const complaint = await ComplaintModel.findByIdAndUpdate(req.params.id, req.body);
      if (!complaint) {
        return res.status(404).json({
          status: false,
          message: "user not found",
        });
      }
      res.status(200).json({
        status: true,
        message: "User updated successfully",
        data: complaint,
      });
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error updating user data",
        error: error.message,
      });
    }
  };

const deleteComplaint = async (req, res, next) => {
  try {
    const complaint = await ComplaintModel.findByIdAndDelete(req.params.id);

    if (!complaint) {
      return res.status(404).json({
        status: false,
        message: "Homeid not found",
      });
    }

    res.status(200).json({
      status: true,
      message: "homeid deleted successfully",
      data: complaint,
    });
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Error deleting user",
      error: error.message,
    });
  }
};


module.exports = {
getComplaintsForMember,
  addComplaint,
  getComplaints,
  getForwarded,
  updateComplaint,
  deleteComplaint,
  getComplaintsByUser,
  updateStatus
};
