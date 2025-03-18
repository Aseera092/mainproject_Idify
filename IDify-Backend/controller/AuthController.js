const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Auth = require('../model/Auth');
const User=require("../model/User");
const Member=require("../model/Member");

// Register user
exports.registerUser = async (req, res) => {
  const { email, password, role } = req.body;

  // Check if the email already exists
  const userExists = await User.findOne({ email });
  if (userExists) {
    return res.status(400).json({ message: 'Email already registered' });
  }

  // Hash the password
  const hashedPassword = await bcrypt.hash(password, 10);

  // Create a new user
  const newUser = new Auth({
    email,
    password: hashedPassword,
    role,
  });

  try {
    await newUser.save();
    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error registering user', error });
  }
};

// exports.registerMember = async (req, res) => {
//   const { email, password, role } = req.body;

//   // Check if the email already exists
//   const memberExists = await Member.findOne({ email });
//   if (memberExists) {
//     return res.status(400).json({ message: 'Email already registered' });
//   }

//   // Hash the password
//   const hashedPassword = await bcrypt.hash(password, 10);

//   // Create a new user
//   const newMember = new Auth({
//     email,
//     password: hashedPassword,
//     role,
//   });

//   try {
//     await newMember.save();
//     res.status(201).json({ message: 'User registered successfully' });
//   } catch (error) {
//     res.status(500).json({ message: 'Error registering user', error });
//   }
// };

// Login user

// exports.loginUser = async (req, res) => {
//   try {
//     const { email, password } = req.body;

//     // Find the user in Auth model
//     const authUser = await Auth.findOne({ email });
//     if (!authUser) {
//       return res.status(400).json({ message: "Invalid email or password" });
//     }

//     // Compare the password
//     const isMatch = await bcrypt.compare(password, authUser.password);
//     if (!isMatch) {
//       return res.status(400).json({ message: "Invalid email or password" });
//     }

//     // Find additional user details from User model
//     const userDetails = await User.findOne({ email }).populate("homedetails");
//     if (!userDetails) {
//       return res.status(400).json({ message: " details not found" });
//     }

    
//     // Generate a JWT token
//     const token = jwt.sign(
//       { userId: authUser._id, role: authUser.role },
//       "your_jwt_secret_key",
//       { expiresIn: "1h" }
//     );

//     // Remove password before sending response
//     const { password: _, ...userWithoutPassword } = userDetails.toObject();
  
//     res.json({
//       message: "Login successful",
//       token,
//       role:authUser.role,
//       Details: userWithoutPassword, 
//       // Return full user details // Return member details if available
//     });
//   } catch (error) {
//     console.error("Error logging in:", error);
//     res.status(500).json({
//       message: "Server error",
//       error: error.message,
//     });
//   }
// };
exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    

    // Find the user in Auth model
    const authUser = await Auth.findOne({ email });
    if (!authUser) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    // Compare the password
    const isMatch = await bcrypt.compare(password, authUser.password);
    
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    // Check if the user is an admin
    if (authUser.role === "admin") {
      const adminToken = jwt.sign(
        { userId: authUser._id, role: "admin" },
        "your_jwt_secret_key",
        { expiresIn: "1h" }
      );

      return res.json({
        message: "Admin login successful",
        token: adminToken,
        role: "admin"
      });
    }

    if (authUser.role === "panchayath") {
      const adminToken = jwt.sign(
        { userId: authUser._id, role: "panchayath" },
        "your_jwt_secret_key",
        { expiresIn: "1h" }
      );

      return res.json({
        message: "Panchayath login successful",
        token: adminToken,
        role: "panchayath"
      });
    }

    // Fetch user details if available
    const userDetails = await User.findOne({ email }).populate("homedetails");

    // Fetch member details if available
    const memberDetails = await Member.findOne({ email });

    // Generate a JWT token
    const token = jwt.sign(
      { userId: authUser._id, role: authUser.role },
      "your_jwt_secret_key",
      { expiresIn: "1h" }
    );

    // Remove password before sending response
    const response = {
      message: "Login successful",
      token,
      role: authUser.role,
    };

    if (userDetails) {
      const { password: _, ...userWithoutPassword } = userDetails.toObject();
      response.userDetails = userWithoutPassword;
    }

    if (memberDetails) {
      const { password: _, ...memberWithoutPassword } = memberDetails.toObject();
      response.memberDetails = memberWithoutPassword;
    }

    res.json(response);
  } catch (error) {
    console.error("Error logging in:", error);
    res.status(500).json({
      message: "Server error",
      error: error.message,
    });
  }
};
