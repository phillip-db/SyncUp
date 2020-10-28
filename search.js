const SpotifyWebApi = require('../');

const authorizationCode = 'BQCqrLWQm4sU0DoP6D0jpUnJqfkiUXaz-Vdid7jNfWm0qYouJQGuRD5DCLJeSI';

const spotifyApi = new SpotifyWebApi({
  clientId: 'insert id',
  clientSecret: 'insert client secret',
  redirectUri: 'http://localhost:8888/callback'
});

spotifyApi
  .authorizationCodeGrant(authorizationCode)
  .then(function(data) {
    console.log('Retrieved access token', data.body['access_token']);

    // Set the access token
    spotifyApi.setAccessToken(data.body['access_token']);

    // Use the access token to retrieve information about the user connected to it
    return spotifyApi.searchTracks('Captain');
  })
  .then(function(data) {
    // Print some information about the results
    console.log('I got ' + data.body.tracks.total + ' results!');

    // Go through the first page of results
    var firstPage = data.body.tracks.items;
    console.log('The tracks in the first page are (popularity in parentheses):');

    
    firstPage.forEach(function(track, index) {
      console.log(index + ': ' + track.name + ' (' + track.popularity + ')');
    });
  }).catch(function(err) {
    console.log('Something went wrong:', err.message);
  });