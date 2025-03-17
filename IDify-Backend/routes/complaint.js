
var express = require('express');
const { getComplaints, addComplaint, getComplaintsByUser, updateComplaint, deleteComplaint, updateStatus, getComplaintsForMember, getComplaintsForPanchayat } = require('../controller/complaintController');

var router = express.Router();


/* GET users listing. */
router.route('/')
    .get(getComplaints)
    .post(addComplaint)

router.route('/get-forwarded').get(getComplaints)
router.route('/get-member/:ward').get(getComplaintsForMember)
router.route('/get-panchayath').get(getComplaintsForPanchayat)

router.route('/:user')
    .get(getComplaintsByUser)

router.route('/:id')
    .put(updateComplaint)
    .delete(deleteComplaint)

    router.route('/status/:id')
    .put(updateStatus)
// router.post('/login', homeLogin);

module.exports = router;
