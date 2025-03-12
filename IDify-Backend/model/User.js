const Mongoose=require("mongoose")
const UserSchema=Mongoose.Schema({
  
    firstName:{
        type:String,
        required:true,
    },
    lastName:{
        type:String,
        required:true,
    },
    Address:{
        type:String,
        required:true,
    },
    email:{
        type:String,
        required:true,
        unique:true,
    },
    MobileNo:{
        type:String,
        required:true,
        unique:true,
    },
    dob:{
        type:Date,
        required:true,
    },
    alternateMobileNo: {
        type: String,
    },
    pincode:{
        type:String,
        required:true,
    },
    longitude:{
        type:String,
        required:true,
    },
    latitude:{
        type:String,
        required:true,
    },
    wardNo:{
        type:String,
        required:true,
    },
    district:{
        type:String,
        required:true,
    },
    country:{
        type:String,
        required:true,
    },
    rationCardNo:{
        type:String,
        required:true,
    },
    upload_rationcard:{
        type:String,
        required:true,
    },
    status: {
        type: String,
        enum: ['online', 'offline'],
        default: 'online',
        required: true
    },
    homedetails:{
        type:Mongoose.Schema.Types.ObjectId,
        ref:"home",
    },
})

var UserModel=Mongoose.model("user",UserSchema)
module.exports=UserModel
