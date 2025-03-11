const Mongoose=require("mongoose")
const MemberSchema=Mongoose.Schema({
    email:
    {
        type:String,
        required:true,
        unique:true,
    },
    name:
    {
        type:String,
        required:true
    },
    mobileNo:
    {
        type:Number,
        required:true,
        unique:true,
    },
     status: {
            type: String,
            enum: ['online', 'offline', 'maintenance'], 
            default: 'online',
            required: true
          },
        // "name":String,
        ward:{
            type:String,
            required:true,
        },
        "district":String,
        "country":String,
    })
    var MemberModel=Mongoose.model("member",MemberSchema)
    module.exports=MemberModel