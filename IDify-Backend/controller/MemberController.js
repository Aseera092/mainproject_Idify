const Member=require("../model/Member");
const bcrypt=require('bcryptjs');
const jwt=require('jsonwebtoken');
const AuthModel = require("../model/Auth");

const addMember=async(req,res,next)=>{
    try{
        const existingEmailMember = await Member.findOne({ email: req.body.email });
        if (existingEmailMember) {
            return res.status(400).json({
                status: false,
                message: "Email already exists"
            });
        }
        const existingMobileMember = await Member.findOne({ mobileNo: req.body.mobileNo });
        if (existingMobileMember) {
            return res.status(400).json({
                status: false,
                message: "Mobile Number already exists"
            });
        }
         const {password, ...Login} = req.body;

        const member = new Member(Login);
        console.log(Login);
        await member.save(); 
        const hashedPassword = await bcrypt.hash(password, 10);

        const memberLogin = new AuthModel({
            email: member.email,
            password: hashedPassword,
            role : "member"  
        })
        await memberLogin.save()

        res.status(201).json({
            status: true,
            message: "registered successfully",
            data: member 
        });
    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Error adding Member',
            error: error.message
        });
    }
}

const getMember=async(req,res,next)=>{
    try{
        const member=await Member.find();
        res.status(200).json({
            status:true,
            data:member
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

const updateMember = async (req, res, next) => {
    try {
        // Import the User model (adjust the path if needed)
        const User = require('../model/Member'); // Assuming your User model is in '../models/User.js'

        const user = await User.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!user) {
            return res.status(404).json({
                status: false,
                message: "Member not found"
            });
        }
        res.status(200).json({
            status: true,
            message: "Member updated successfully",
            data: user
        });
    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Error updating Member data',
            error: error.message
        });
    }
};
const deleteMember = async (req, res, next) => {
    try {
        const member = await Member.findByIdAndDelete(req.params.id);

        if (!member) {
            return res.status(404).json({
                status: false,
                message: 'Member not found'
            });
        }

        res.status(200).json({
            status: true,
            message: "Member deleted successfully",
            data: Member 
        });
    } catch (error) {
        res.status(500).json({
            status: false,
            message: 'Error deleting Member',
            error: error.message
        });
    }
};

module.exports = { addMember, getMember,updateMember, deleteMember};