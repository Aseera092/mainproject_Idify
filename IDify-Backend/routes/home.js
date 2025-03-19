var express = require('express');

const { getHomeID, addHomeID, updateHomeID, deleteHomeID,homeLogin, searchHome} = require('../controller/HomeController');
var router = express.Router();


/* GET users listing. */
router.route('/')
    .get(getHomeID)
    .post(addHomeID)

router.route('/:id')
    .put(updateHomeID)
    .delete(deleteHomeID)

    router.route('/search/:id').get(searchHome)

// router.post('/login', homeLogin);

module.exports = router;
