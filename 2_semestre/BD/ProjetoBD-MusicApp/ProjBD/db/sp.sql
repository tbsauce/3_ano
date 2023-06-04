use p9g11;
go
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


