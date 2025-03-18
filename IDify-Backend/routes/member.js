var express = require('express');
const { addMember, getMember,updateMember,deleteMember, getMemberById} = require('../controller/MemberController');
var router = express.Router();

router.route('/')
    .get(getMember)
    .post(addMember)
    // .get(getMemberById)

router.route('/:id')
    .get(getMemberById)
    .put(updateMember)
    .delete(deleteMember)

module.exports = router;