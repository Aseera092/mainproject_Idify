const Express=require("express")
const Mongoose=require("mongoose")
const Cors=require("cors")
const bcrypt=require("bcryptjs")
const jwt=require("jsonwebtoken")

const user=require("./routes/user")
const home=require("./routes/home")
const member= require('./routes/member')
const auth=require("./routes/auth")
const bodyParser = require('body-parser');


let app=Express()
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true, parameterLimit: 50000 }));
app.use(Cors())
app.use('/user',user);
app.use('/home',home);
app.use('/member',member);
app.use('/auth', auth);

Mongoose.connect("mongodb+srv://aseera:aseera@cluster0.x0tifel.mongodb.net/IdifyDB")
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('Error connecting to MongoDB', err));

app.listen(8080,()=>{
    console.log("Server running")
})

module.exports=app;