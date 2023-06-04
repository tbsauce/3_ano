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