const User=require("../model/User");
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { get } = require("mongoose");
const AuthModel = require("../model/Auth");
// const { homeLogin } = require("./HomeController");

const addUser=async(req,res,next)=>{
    console.log(req.body);
    
    try{
        const existingEmailUser = await User.findOne({ email: req.body.email });
        if (existingEmailUser) {
            return res.status(400).json({
                status: false,
                message: "Email already exists"
            });
        }
        const existingMobileUser = await User.findOne({ MobileNo: req.body.MobileNo });
        if (existingMobileUser) {
            return res.status(400).json({
                status: false,
                message: "Mobile Number already exists"
            });
        }
         const {password, ...homeLogin} = req.body;

        const user = new User(homeLogin);
        console.log(user);
        await user.save(); 
        const hashedPassword = await bcrypt.hash(password, 10);

        const userLogins = new AuthModel({
            email: user.email,
            password: hashedPassword,
            role : "user"  
        })
        await userLogins.save()

        res.status(201).json({
            status: true,
            data:user,
            message: "registered successfully", 
        });
    } catch (error) {
        res.status(500).json({
            status: false,
            message: error.message ,
            error: 'Error adding User'
        });
    }
}
const getUser=async(req,res,next)=>{
    try{
        const user=await User.find();
        res.status(200).json({
            status:true,
            data:user
        });
    }
    catch(error){
        res.status(500).json({
            status:false,
            message:'Error fetching data',
            error:error.message
        });
    }
};

const getUserById=async(req,res,next)=>{
    try{
        id = req.params.id
        const user=await User.findById(id);
        res.status(200).json({
            status:true,
            data:user
        });
    }
    catch(error){
        res.status(500).json({
            status:false,
            message:'Error fetching data',
            error:error.message
        });
    }
};

const updateUser=async(req,res,next)=>{
    try{
        const user=await User.findByIdAndUpdate(req.params.id,req.body,{new:true});
        if(!user){
            return res.status(404).json({
                status:false,
                message:"user not found"
            });
        }
        res.status(200).json({
            status: true,
            message: "User updated successfully",
            data: user 
        });
    }
 catch (error) {
    res.status(500).json({
        status: false,
        message: 'Error updating user data',
        error: error.message
    });
}
};

const deleteUser = async (req, res, next) => {
    try {
        const user = await User.findByIdAndDelete(req.params.id);

        if (!user) {
            return res.status(404).json({
                status: false,
                message: 'User not found'
            });
        }

        res.status(200).json({
            status: true,
            message: "User deleted successfully",
            data: User 
        });
    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Error deleting user',
            error: error.message
        });
    }
};

module.exports = { addUser,getUser,getUserById,updateUser, deleteUser};