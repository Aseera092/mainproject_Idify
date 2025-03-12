const mongoose=require("mongoose")
const EventSchema=mongoose.Mongoose.schema({
    Date:
    {
        type:Date,
        required:true,
    },
    Time:{
        type:Number,
        required:true,
    },
    uploadevent: {
        type: String,
        required: true,
    },
    NameofEvent:{
        type:String,
        required:true,
    },
    Description:{
        type:String,
        required:true,
    },
    status:{
        type: String,
        enum: ['Pending', 'Approved','Rejected','Collected'],
        default: 'Pending',
        required: true
    },
    rejectMessage:{
        type: String
    },
    panjayathid:{
        type:String,
        required:true,
    },
    WardNoSelection:{
        type:Number,
        required:true
    },

})
var EventModel=Mongoose.model("Event",EventSchema)
module.exports=EventModel