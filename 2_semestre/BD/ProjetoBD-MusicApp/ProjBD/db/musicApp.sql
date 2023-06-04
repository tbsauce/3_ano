use p9g11;
go


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

