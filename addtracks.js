const SpotifyWebApi = require('../');

const authorizationCode = '<insert authorization code>';

const spotifyApi = new SpotifyWebApi({
  clientId: '<client id>',
  clientSecret: '<client secret>',
  redirectUri: '<redirect URI>'
});

spotifyApi
  .authorizationCodeGrant(authorizationCode)
  .then(function(data) {
    spotifyApi.setAccessToken(data.body['access_token']);
    return spotifyApi.addTracksToPlaylist(
      'insert track',
      [
        'insert track',
        'insert track'
      ],
      {
        position: 10
      }
    );
  })
  .then(function(data) {
    console.log('Added tracks to the playlist!');
  })
  .catch(function(err) {
    console.log('Something went wrong:', err.message);
  });