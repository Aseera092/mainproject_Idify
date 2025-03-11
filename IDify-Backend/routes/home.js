var express = require('express');

const { getHomeID, addHomeID, updateHomeID, deleteHomeID,homeLogin} = require('../controller/HomeController');
var router = express.Router();


/* GET users listing. */
router.route('/')
    .get(getHomeID)
    .post(addHomeID)

router.route('/:id')
    .put(updateHomeID)
    .delete(deleteHomeID)

// router.post('/login', homeLogin);

module.exports = router;
