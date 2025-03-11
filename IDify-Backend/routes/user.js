var express = require('express');

const { getUser, addUser, updateUser, deleteUser } = require('../controller/userController');
var router = express.Router();


/* GET users listing. */
router.route('/')
    .get(getUser)
    .post(addUser)

router.route('/:id')
    .put(updateUser)
    .delete(deleteUser)

// router.post('/login', homeLogin);

module.exports = router;
