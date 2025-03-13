const Mongoose=require("mongoose")
<<<<<<< HEAD
const ComplaintSchema=Mongoose.schema({
=======
const ComplaintSchema=Mongoose.Schema({
>>>>>>> 74ec7a9 (ch)
    Date:
    {
        type:Date,
        required:true,
    },
    Complaint: {
        type: String,
        required: true,
    },
    category:{
        type:String,
        required:true,
    },
    Description:{
        type:String,
        required:true,
    },
    status:{
        type: String,
        enum: ['Pending', 'Forwarded','Verified','Cancelled'],
        default: 'Pending',
        required: true
    },
    reasonForCancel:{
        type:String,
    },
    userId:{
        type:Mongoose.Schema.Types.ObjectId,
        ref:"user",
    },
})
var ComplaintModel=Mongoose.model("Complaint",ComplaintSchema)
module.exports=ComplaintModel