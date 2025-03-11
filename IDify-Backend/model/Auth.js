const mongoose=require("mongoose")
const AuthSchema=mongoose.Schema({
    email:
    {
        type:String,
        required:true
    },
    password:
    {
        type:String,
        required:true
    },
    role:
    {
        type:String,
        required:true
    }
})
var AuthModel=mongoose.model("auth",AuthSchema)
module.exports=AuthModel