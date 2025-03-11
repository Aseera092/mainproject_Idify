var express = require('express');
const { addMember, getMember,updateMember,deleteMember} = require('../controller/MemberController');
var router = express.Router();

router.route('/')
    .get(getMember)
    .post(addMember)

router.route('/:id')
    .put(updateMember)
    .delete(deleteMember)

module.exports = router;