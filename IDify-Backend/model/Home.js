// const { default: mongoose } = require("mongoose");
const Mongoose=require("mongoose")
const HomeSchema=Mongoose.Schema({
    
   
    MobileNo:{
        type:Number,
        required:true,
        unique:true,
    },
    email:{
        type:String,
        required:true,
        unique:true,
    },
    homeId:{
        type:String,
        required:true,
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
  

});
const HomeModel=Mongoose.model("home",HomeSchema);
module.exports=HomeModel