const express = require('express');
const router = express.Router();
const authController = require('../controller/AuthController');

// Register route
router.post('/register', authController.registerUser);

// Login route
router.post('/login', authController.loginUser);

module.exports = router;
