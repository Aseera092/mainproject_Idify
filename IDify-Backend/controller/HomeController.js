const User = require("../model/User");
const HomeModel = require("../model/Home");

const addHomeID = async (req, res, next) => {
  try {
    // Validate email existence in the request body
    if (!req.body.email) {
      return res.status(400).json({
        status: false,
        message: "Email is required",
      });
    }

    // Check if the email already exists in the database
    const existingEmail = await HomeModel.findOne({ email: req.body.email });
    if (existingEmail) {
      return res.status(400).json({
        status: false,
        message: "Email already exists",
      });
    }

    // Create a new Home record and save it
    const newHome = new HomeModel(req.body);
    await newHome.save();

    res.status(201).json({
      status: true,
      message: "Registered successfully",
      data: newHome,
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

const getHomeID = async (req, res, next) => {
  try {
    const home = await HomeModel.find();
    res.status(200).json({
      status: true,
      data: home,
    });
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Error fetching data",
      error: error.message,
    });
  }
};
const updateHomeID = async (req, res, next) => {
  try {
    const home = await HomeModel.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!home) {
      return res.status(404).json({
        status: false,
        message: "user not found",
      });
    }
    res.status(200).json({
      status: true,
      message: "User updated successfully",
      data: home,
    });
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Error updating user data",
      error: error.message,
    });
  }
};

const deleteHomeID = async (req, res, next) => {
  try {
    const home = await HomeModel.findByIdAndDelete(req.params.id);

    if (!home) {
      return res.status(404).json({
        status: false,
        message: "Homeid not found",
      });
    }

    res.status(200).json({
      status: true,
      message: "homeid deleted successfully",
      data: HomeModel,
    });
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Error deleting user",
      error: error.message,
    });
  }
};

const homeLogin = async (req, res) => {
  const { homeId, password } = req.body;

  try {
    const home = await HomeModel.findOne({ homeId });

    if (!home) return res.status(404).json({ error: "HomeId not found" });

    // Check password
    const isMatch = await bcrypt.compare(password, homeId.password);
    if (!isMatch) return res.status(400).json({ error: "Invalid credentials" });

    // Generate JWT token
    const token = jwt.sign({ id: home._id }, "ADC120", { expiresIn: "1h" });

    res.status(200).json({ status: true, token, message: "Login successfulL" });
  } catch (err) {
    res.status(500).json({ status: false, error: "Login failed" });
    console.log(err);
  }
};

const searchHome = async (req, res) => {
    const homeId = req.params.id

    const home = await HomeModel.findOne({homeId})

    if (home) {
        res.status(200).json({ status: true, data:home, message: "Search Find" });
    }else{
        res.status(500).json({ status: false, message: "Not Found" });
    }

}

module.exports = {
  addHomeID,
  getHomeID,
  updateHomeID,
  deleteHomeID,
  homeLogin,
  searchHome
};
