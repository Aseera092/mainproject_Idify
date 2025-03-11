// middleware/auth.js

const jwt = require('jsonwebtoken')
const User = require('../model/Auth')

// Middleware to protect routes
exports.isAuthenticated = async (req, res, next) => {
  const { token } = req.cookies; // Or from Authorization header

  if (!token) {
    return res.status(401).json({ message: 'Please login first' });
  }

  try {
    // Verify token
    const decoded = jwt.verify(token, 'secretKey'); // Use the same secret key as in login
    req.user = decoded;
    next(); // Continue to the next middleware or route handler
  } catch (error) {
    console.error(error);
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
};
