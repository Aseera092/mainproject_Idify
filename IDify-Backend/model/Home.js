// const { default: mongoose } = require("mongoose");
const Mongoose=require("mongoose")
const HomeSchema=Mongoose.Schema({
    
    // users:{
    //     type: mongoose.Schema.Types.ObjectId,
    //     ref:'user',
    //     required: true
    // },
    // relation:{
    //     type:String,
    //     required:true,
    // },
    // number_of_members:{
    //     type:Number,
    //     required:true,
    // },
    // job:{
        // type:String,
        // required:true
    // },
    name:{
        type:String,
        required:true,
    },
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
    Address:{
        type:String,
        required:true,
    },
    wardNo:{
        type:Number,
        required:true,
    },
  

});
const HomeModel=Mongoose.model("home",HomeSchema);
module.exports=HomeModel