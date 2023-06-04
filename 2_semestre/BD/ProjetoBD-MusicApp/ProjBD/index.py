from flask import Flask, render_template, request, session, redirect,url_for

import pypyodbc as  odbc
from datetime import datetime
import re

DRIVER_NAME='SQL Server'
SERVER_NAME='mednat.ieeta.pt\SQLSERVER,8101'
DATABASE_NAME='p9g11'

session={}
session['Autenticated']=False
# DATABASE CONNECTION
connection_string = f"""
    Driver={{{DRIVER_NAME}}};
    Server={SERVER_NAME};
    Database={DATABASE_NAME};
    Trust_Connection=yes;
    uid=p9g11;
    pwd=12345;
    """ 
conn= odbc.connect(connection_string)
print(conn)
cursor = conn.cursor()

# Create the application instance
app = Flask(__name__)

@app.route("/", methods=["POST", "GET"]) 
def index():
    if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']
            if validate_user(username, password):
                session["Autenticated"]=True
                session["Name"]=username
                cursor.execute("SELECT dbo.GetUserByIDAndPassword(?, ?);", (username, password))

                id = cursor.fetchall()
                session["id"]=id[0][0]

                return redirect(url_for("profileArtist"))
            else:
                session['Autenticated']=False
                error = 'Invalid username or password'
                return redirect(url_for("index",error=error))
    else:
        return render_template('Login.html')
    
def validate_user(username, password):
    cursor.execute('SELECT * FROM users WHERE username = ? AND password = ?', (username, password))
    # Fetch all the rows
    rows = cursor.fetchall()
    if len(rows) == 1:
        return True

        

@app.route("/Register", methods=["POST", "GET"])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        photo = request.form['photo']
        photo= "../static/img/"+photo+".jpg"
        birthdate = request.form['birthdate']

        #Type of artist
        isArtist = True if request.form.get('artist', False) else False
        isPodcaster = True if request.form.get('podcaster', False) else False

        if not validate_user(username, password):
            if isArtist and isPodcaster:
                cursor.execute("{CALL  AddUserAndRole(?, ?, ?, ?, ?, ?)}", (username, password, email, birthdate, photo, "artist_podcaster"))
            elif isArtist:
                cursor.execute("{CALL  AddUserAndRole(?, ?, ?, ?, ?, ?)}", (username, password, email, birthdate, photo, "artist"))
            elif isPodcaster:
                cursor.execute("{CALL  AddUserAndRole(?, ?, ?, ?, ?, ?)}", (username, password, email, birthdate, photo, "podcaster"))
            else:
                cursor.execute("{CALL  AddUserAndRole(?, ?, ?, ?, ?, ?)}", (username, password, email, birthdate, photo, "user"))
            conn.commit()
            return redirect(url_for("index"))
        else:
            error = 'Invalid parameters'
            return redirect(url_for("register",error=error))
    else:
        return render_template('Register.html')
    

@app.route("/Songs", methods=["POST", "GET"])
def songs():
    
    id = session["id"]
    
    if request.method == 'POST' and 'form_type' in request.form:
        form_type = request.form['form_type']
        #favorite tracks
        if form_type == "musicasFav":
            musica = request.form["musicaFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoriteSong(?, ?)}",(id, musica))

        elif form_type == "musicasUnFav":
            musica = request.form["musicaUnFav"]
            cursor.execute("{CALL deleteFavoriteSong(?, ?)}",(id, musica))

        conn.commit()

    #Gets the favorite tracks of the artist
    cursor.execute("Select track_id from FavoriteSongs where user_id = ?;",(id,))
    FavTracks = [track[0] for track in cursor.fetchall()]
 
    if request.method == 'POST' and 'form_type' not in request.form:
        search = request.form['search']
        cursor.execute("SELECT * FROM dbo.SearchByCategory(?, ?);", ("songs", search))
    else:
        cursor.execute("SELECT * FROM dbo.SearchByCategory(?, ?);", ("songs", ""))
    
    tracks = cursor.fetchall()
    return render_template('Songs.html', tracks=tracks, FavoriteTracks = FavTracks)

@app.route("/Playlists", methods=["POST", "GET"])
def playlist():
    id = session["id"]

    if request.method == 'POST' and 'form_type' in request.form:
        form_type = request.form['form_type']
        if form_type == "musicasFav":
            musica = request.form["musicaFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoriteSong(?, ?)}",(id, musica))

        elif form_type == "musicasUnFav":
            musica = request.form["musicaUnFav"]
            cursor.execute("{CALL deleteFavoriteSong(?, ?)}",(id, musica))

        #favorite playlist
        elif form_type == "playlistsFav":
            playlist= request.form["playlistFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoriteAlbum(?, ?)}",(id, playlist))

        elif form_type == "playlistsUnFav":
            playlist = request.form["playlistUnFav"]
            cursor.execute("{CALL deleteFavoritePlaylist(?, ?)}",(id, playlist))
        
        conn.commit()
    
    #Gets the favorite tracks of the artist
    cursor.execute("Select track_id from FavoriteSongs where user_id = ?",(id,))
    FavTracks = [track[0] for track in cursor.fetchall()]

    #Gets favorite playlists of the artist
    cursor.execute("Select playlist_id from FavoritePlaylist where user_id = ?",(id,))
    FavPlaylists = [playlist[0] for playlist in cursor.fetchall()]


    if request.method == 'POST'and 'form_type' not in request.form:
        search = request.form['search']
        cursor.execute("SELECT * FROM dbo.SearchByCategory(?, ?);", ("playlists", search))
    else:
        cursor.execute("SELECT * FROM dbo.SearchByCategory(?, ?);", ("playlists", ""))
    playlists = cursor.fetchall()
    playlistTrack = []
    #Get the tracks ID of the playlist
    for playlist in playlists:
        tracks = []
        cursor.execute("SELECT * FROM dbo.GetTracksByCriteria(?, ?);", ("playlists", playlist[0]))
        tracks = cursor.fetchall()
        #Append playlist to respective list of tracks
        playlistTrack.append((playlist,tracks))
    return render_template('Playlists.html', playlists=playlistTrack , FavoriteTracks = FavTracks, FavoritePlaylists = FavPlaylists)

@app.route("/Albums", methods=["POST", "GET"]) 
def albums():
    id = session["id"]

    #favorite albums
    if request.method == 'POST' and 'form_type' in request.form:
        form_type = request.form['form_type']
        
        if form_type == "albumsFav":
            album = request.form["albumFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoriteAlbum(?, ?)}",(id, album))

        elif form_type == "albumsUnFav":
            album = request.form["albumUnFav"]
            cursor.execute("{CALL deleteFavoriteAlbum(?, ?)}",(id, album))
            
        elif form_type == "musicasFav":
            musica = request.form["musicaFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoriteSong(?, ?)}",(id, musica))

        elif form_type == "musicasUnFav":
            musica = request.form["musicaUnFav"]
            cursor.execute("{CALL deleteFavoriteSong(?, ?)}",(id, musica))

        conn.commit()
    #Gets the favorite tracks of the artist
    cursor.execute("Select track_id from FavoriteSongs where user_id = ?;",(id,))
    FavTracks = [track[0] for track in cursor.fetchall()]

    #Gets favorite albums of the artist
    cursor.execute("Select album_id from FavoriteAlbum where user_id = ?",(id,))
    FavAlbums = [album[0] for album in cursor.fetchall()]

    if request.method == 'POST' and 'form_type' not in request.form:
        search = request.form['search']
        cursor.execute("SELECT * FROM dbo.SearchByCategory(?, ?);", ("albums", search))
    else:
        cursor.execute("SELECT * FROM albums")
    albums = cursor.fetchall()
    albumTrack = []
    #Get the tracks ID of the album
    for album in albums:
        tracks = []
        cursor.execute("SELECT * FROM dbo.GetTracksByCriteria(?, ?);", ("albums", album[0]))
        tracks = cursor.fetchall()
        #Append album to respective list of tracks
        albumTrack.append((album,tracks))
    return render_template('Albums.html', albums=albumTrack , FavoriteAlbums = FavAlbums , FavoriteTracks = FavTracks)



@app.route("/Podcasts", methods=["POST", "GET"])
def podcasts():
    id = session["id"]
    
    #favorite podcasts
    if request.method == 'POST' and 'form_type' in request.form:
        form_type = request.form['form_type']
        if form_type == "podcastsFav":
            podcast = request.form["podcastFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoritePodcast(?, ?)}",(id, podcast))
        
        elif form_type == "podcastsUnFav":
            podcast = request.form["podcastUnFav"]
            cursor.execute("{CALL deleteFavoritePodcast(?, ?)}",(id, podcast))  

        conn.commit()

    #Gets favorite podcasts of the user
    cursor.execute("Select podcast_id from FavoritePodcast where user_id = ?",(id,))
    FavPodcasts = [podcast[0] for podcast in cursor.fetchall()]

    if request.method == 'POST' and 'form_type' not in request.form:
        search = request.form['search']
        cursor.execute("SELECT * FROM dbo.SearchByCategory(?, ?);", ("podcasts", search))
    else:
        cursor.execute("SELECT * FROM dbo.SearchByCategory(?, ?);", ("podcasts", ""))
    
    podcasts = cursor.fetchall()
    podcastEpisode = []
    #Get the episodes ID of the podcast
    for podcast in podcasts:
        episodes = []
        cursor.execute("SELECT * FROM dbo.GetPodcastEpisodesByPodcastId(?);", (podcast[0],))
        
        episodes = cursor.fetchall()
        #Append podcast to respective list of episodes
        podcastEpisode.append((podcast,episodes))
    return render_template('Podcasts.html', podcasts=podcastEpisode , FavoritePodcasts = FavPodcasts)

@app.route("/Favorites", methods=["POST", "GET"])
def favorites():
    id = session["id"]
    search = ""
    if request.method == 'POST':
        search = request.form['search']
    
    tracks = cursor.execute("SELECT * FROM dbo.SearchFavoritesByCategory(?,?, ?);" , ("songs", search,id )).fetchall()
    podcasts = cursor.execute("SELECT * FROM dbo.SearchFavoritesByCategory(?,?, ?);" , ("podcasts", search, id)).fetchall()
    albums = cursor.execute("SELECT * FROM dbo.SearchFavoritesByCategory(?,?, ?);" , ("albums", search, id)).fetchall()
    playlists = cursor.execute("SELECT * FROM dbo.SearchFavoritesByCategory(?,?, ?);" , ("playlists", search, id)).fetchall()
        
    
    podcastEpisode = []
    #Get the episodes ID of the podcast
    for podcast in podcasts:
        episodes = []
        cursor.execute("SELECT * FROM dbo.GetPodcastEpisodesByPodcastId(?);", (podcast[0],))
        
        episodes = cursor.fetchall()
        #Append podcast to respective list of episodes
        podcastEpisode.append((podcast,episodes))

    albumTrack = []
    #Get the tracks ID of the album
    for album in albums:
        tracksAlbum = []
        cursor.execute("SELECT * FROM dbo.GetTracksByCriteria(?, ?);", ("albums", album[0]))
        tracksAlbum = cursor.fetchall()
        #Append album to respective list of tracks
        albumTrack.append((album,tracksAlbum))
    
    playlistTrack = []
    #Get the tracks ID of the playlist
    for playlist in playlists:
        tracksPlaylist = []
        cursor.execute("SELECT * FROM dbo.GetTracksByCriteria(?, ?);", ("playlists", playlist[0]))
        tracksPlaylist = cursor.fetchall()
        #Append playlist to respective list of tracks
        playlistTrack.append((playlist,tracksPlaylist))
    
    return render_template("Favorites.html", tracks=tracks, podcasts=podcastEpisode, albums=albumTrack, playlists=playlistTrack)



@app.route("/ProfileArtist", methods=["POST", "GET"])
def profileArtist():
    id = session["id"]

    #Most Popular
    cursor.execute("SELECT * FROM dbo.getTopPopularItems();")
    Popular = cursor.fetchall()

    #get all tracks
    cursor.execute("SELECT * FROM tracks;")
    Alltracks = cursor.fetchall()
    
    #Gets the tracks of the artist
    cursor.execute("SELECT * FROM dbo.GetArtistTracks(?);", (id,))
    Usertracks = cursor.fetchall()

    #Gets the favorite tracks of the artist
    cursor.execute("Select track_id from FavoriteSongs where user_id = ?",(id,))
    FavTracks = [track[0] for track in cursor.fetchall()]

    #Gets favorite albums of the artist
    cursor.execute("Select album_id from FavoriteAlbum where user_id = ?",(id,))
    FavAlbums = [album[0] for album in cursor.fetchall()]

    #Gets favorite playlists of the artist
    cursor.execute("Select playlist_id from FavoritePlaylist where user_id = ?",(id,))
    FavPlaylists = [playlist[0] for playlist in cursor.fetchall()]

    #Gets favorite podcasts of the user
    cursor.execute("Select podcast_id from FavoritePodcast where user_id = ?",(id,))
    FavPodcasts = [podcast[0] for podcast in cursor.fetchall()]

    #gets the user photo 
    cursor.execute("SELECT photourl FROM users WHERE id = ?;",(id,))
    photo = cursor.fetchall()[0][0]
    if photo == None:
        photo = "https://www.w3schools.com/howto/img_avatar.png"


    #Gets the genres of Tracks and albums
    cursor.execute("SELECT * FROM genres_tracks")
    genres = cursor.fetchall()

    #Gets the genres of Podcasts
    cursor.execute("SELECT * FROM genres_podcast")
    genresPodcasts = cursor.fetchall()

    #Gets type of user artist
    cursor.execute("SELECT * FROM artists WHERE id = ?",(id,))
    if( cursor.fetchall() == []):
        isArtist=False
    else:
        isArtist=True

    #Gets type of user podcaster
    cursor.execute("SELECT * FROM podcaster WHERE id = ?",(id,))
    if( cursor.fetchall() == []):
        isPodcaster=False
    else:
        isPodcaster=True

    #Name Of artist
    cursor.execute("SELECT username FROM users where id = ?",(id,))
    uname= cursor.fetchall()[0][0]
        
    #Gets the playlist of the user
    cursor.execute("SELECT * FROM playlists where user_id = ?",(id,))
    playlists = cursor.fetchall()
    playlistTrack = []
    #Get the tracks ID of the playlist
    for playlist in playlists:
        tracks = []
        cursor.execute("SELECT * FROM dbo.GetTracksByCriteria(?, ?);", ("playlists", playlist[0]))

        tracks = cursor.fetchall()
        #Append playlist to respective list of tracks
        playlistTrack.append((playlist,tracks))


    #Gets the albums of the artist
    cursor.execute("SELECT * FROM albums where artist_id = ?",(id,))
    albums = cursor.fetchall()
    albumTrack = []
    #Get the tracks ID of the album
    for album in albums:
        tracks = []
        cursor.execute("SELECT *FROM dbo.GetTracksByCriteria(?, ?);", ("albums", album[0]))
        
        tracks = cursor.fetchall()
        #Append album to respective list of tracks
        albumTrack.append((album,tracks))

    #Gets the podcasts of the podcaster
    cursor.execute("SELECT podcasts.id, podcasts.title, genres_podcast.name AS genre_name, podcasts.description, podcasts.cover_image_url, podcasts.podaster_id FROM podcasts JOIN genres_podcast ON podcasts.genre_id = genres_podcast.id WHERE podcasts.podaster_id = ?",(id,))
    podcasts = cursor.fetchall()
    podcastEpisode = []
    #Get the episodes ID of the podcast
    for podcast in podcasts:
        episodes = []
        cursor.execute("SELECT * FROM dbo.GetPodcastEpisodesByPodcastId(?);", (podcast[0],))
        
        episodes = cursor.fetchall()
        #Append podcast to respective list of episodes
        podcastEpisode.append((podcast,episodes))

    
    if request.method == 'POST':
        form_type = request.form['form_type']
        if form_type == "exit":
            cursor.execute("DELETE FROM users where id = ?;", (id,))
            conn.commit()
            return redirect(url_for("index"))
            
        #favorite tracks
        elif form_type == "musicasFav":
            musica = request.form["musicaFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoriteSong(?, ?)}",(id, musica))

        elif form_type == "musicasUnFav":
            musica = request.form["musicaUnFav"]
            cursor.execute("{CALL deleteFavoriteSong(?, ?)}",(id, musica))

        #favorite albums
        elif form_type == "albumsFav":
            album = request.form["albumFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoriteAlbum(?, ?)}",(id, album))

        elif form_type == "albumsUnFav":
            album = request.form["albumUnFav"]
            cursor.execute("{CALL deleteFavoriteAlbum(?, ?)}",(id, album))
        
        #favorite playlist
        elif form_type == "playlistsFav":
            playlist= request.form["playlistFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoriteAlbum(?, ?)}",(id, playlist))

        elif form_type == "playlistsUnFav":
            playlist = request.form["playlistUnFav"]
            cursor.execute("{CALL deleteFavoritePlaylist(?, ?)}",(id, playlist))

        elif form_type == "podcastsFav":
            podcast = request.form["podcastFav"]
            
            #insert into the favorite table
            cursor.execute("{CALL insertFavoritePodcast(?, ?)}",(id, podcast))
        
        elif form_type == "podcastsUnFav":
            podcast = request.form["podcastUnFav"]
            cursor.execute("{CALL deleteFavoritePodcast(?, ?)}",(id, podcast))    

        #adicinar um forms e meter em baixo
        elif form_type == "podcastAddEp":
                Title = request.form['Title']
                description = request.form['Description']
                podcast_id = request.form['podcastAddEp']
                cursor.execute("INSERT INTO podcast_episodes (title, description,duration ,release_date, podcast_id) VALUES (?,?, ?, ?, ?);",(Title,description,0 ,datetime.today().date(), podcast_id))


        #New Track and Album and playlist and podcast
        else:
            Title = request.form['Title']
            Genre = request.form['Genre']
            Photo = request.form['Photo']
            Photo= "../static/img/"+Photo+".jpg"
            print(Photo)
            if form_type == "album":
                
                music = request.form.getlist('track')
                cursor.execute("INSERT INTO albums (title, release_date ,artist_id, cover_image_url) VALUES (?, ?, ?, ?);",(Title,datetime.today().date(), id, Photo))
                
                cursor.execute("SELECT id FROM albums where title = ?;",(Title,))
                album_id = cursor.fetchall()[0][-1]
                for elem in music:
                    cursor.execute("INSERT INTO albums_tracks (track_id, album_id) VALUES (?, ?);",(elem, album_id))
               

            elif form_type == "playList":
                music = request.form.getlist('track')
                cursor.execute("INSERT INTO playlists (name, user_id, cover_image_url) VALUES (?, ?,? );",(Title, id, Photo))

                # Get the last inserted playlist ID using a SELECT statemen,t
                cursor.execute("SELECT id FROM playlists where name = ?;",(Title,))
                playlist_id = cursor.fetchall()[0][-1]
                for elem in music:
                    cursor.execute("INSERT INTO track_playlist (track_id, playlist_id) VALUES (?, ?);",(elem, playlist_id))
               

            elif form_type == "single":
                cursor.execute("INSERT INTO tracks (title, duration, release_date, genre_id, cover_image_url) VALUES (?, ?, ?, ?, ?);",(Title, 3, datetime.today().date(), Genre, photo))
            
                # Get the last inserted track ID using a SELECT statement
                cursor.execute("SELECT id FROM tracks where title = ?;",(Title,))
                track_id = cursor.fetchall()[0][-1]
                
                # Insert the track_artist
                cursor.execute("INSERT INTO track_artist (track_id, artist_id) VALUES (?, ?);",(track_id, id))
                
            elif form_type == "podcast":
                description = request.form['Description']
                cursor.execute("INSERT INTO podcasts (title, podaster_id, genre_id , cover_image_url, description) VALUES (?, ?, ?, ?, ?);",(Title, id, Genre, Photo, description))

                            


        conn.commit()
        return redirect(url_for("profileArtist"))
    
        
    else:
        return render_template('ProfileArtist.html',Alltracks=Alltracks,photo=photo ,
                               FavoriteTracks=FavTracks,FavoriteAlbums=FavAlbums, FavoritePlaylists=FavPlaylists ,FavoritePodcasts = FavPodcasts , 
                               tracks=Usertracks,genres=genres, genresPodcast=genresPodcasts,albums=albumTrack,
                               isArtist=isArtist, isPodcaster=isPodcaster,uname=uname,
                               playlists=playlistTrack, podcasts=podcastEpisode,
                               Popular=Popular)


app.debug = True
app.run(host="0.0.0.0", port=3000)