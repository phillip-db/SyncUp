var express = require('express');
var router = express.Router();

/* GET users listing. */

var rooms = {
  "gamerroom": { //room code
    "Giant Steps": 13, // song and votes, once played it gets deleted. Objects help so no song repeats
    "Spiral": 19
  },
  "cs196music": {
    "Call me maybe": 1, //inital value if called
    "Sure": 2
  }
}

// room songs next,played,votes

//general room queries
router.get('/', function(req, res, next) {
  res.render('vote/home', { "songdata": rooms })
});

router.post('/', function(req, res, next) {
  rooms[req.body.roomname] = {};
  res.redirect('back');
});

router.get('/:room', function(req, res, next) {
  res.send(rooms[req.params.room]);
})

// music specific queries

router.get('/:room/:songname/newsong', function(req, res, next) {
  rooms[req.params.room][req.params.songname] = 1;
  res.sendStatus(200);
});

router.get('/:room/:songname/upvote', function(req, res, next) {
  if (req.params.songname in rooms[req.params.room]) {
    rooms[req.params.room][req.params.songname]++;
    res.sendStatus(200);
  } else {
    res.sendStatus(400);
  }
});

router.get('/:room/:songname/downvote', function(req, res, next) {
  if (req.params.songname in rooms[req.params.room]) {
    rooms[req.params.room][req.params.songname]--;
    res.sendStatus(200);
  } else {
    res.sendStatus(400);
  }
});



module.exports = router;
