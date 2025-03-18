var express = require('express');

const { getUser, addUser, updateUser, deleteUser, getUserById ,registerUser,approveUser,rejectUser} = require('../controller/UserController');
var router = express.Router();


/* GET users listing. */
router.route('/')
    .get(getUser)
    .post(addUser)

router.route('/:id')
    .get(getUserById)
    .put(updateUser)
    .delete(deleteUser)

router.put('status/:id', approveUser); // Approve user
// router.put('/:id/reject', rejectUser); // Reject user

// router.post('/login', homeLogin);

module.exports = router;
