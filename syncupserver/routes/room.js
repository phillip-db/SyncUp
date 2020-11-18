var express = require('express');
var router = express.Router();

/* GET users listing. */

var rooms = {
  "gamerroom": { //room code
    "Giant Steps": 13, // song and votes, once played it gets deleted. Objects help so no song repeats
    "Spiral": 19
  },
}

// room songs next,played,votes

//general room queries
router.get('/', function(req, res, next) {
  res.render('vote/home', { "songdata": rooms })
});

router.get('/all', function(req, res, next) {
  res.send({"rooms": rooms});
})

router.get('/modify', function(req, res, next) {
  let queryData = req.query;
  if (queryData.addsong != '' ) {
    rooms[queryData.roomname][queryData.addsong] = 1;
  }
  if (queryData.upvotesong != '') {
    rooms[queryData.roomname][queryData.upvotesong] += 1;
  }
  if (queryData.downvotesong != '') {
    rooms[queryData.roomname][queryData.downvotesong] -= 1;
  }
  if (queryData.removesong != '') {
    delete rooms[queryData.roomname][queryData.removesong];
  }
  res.send(res.send(rooms[req.query.roomname]));
});

module.exports = router;
