// in your main.js or app.js file
const firebaseAdmin = require('firebase-admin');

const serviceAccount = require('./firebase-account.json');

firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccount),
  databaseURL: 'https://idfy-1e72a-default-rtdb.firebaseio.com/',
});

module.exports = {firebaseAdmin}