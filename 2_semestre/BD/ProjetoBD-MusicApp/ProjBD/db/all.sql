use p9g11;
go 
-- Drop the track_playlist association table
DROP TABLE IF EXISTS FavoriteSongs;
go
-- Drop the track_playlist association table
DROP TABLE IF EXISTS FavoriteAlbum;
go
-- Drop the track_playlist association table
DROP TABLE IF EXISTS FavoriteArtist;
go

-- Drop the track_playlist association table
DROP TABLE IF EXISTS FavoritePlaylist;
go
-- Drop the track_playlist association table
DROP TABLE IF EXISTS FavoritePodcast;
go

-- Drop the track_playlist association table
DROP TABLE IF EXISTS track_playlist;
go

-- Drop the track_playlist association table
DROP TABLE IF EXISTS track_artist;
go

-- Drop the playlists table
DROP TABLE IF EXISTS playlists;
go
-- Drop the podcast_episodes table
DROP TABLE IF EXISTS podcast_episodes;
go
-- Drop the podcasts table
DROP TABLE IF EXISTS podcasts;
go

-- Drop the albums_tracks table
DROP TABLE IF EXISTS albums_tracks;
go
-- Drop the tracks table
DROP TABLE IF EXISTS tracks;
go
-- Drop the albums table
DROP TABLE IF EXISTS albums;
go
-- Drop the podcaster table
DROP TABLE IF EXISTS podcaster;
go

-- Drop the artists table
DROP TABLE IF EXISTS artists;
go

-- Drop the users table
DROP TABLE IF EXISTS users;
go

-- Drop the genres_traks table
DROP TABLE IF EXISTS genres_tracks;
go

-- Drop the genres_podcast table
DROP TABLE IF EXISTS genres_podcast;
go

-- Drop the functions
Drop FUNCTION dbo.GetArtistTracks
Drop FUNCTION dbo.GetTracksByCriteria
Drop FUNCTION dbo.GetPodcastEpisodesByPodcastId
Drop FUNCTION dbo.SearchByCategory
Drop FUNCTION dbo.GetUserByIDAndPassword
Drop FUNCTION dbo.SearchFavoritesByCategory
Drop FUNCTION dbo.getTopPopularItems

-- Drop the sp 
DROP PROCEDURE AddUserAndRole 
DROP PROCEDURE insertFavoriteSong;
DROP PROCEDURE deleteFavoriteSong;
DROP PROCEDURE insertFavoritePlaylist;
DROP PROCEDURE deleteFavoritePlaylist;
DROP PROCEDURE insertFavoriteAlbum;
DROP PROCEDURE deleteFavoriteAlbum;
DROP PROCEDURE insertFavoritePodcast;
DROP PROCEDURE deleteFavoritePodcast;

-- Drop the roles
DROP ROLE db_datareader_custom;
GO

-- Create a database role for writing data
drop ROLE db_datawriter_custom;
GO

-- Create a database role for executing procedures
drop ROLE db_procedure_exec;
GO


-- Create the genres table for podcast
CREATE TABLE genres_podcast (
    id INT PRIMARY KEY   IDENTITY(1,1),
    name VARCHAR(255) NOT NULL UNIQUE
);
go
-- Create the genres table for tracks
CREATE TABLE genres_tracks(
    id INT PRIMARY KEY  IDENTITY(1,1),
    name VARCHAR(255) NOT NULL UNIQUE
);
go

-- Create the tracks table
CREATE TABLE tracks (
    id INT IDENTITY(1,1),
    title VARCHAR(255) NOT NULL,
    duration INT NOT NULL,
    release_date DATE,
    genre_id INT,
    cover_image_url VARCHAR(512),
    popularity INT DEFAULT 0,
    PRIMARY KEY NONCLUSTERED (id),
    FOREIGN KEY (genre_id) REFERENCES genres_tracks(id)
);
CREATE UNIQUE CLUSTERED INDEX idx_tracks_on_title ON tracks (title);
GO

-- Create the users table
CREATE TABLE users (
    id INT PRIMARY KEY  IDENTITY(1,1),
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    photourl VARCHAR(255),
    birth_date VARCHAR(255),
);
go
-- Create the artists table
CREATE TABLE artists (
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES users(id)
);
go
CREATE TABLE podcaster(
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES users(id)
);
go
-- Create the albums table
CREATE TABLE albums (
    id INT IDENTITY(1,1),
    title VARCHAR(255) NOT NULL,
    release_date DATE,
    artist_id INT,
    cover_image_url VARCHAR(512),
    popularity INT DEFAULT 0,
    PRIMARY KEY NONCLUSTERED (id),
    FOREIGN KEY (artist_id) REFERENCES artists(id)
);
CREATE UNIQUE CLUSTERED INDEX idx_albums_on_title ON albums (title);
GO
CREATE TABLE albums_tracks(
    id INT PRIMARY KEY  IDENTITY(1,1),
    track_id INT,
    album_id INT,
    FOREIGN KEY (album_id) REFERENCES albums(id),
    FOREIGN KEY (track_id) REFERENCES tracks(id)
);
go


-- Create the podcasts table
CREATE TABLE podcasts (
    id INT PRIMARY KEY  IDENTITY(1,1),
    title VARCHAR(255) NOT NULL,
    genre_id INT,
    description TEXT,
    cover_image_url VARCHAR(512),
    podaster_id INT,
    popularity INT DEFAULT 0,
    FOREIGN KEY (genre_id) REFERENCES genres_podcast(id),
    FOREIGN KEY (podaster_id) REFERENCES podcaster(id)
);
go
-- Create the podcast_episodes table
CREATE TABLE podcast_episodes (
    id INT PRIMARY KEY  IDENTITY(1,1),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    duration INT NOT NULL,
    release_date DATE,
    podcast_id INT,
    FOREIGN KEY (podcast_id) REFERENCES podcasts(id)
);
go
-- Create the playlists table
CREATE TABLE playlists (
    id INT IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    user_id INT,
    cover_image_url VARCHAR(512),
    popularity INT DEFAULT 0,
    PRIMARY KEY NONCLUSTERED (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE UNIQUE CLUSTERED INDEX idx_playlists_on_name ON playlists (name);
GO
-- Create the track_playlist association table
CREATE TABLE track_playlist (
    id INT PRIMARY KEY  IDENTITY(1,1),
    track_id INT,
    playlist_id INT,
    FOREIGN KEY (track_id) REFERENCES tracks(id),
    FOREIGN KEY (playlist_id) REFERENCES playlists(id)
);

CREATE TABLE track_artist (
    id INT PRIMARY KEY  IDENTITY(1,1),
    track_id INT,
    artist_id INT,
    FOREIGN KEY (track_id) REFERENCES tracks(id),
    FOREIGN KEY (artist_id) REFERENCES artists(id)
);
go

CREATE TABLE FavoriteSongs (
    id INT PRIMARY KEY  IDENTITY(1,1),
    [user_id] INT,
    track_id INT,
    FOREIGN KEY ([user_id]) REFERENCES users(id),
    FOREIGN KEY (track_id) REFERENCES tracks(id)
);
go

CREATE TABLE FavoriteAlbum (
    id INT PRIMARY KEY  IDENTITY(1,1),
    [user_id] INT,
    album_id INT,
    FOREIGN KEY ([user_id]) REFERENCES users(id),
    FOREIGN KEY (album_id) REFERENCES albums(id)
);
go

-- Create the FavoritePodcast table
CREATE TABLE FavoritePodcast (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    podcast_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (podcast_id) REFERENCES podcasts(id)    
);
go

-- Create the FavoritePlaylist table
CREATE TABLE FavoritePlaylist (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    playlist_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (playlist_id) REFERENCES playlists(id)
);
go




-----------------------PREMISSIONS--------------------------------------------------



-- Create a database role for reading data
CREATE ROLE db_datareader_custom;
GO

-- Create a database role for writing data
CREATE ROLE db_datawriter_custom;
GO

-- Create a database role for executing procedures
CREATE ROLE db_procedure_exec;
GO

-- Grant SELECT permission to the reader role on the necessary tables
GRANT SELECT ON users TO db_datareader_custom;
GRANT SELECT ON artists TO db_datareader_custom;
GRANT SELECT ON tracks TO db_datareader_custom;
GRANT SELECT ON albums TO db_datareader_custom;
GRANT SELECT ON playlists TO db_datareader_custom;
GRANT SELECT ON podcasts TO db_datareader_custom;
GO

-- Grant INSERT, UPDATE, DELETE permissions to the writer role on the necessary tables
GRANT INSERT, UPDATE, DELETE ON users TO db_datawriter_custom;
GRANT INSERT, UPDATE, DELETE ON artists TO db_datawriter_custom;
GRANT INSERT, UPDATE, DELETE ON tracks TO db_datawriter_custom;
GRANT INSERT, UPDATE, DELETE ON albums TO db_datawriter_custom;
GRANT INSERT, UPDATE, DELETE ON playlists TO db_datawriter_custom;
GRANT INSERT, UPDATE, DELETE ON podcasts TO db_datawriter_custom;
GO



-------------------------------Triggers--------------------------------------------

-- Trigger for FavoriteSongs table
CREATE TRIGGER trg_FavoriteSongs_popularity
ON FavoriteSongs
AFTER INSERT, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE tracks
        SET popularity = popularity + 1
        WHERE id IN (SELECT track_id FROM inserted)
    END
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE tracks
        SET popularity = popularity - 1
        WHERE id IN (SELECT track_id FROM deleted)
    END
END
GO

-- Trigger for FavoriteAlbum table
CREATE TRIGGER trg_FavoriteAlbum_popularity
ON FavoriteAlbum
AFTER INSERT, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE albums
        SET popularity = popularity + 1
        WHERE id IN (SELECT album_id FROM inserted)
    END
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE albums
        SET popularity = popularity - 1
        WHERE id IN (SELECT album_id FROM deleted)
    END
END
GO

-- Trigger for FavoritePlaylist table
CREATE TRIGGER trg_FavoritePlaylist_popularity
ON FavoritePlaylist
AFTER INSERT, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE playlists
        SET popularity = popularity + 1
        WHERE id IN (SELECT playlist_id FROM inserted)
    END
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE playlists
        SET popularity = popularity - 1
        WHERE id IN (SELECT playlist_id FROM deleted)
    END
END
GO

-- Trigger for FavoritePodcast table
CREATE TRIGGER trg_FavoritePodcast_popularity
ON FavoritePodcast
AFTER INSERT, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE podcasts
        SET popularity = popularity + 1
        WHERE id IN (SELECT podcast_id FROM inserted)
    END
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE podcasts
        SET popularity = popularity - 1
        WHERE id IN (SELECT podcast_id FROM deleted)
    END
END
GO

---------------------------------------Castate--------------------------------------------


CREATE TRIGGER deleteUser 
ON users
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM artists
    WHERE id IN (SELECT id FROM deleted);

    DELETE FROM podcaster
    WHERE id IN (SELECT id FROM deleted);

    DELETE FROM playlists
    WHERE [user_id] in (SELECT id FROM deleted);

    DELETE FROM FavoriteSongs
    WHERE [user_id] IN (SELECT id FROM deleted);

    DELETE FROM FavoriteAlbum
    WHERE [user_id] IN (SELECT id FROM deleted);

    DELETE FROM FavoritePodcast
    WHERE [user_id] IN (SELECT id FROM deleted);

    DELETE FROM FavoritePlaylist
    WHERE [user_id] IN (SELECT id FROM deleted);

    DELETE FROM users
    WHERE id IN (SELECT id FROM deleted);
END;
GO

CREATE TRIGGER deleteArtist
ON artists
INSTEAD OF DELETE
AS
BEGIN

    DELETE FROM albums
    WHERE artist_id IN (SELECT id FROM deleted);

    DELETE FROM track_artist
    WHERE artist_id IN (SELECT id FROM deleted);

    DELETE FROM artists
    WHERE id IN (SELECT id FROM deleted);

END;
GO


CREATE TRIGGER deletePodcaster
ON podcaster
INSTEAD OF DELETE
AS
BEGIN

    DELETE FROM podcasts
    WHERE podaster_id IN (SELECT id FROM deleted);

    DELETE FROM podcaster
    WHERE id IN (SELECT id FROM deleted);

END;
GO

CREATE TRIGGER deleteAlbum
ON albums
INSTEAD OF DELETE
AS
BEGIN

    DELETE FROM albums_tracks
    WHERE album_id IN (SELECT id FROM deleted);

    DELETE FROM FavoriteAlbum
    WHERE album_id IN (SELECT id FROM deleted);

    DELETE FROM albums
    WHERE id IN (SELECT id FROM deleted);

END;
GO

CREATE TRIGGER deletePodcast
ON podcasts
INSTEAD OF DELETE
AS
BEGIN

    DELETE FROM podcast_episodes
    WHERE podcast_id IN (SELECT id FROM deleted);

    DELETE FROM FavoritePodcast
    WHERE podcast_id IN (SELECT id FROM deleted);

    DELETE FROM podcasts
    WHERE id IN (SELECT id FROM deleted);

END;
GO

CREATE TRIGGER deletePlaylist
ON playlists
INSTEAD OF DELETE
AS
BEGIN

    DELETE FROM track_playlist
    WHERE playlist_id IN (SELECT id FROM deleted);
    
    DELETE FROM FavoritePlaylist
    WHERE playlist_id IN (SELECT id FROM deleted);

    DELETE FROM playlists
    WHERE id IN (SELECT id FROM deleted);

END;
GO

CREATE TRIGGER deleteTrackWithArtist
ON track_artist
INSTEAD OF DELETE
AS
BEGIN

    DELETE FROM FavoriteSongs
    WHERE track_id IN (SELECT track_id FROM deleted);

    DELETE FROM track_artist
    WHERE id IN (SELECT id FROM deleted);

    DELETE FROM track_playlist
    WHERE track_id IN (SELECT track_id FROM deleted);

    DELETE FROM tracks
    WHERE id IN (SELECT track_id FROM deleted);

END;
GO

CREATE TRIGGER deletePodcastEpisode
ON podcast_episodes
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM FavoritePodcast
    WHERE podcast_id IN (SELECT podcast_id FROM deleted);

    DELETE FROM podcast_episodes
    WHERE id IN (SELECT id FROM deleted);
END;
GO


CREATE TRIGGER deleteTrackPlaylist
ON track_playlist
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM FavoriteSongs
    WHERE track_id IN (SELECT track_id FROM deleted);

    DELETE FROM track_playlist
    WHERE id IN (SELECT id FROM deleted);
END;
GO

CREATE TRIGGER deleteTrack
ON tracks
INSTEAD OF DELETE
AS
BEGIN

    DELETE FROM FavoriteSongs
    WHERE track_id IN (SELECT id FROM deleted);

    DELETE FROM track_playlist
    WHERE track_id IN (SELECT id FROM deleted);
    
    DELETE FROM albums_tracks
    WHERE track_id IN (SELECT id FROM deleted);

    DELETE FROM tracks
    WHERE id IN (SELECT id FROM deleted);

END;
GO





-------------------------------------------------SP--------------------------------
CREATE PROCEDURE AddUserAndRole 
    @username NVARCHAR(255),
    @password NVARCHAR(255),
    @email NVARCHAR(255),
    @birth_date NVARCHAR(255),
    @photourl NVARCHAR(255),
    @role NVARCHAR(255)
AS
BEGIN
    DECLARE @UserId INT;

    -- Insert into the 'users' table and get the inserted ID
    INSERT INTO users(username, password, email, birth_date, photourl) VALUES (@username, @password, @email, @birth_date,@photourl);
   
    SET @UserId = SCOPE_IDENTITY();

    -- Check the role and insert into the corresponding table
    IF @role = 'artist' 
        INSERT INTO  artists (id) VALUES (@UserId);
    ELSE IF @role = 'podcaster' 
        INSERT INTO podcaster(id) VALUES (@UserId);
    ELSE IF @role = 'artist_podcaster' BEGIN
        INSERT INTO  artists (id) VALUES (@UserId);
        INSERT INTO podcaster(id) VALUES (@UserId);
    END
END;
GO

-- Procedure to insert a song into FavoriteSongs
CREATE PROCEDURE insertFavoriteSong @user_id INT, @track_id INT
AS
BEGIN
    INSERT INTO FavoriteSongs (user_id, track_id) VALUES (@user_id, @track_id);
END;
GO

-- Procedure to delete a song from FavoriteSongs
CREATE PROCEDURE deleteFavoriteSong @user_id INT, @track_id INT
AS
BEGIN
    DELETE FROM FavoriteSongs WHERE user_id = @user_id AND track_id = @track_id;
END;
GO

-- Procedure to insert a playlist into FavoritePlaylist
CREATE PROCEDURE insertFavoritePlaylist @user_id INT, @playlist_id INT
AS
BEGIN
    INSERT INTO FavoritePlaylist (user_id, playlist_id) VALUES (@user_id, @playlist_id);
END;
GO

-- Procedure to delete a playlist from FavoritePlaylist
CREATE PROCEDURE deleteFavoritePlaylist @user_id INT, @playlist_id INT
AS
BEGIN
    DELETE FROM FavoritePlaylist WHERE user_id = @user_id AND playlist_id = @playlist_id;
END;
GO

-- Procedure to insert an album into FavoriteAlbum
CREATE PROCEDURE insertFavoriteAlbum @user_id INT, @album_id INT
AS
BEGIN
    INSERT INTO FavoriteAlbum (user_id, album_id) VALUES (@user_id, @album_id);
END;
GO

-- Procedure to delete an album from FavoriteAlbum
CREATE PROCEDURE deleteFavoriteAlbum @user_id INT, @album_id INT
AS
BEGIN
    DELETE FROM FavoriteAlbum WHERE user_id = @user_id AND album_id = @album_id;
END;
GO

-- Procedure to insert a podcast into FavoritePodcast
CREATE PROCEDURE insertFavoritePodcast @user_id INT, @podcast_id INT
AS
BEGIN
    INSERT INTO FavoritePodcast (user_id, podcast_id) VALUES (@user_id, @podcast_id);
END;
GO

-- Procedure to delete a podcast from FavoritePodcast
CREATE PROCEDURE deleteFavoritePodcast @user_id INT, @podcast_id INT
AS
BEGIN
    DELETE FROM FavoritePodcast WHERE user_id = @user_id AND podcast_id = @podcast_id;
END;
GO



-------------------------------------------------UDF--------------------------------
CREATE FUNCTION dbo.GetArtistTracks(@artistId INT) 
RETURNS TABLE
AS RETURN
(
    SELECT tracks.id, tracks.title, tracks.duration, tracks.release_date, tracks.cover_image_url,genres_tracks.name  AS genre_name
    FROM tracks
    JOIN track_artist ON tracks.id = track_artist.track_id
    JOIN artists ON track_artist.artist_id = artists.id
    JOIN genres_tracks ON tracks.genre_id = genres_tracks.id
    WHERE artists.id = @artistId
);
GO

CREATE FUNCTION dbo.GetTracksByCriteria 
(
    @category VARCHAR(50),
    @Id INT = NULL
)
RETURNS TABLE
AS RETURN
(
    SELECT tracks.id, tracks.title, tracks.duration, tracks.release_date ,genres_tracks.name AS genre_name, tracks.cover_image_url
    FROM tracks
    JOIN genres_tracks ON tracks.genre_id = genres_tracks.id
    WHERE
    (
        (@category = 'playlists' AND (@Id IS NULL OR EXISTS (SELECT 1 FROM track_playlist WHERE track_id = tracks.id AND playlist_id = @Id)))
        OR
        (@category = 'albums' AND (@Id IS NULL OR EXISTS (SELECT 1 FROM albums_tracks WHERE track_id = tracks.id AND album_id = @Id)))
    )
);
GO

CREATE FUNCTION dbo.GetPodcastEpisodesByPodcastId(@podcastId INT) 
RETURNS TABLE
AS RETURN
(
    SELECT podcast_episodes.id, podcast_episodes.title, podcast_episodes.description, podcast_episodes.duration, podcast_episodes.release_date, genres_podcast.name AS genre_name
    FROM podcast_episodes
    JOIN podcasts ON podcast_episodes.podcast_id = podcasts.id
    JOIN genres_podcast ON podcasts.genre_id = genres_podcast.id
    WHERE podcasts.id = @podcastId
);
GO



CREATE FUNCTION dbo.SearchByCategory 
(
    @category VARCHAR(50),
    @searchTerm VARCHAR(255)
)
RETURNS TABLE
AS RETURN
(
    SELECT albums.id, albums.title, NULL AS duration, NULL AS release_date, albums.cover_image_url, NULL AS genre_name
    FROM albums
    WHERE @category = 'albums' AND albums.title LIKE @searchTerm + '%'

    UNION ALL

    SELECT playlists.id, playlists.name AS title, NULL AS duration, NULL AS release_date, NULL AS genre_name, playlists.cover_image_url
    FROM playlists
    WHERE @category = 'playlists' AND playlists.name LIKE @searchTerm + '%'

    UNION ALL

    SELECT tracks.id, tracks.title, tracks.duration, tracks.release_date, genres_tracks.name AS genre_name, tracks.cover_image_url
    FROM tracks
    JOIN genres_tracks ON tracks.genre_id = genres_tracks.id
    WHERE @category = 'songs' AND tracks.title LIKE @searchTerm + '%'

    UNION ALL

    SELECT podcasts.id, podcasts.title, NULL AS duration, NULL AS release_date, genres_podcast.name AS genre_name, podcasts.cover_image_url
    FROM podcasts
    JOIN genres_podcast ON podcasts.genre_id = genres_podcast.id
    WHERE @category = 'podcasts' AND podcasts.title LIKE @searchTerm + '%'
);
GO

CREATE FUNCTION dbo.SearchFavoritesByCategory
(
    @category VARCHAR(50),
    @searchTerm VARCHAR(255),
    @userId INT
)
RETURNS TABLE
AS RETURN
(
    SELECT tracks.id, tracks.title, tracks.duration, tracks.release_date, genres_tracks.name AS genre_name, tracks.cover_image_url
    FROM tracks
    JOIN genres_tracks ON tracks.genre_id = genres_tracks.id
    JOIN FavoriteSongs AS ft ON tracks.id = ft.track_id
    WHERE @category = 'songs' AND ft.user_id = @userId AND tracks.title LIKE @searchTerm + '%'

    UNION ALL

    SELECT podcasts.id, podcasts.title, NULL AS duration, NULL AS release_date, genres_podcast.name AS genre_name,  podcasts.cover_image_url
    FROM podcasts
    JOIN genres_podcast ON podcasts.genre_id = genres_podcast.id
    JOIN FavoritePodcast AS fp ON podcasts.id = fp.podcast_id
    WHERE @category = 'podcasts' AND fp.user_id = @userId AND podcasts.title LIKE @searchTerm + '%'

    UNION ALL

    SELECT albums.id, albums.title, NULL AS duration, albums.release_date, NULL AS genre_name , albums.cover_image_url
    FROM albums
    JOIN FavoriteAlbum AS fa ON albums.id = fa.album_id
    WHERE @category = 'albums' AND fa.user_id = @userId AND albums.title LIKE @searchTerm + '%'

    UNION ALL

    SELECT playlists.id, playlists.name AS title, NULL AS duration, NULL AS release_date, NULL AS genre_name,   playlists.cover_image_url
    FROM playlists
    JOIN FavoritePlaylist AS fp ON playlists.id = fp.playlist_id
    WHERE @category = 'playlists' AND fp.user_id = @userId AND playlists.name LIKE @searchTerm + '%'
);
GO

CREATE FUNCTION dbo.GetUserByIDAndPassword
(
    @username VARCHAR(255),
    @password VARCHAR(255)
)
RETURNS INT
AS
BEGIN
    DECLARE @userId INT;
    
    SELECT @userId = id
    FROM users
    WHERE username = @username AND password = @password;
    
    RETURN @userId;
END;
GO

CREATE FUNCTION dbo.getTopPopularItems()
RETURNS @TopItems TABLE 
(
    type NVARCHAR(50),
    title NVARCHAR(255),
    popularity INT,
    release_date DATE
)
AS
BEGIN
    INSERT INTO @TopItems
        SELECT TOP 2 'playlist' as type, name as title, popularity, NULL as release_date FROM playlists
        UNION ALL
        SELECT TOP 2 'album' as type, title, popularity, release_date FROM albums
        UNION ALL
        SELECT TOP 2 'podcast' as type, title , popularity, NULL as release_date FROM podcasts
        UNION ALL
        SELECT TOP 2 'track' as type, title, popularity, release_date FROM tracks
        ORDER BY popularity DESC;

    RETURN;
END;
GO




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
VALUES(1, 1), (2, 3), (3, 1), (4, 3), (5, 1) , (6, 3);

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
