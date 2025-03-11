const Mongoose=require("mongoose")
const Notificationschema=Mongoose.Schema({
    Time:{
        type:Number,
        required:true,
    },
    Date:{
        type:Date,
        required:true,
    },
    Description:{
        type:String,
        required:true,
    },
    Name:{
        type:String,
        required:true,
    },
    Address:{
        type:String,
        required:true,
    },
    Homeid:{
        type:Number,
        required:true,
    },
})