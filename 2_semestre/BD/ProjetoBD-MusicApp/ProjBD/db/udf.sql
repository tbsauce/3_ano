use p9g11;
go
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
