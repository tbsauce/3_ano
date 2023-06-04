use p9g11;
go

-------------------------------------------------Inserts--------------------------------

-- Insert into genres_podcast table
INSERT INTO genres_podcast(name) VALUES('Comedy'), ('Education'), ('Science'), ('History'), ('Music');

-- Insert into genres_tracks table
INSERT INTO genres_tracks(name) VALUES('Rock'), ('Pop'), ('Indie'), ('Jazz'), ('Hip-Hop');

-- Insert into users table and then into artists and podcaster tables
EXEC AddUserAndRole 'John Doe', '123', 'john.doe@email.com', '1990-05-01', ' ../static/img/menina.jpg', 'artist';
EXEC AddUserAndRole 'Jane Smith', '123', 'jane.smith@email.com', '1992-07-15', ' ../static/img/sample.jpg', 'podcaster';
EXEC AddUserAndRole 'Richard Roe', '123', 'richard.roe@email.com', '1985-02-10', ' ../static/img/Teste.png', 'artist_podcaster';

-- Insert into tracks table
INSERT INTO tracks(title, duration, release_date, genre_id, cover_image_url) 
VALUES  ('Track0', 300, '2023-01-01', 1, ' ../static/img/Teste.png'), 
        ('Track1', 250, '2023-01-02', 2, ' ../static/img/sample.jpg'), 
        ('Track2', 250, '2023-01-02', 2, ' ../static/img/sample.jpg'),
        ('Track3', 200, '2023-02-01', 3, '../static/img/menina.jpg'), 
        ('Track4', 240, '2023-02-05', 4, '../static/img/Teste.png'), 
        ('Track5', 310, '2023-02-10', 5, '../static/img/menina.jpg');


-- Insert into track_artist table
INSERT INTO track_artist(track_id, artist_id) 
VALUES(1, 1), (2, 3), (3, 1), (4, 3), (5, 1), (6, 3);

-- Insert into albums table
INSERT INTO albums(title, release_date, artist_id, cover_image_url) 
VALUES  ('Album1', '2023-01-01', 1, ' ../static/img/menina.jpg'), 
        ('Album2', '2023-01-02', 3, ' ../static/img/Teste.png');

-- Insert into albums_tracks table
INSERT INTO albums_tracks(track_id, album_id) 
VALUES(1, 1), (3, 1), (5, 1), (4, 2), (1, 2), (2, 2);

-- Insert into podcasts table
INSERT INTO podcasts(title, genre_id, description, cover_image_url, podaster_id) 
VALUES('Podcast1', 1, 'Description for Podcast1', ' ../static/img/sample.jpg', 2), ('Podcast2', 2, 'Description for Podcast2', ' ../static/img/Teste.png', 3);

-- Insert into podcast_episodes table
INSERT INTO podcast_episodes(title, description, duration, release_date, podcast_id) 
VALUES  ('Episode1', 'Description for Episode1', 60, '2023-02-01', 1), 
        ('Episode2', 'Description for Episode2', 45, '2023-02-02', 2),
        ('Episode3', 'Description for Episode3', 55, '2023-03-01', 1), 
        ('Episode4', 'Description for Episode4', 65, '2023-03-05', 2), 
        ('Episode5', 'Description for Episode5', 60, '2023-03-10', 1), 
        ('Episode6', 'Description for Episode6', 70, '2023-03-15', 2);

-- Insert into playlists table
INSERT INTO playlists(name, user_id, cover_image_url) 
VALUES('Playlist1', 1, ' ../static/img/menina.jpg'), ('Playlist2', 3, ' ../static/img/sample.jpg');

-- Insert into track_playlist table
INSERT INTO track_playlist(track_id, playlist_id) VALUES(1, 1), (2, 2), (3, 2), (4, 1), (5, 2), (2, 1);

-- Insert into favorite tables
INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(1, 1);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(3, 1);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(2, 1);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(2, 4);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(2, 5);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(2, 3);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(3, 3);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(1, 2);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(2, 2);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(1, 1);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(3, 2);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(1, 3);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(1, 4);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(1, 5);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(3, 4);

INSERT INTO FavoriteSongs(user_id, track_id)
VALUES(3, 5);

INSERT INTO FavoriteAlbum(user_id, album_id)
VALUES(1, 1);

INSERT INTO FavoriteAlbum(user_id, album_id)
VALUES(3, 2);

INSERT INTO FavoriteAlbum(user_id, album_id)
VALUES(2, 1);

INSERT INTO FavoriteAlbum(user_id, album_id)
VALUES(2, 2);

INSERT INTO FavoriteAlbum(user_id, album_id)
VALUES(2, 1);

INSERT INTO FavoriteAlbum(user_id, album_id)
VALUES(3, 1);

INSERT INTO FavoritePodcast(user_id, podcast_id)
VALUES(1, 1);

INSERT INTO FavoritePodcast(user_id, podcast_id)
VALUES(3, 1);

INSERT INTO FavoritePodcast(user_id, podcast_id)
VALUES(1, 2);

INSERT INTO FavoritePodcast(user_id, podcast_id)
VALUES(2, 2);

INSERT INTO FavoritePodcast(user_id, podcast_id)
VALUES(2, 1);

INSERT INTO FavoritePlaylist(user_id, playlist_id)
VALUES(1, 1);

INSERT INTO FavoritePlaylist(user_id, playlist_id)
VALUES(3, 2);

INSERT INTO FavoritePlaylist(user_id, playlist_id)
VALUES(1, 2);

INSERT INTO FavoritePlaylist(user_id, playlist_id)
VALUES(2, 2);

INSERT INTO FavoritePlaylist(user_id, playlist_id)
VALUES(2, 1);
