import spotipy
from spotipy.oauth2 import SpotifyClientCredentials #To access authorised Spotify data

client_id = '7b91aced18c54c78897369f232476992'
client_secret = '6a7c1e8eb1f042f1ae20d5b594d4b147'
client_credentials_manager = SpotifyClientCredentials(client_id=client_id, client_secret=client_secret)
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager) #spotify object to access API

name = "Future" #chosen artist
result = sp.search(name) #search query
print(result['tracks']['items'][0]['artists'])

def albumSongs(uri):
    album = uri #assign album uri to a_name
spotify_albums[album] = {} #Creates dictionary for that specific album
#Create keys-values of empty lists inside nested dictionary for album
    spotify_albums[album]['album'] = [] #create empty list
    spotify_albums[album]['track_number'] = []
    spotify_albums[album]['id'] = []
    spotify_albums[album]['name'] = []
    spotify_albums[album]['uri'] = []
tracks = sp.album_tracks(album) #pull data on album tracks
for n in range(len(tracks['items'])): #for each song track
    spotify_albums[album]['album'].append(album_names[album_count]) #append album name tracked via album_count
    spotify_albums[album]['track_number'].append(tracks['items'][n]['track_number'])
    spotify_albums[album]['id'].append(tracks['items'][n]['id'])
    spotify_albums[album]['name'].append(tracks['items'][n]['name'])
    spotify_albums[album]['uri'].append(tracks['items'][n]['uri'])