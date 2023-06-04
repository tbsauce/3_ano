use p9g11;
go

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