# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Check if the database exists and drop it if it does
DROP DATABASE IF EXISTS visual_art_gallery;

-- Create the database
CREATE DATABASE visual_art_gallery;

-- Check whether the database is created
SHOW DATABASES;

-- Once the database is created, use the database
USE visual_art_gallery;


# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create the Artists table
CREATE TABLE Artists (
ArtistID INT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Biography TEXT,
Nationality VARCHAR(100));

-- Create the Categories table
CREATE TABLE Categories (
CategoryID INT PRIMARY KEY,
Name VARCHAR(100) NOT NULL);

-- Create the Artworks table
CREATE TABLE Artworks (
ArtworkID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
ArtistID INT,
CategoryID INT,
Year INT,
Description TEXT,
ImageURL VARCHAR(255),
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

-- Create the Exhibitions table
CREATE TABLE Exhibitions (
ExhibitionID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
StartDate DATE,
EndDate DATE,
Description TEXT);

-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
ExhibitionID INT,
ArtworkID INT,
PRIMARY KEY (ExhibitionID, ArtworkID),
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

-- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\'s powerful anti-war mural.', 'guernica.jpg');

-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Displaying the tables
SELECT * FROM Artists;
SELECT * FROM Categories;
SELECT * FROM Artworks;
SELECT * FROM Exhibitions;
SELECT * FROM ExhibitionArtworks;

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.
SELECT
    a.Name,
    COUNT(aw.ArtworkID) AS NumOfArtworks
FROM
    Artists a
    LEFT JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY
    a.ArtistID, a.Name
ORDER BY
    NumOfArtworks DESC;
    
-- 2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.
SELECT
    aw.Title,
    a.Name,
    a.Nationality,
    aw.Year
FROM
    Artworks aw
    INNER JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE
    a.Nationality IN ('Spanish', 'Dutch')
ORDER BY
    aw.Year ASC;
    
-- 3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category.
SELECT
    a.Name,
    COUNT(aw.ArtworkID) AS NumOfPaintings
FROM
    Artists a
    INNER JOIN Artworks aw ON a.ArtistID = aw.ArtistID
    INNER JOIN Categories c ON aw.CategoryID = c.CategoryID
WHERE
    c.Name = 'Painting'
GROUP BY
    a.ArtistID, a.Name;

-- 4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.
SELECT
    aw.Title AS ArtworkTitle,
    a.Name AS Artist,
    c.Name AS Category
FROM
    Artworks aw
    INNER JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
    INNER JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
    INNER JOIN Artists a ON aw.ArtistID = a.ArtistID
    INNER JOIN Categories c ON aw.CategoryID = c.CategoryID
WHERE
    e.Title = 'Modern Art Masterpieces';
    
-- 5. Find the artists who have more than two artworks in the gallery.
SELECT
    a.Name,
    COUNT(aw.ArtworkID) AS NumOfArtworks
FROM
    Artists a
    INNER JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY
    a.ArtistID, a.Name
HAVING
    COUNT(aw.ArtworkID) > 2;
    
# Result : NULL (or) Empty Set (or) 0 rows(s) returned

-- 6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions.
SELECT
    aw.Title as ArtworkTitle
FROM
    Artworks aw
    INNER JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
    INNER JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
WHERE
    e.Title IN ('Modern Art Masterpieces', 'Renaissance Art')
GROUP BY
    aw.ArtworkID, aw.Title
HAVING
    COUNT(DISTINCT e.Title) = 2;

-- 7. Find the total number of artworks in each category.
SELECT
    c.Name AS Category,
    COUNT(aw.ArtworkID) AS NumOfArtworks
FROM
    Categories c
    LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY
    c.CategoryID, c.Name;

-- 8. List artists who have more than 3 artworks in the gallery.
SELECT
    a.Name,
    COUNT(aw.ArtworkID) AS NumOfArtworks
FROM
    Artists a
    INNER JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY
    a.ArtistID, a.Name
HAVING
    COUNT(aw.ArtworkID) > 3;
    
# Result : NULL (or) Empty Set (or) 0 rows(s) returned

-- 9. Find the artworks created by artists from a specific nationality (e.g., Spanish).
SELECT
    aw.ArtworkID,
    aw.Title,
    aw.ArtistID,
    a.Name,
    a.Nationality,
    aw.Year,
    aw.Description
FROM
    Artworks aw
    INNER JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE
    a.Nationality = 'Spanish';
    
-- 10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.
SELECT
    e.ExhibitionID,
    e.Title
FROM
    Exhibitions e
    INNER JOIN ExhibitionArtworks ea ON e.ExhibitionID = ea.ExhibitionID
    INNER JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID
    INNER JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE
    a.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY
    e.ExhibitionID, e.Title
HAVING
    COUNT(DISTINCT a.Name) = 2;

-- 11. Find all the artworks that have not been included in any exhibition.
SELECT
    aw.*
FROM
    Artworks aw
    LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
WHERE
    ea.ExhibitionID IS NULL;
    
# Result : NULL (or) Empty Set (or) 0 rows(s) returned

-- 12. List artists who have created artworks in all available categories.
SELECT
    a.Name
FROM
    Artists a
    INNER JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY
    a.ArtistID, a.Name
HAVING
    COUNT(DISTINCT aw.CategoryID) = (SELECT COUNT(*) FROM Categories);

# Result : NULL (or) Empty Set (or) 0 rows(s) returned

-- 13. List the total number of artworks in each category.
SELECT
    c.Name AS Category,
    COUNT(aw.ArtworkID) AS NumOfArtworks
FROM
    Categories c
    LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY
    c.CategoryID, c.Name;
    
-- 14. Find the artists who have more than 2 artworks in the gallery.
SELECT
    a.Name,
    COUNT(aw.ArtworkID) AS NumOfArtworks
FROM
    Artists a
    INNER JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY
    a.ArtistID, a.Name
HAVING
    COUNT(aw.ArtworkID) > 2;

# Result : NULL (or) Empty Set (or) 0 rows(s) returned

-- 15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
SELECT
    c.Name AS Category,
    AVG(aw.Year) AS AvgYear
FROM
    Categories c
    INNER JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY
    c.CategoryID, c.Name
HAVING
    COUNT(aw.ArtworkID) > 1;

-- 16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
SELECT
    aw.*
FROM
    Artworks aw
    INNER JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
    INNER JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
WHERE
    e.Title = 'Modern Art Masterpieces';

-- 17. Find the categories where the average year of artworks is greater than the average year of all artworks.
SELECT
    c.Name AS Category,
    AVG(aw.Year) AS AvgCategoryYear
FROM
    Categories c
    INNER JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY
    c.CategoryID, c.Name
HAVING
    AVG(aw.Year) > (SELECT AVG(Year) FROM Artworks);

# Result : NULL (or) Empty Set (or) 0 rows(s) returned

-- 18. List the artworks that were not exhibited in any exhibition.
SELECT
    aw.*
FROM
    Artworks aw
    LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
WHERE
    ea.ExhibitionID IS NULL;
    
# Result : NULL (or) Empty Set (or) 0 rows(s) returned

-- 19. Show artists who have artworks in the same category as "Mona Lisa."
SELECT DISTINCT
    a.*
FROM
    Artists a
    INNER JOIN Artworks aw ON a.ArtistID = aw.ArtistID
WHERE															# correlated subquery
    aw.CategoryID = (
        SELECT
            CategoryID
        FROM
            Artworks
        WHERE
            Title = 'Mona Lisa'
    );

-- 20. List the names of artists and the number of artworks they have in the gallery.
SELECT
    a.Name,
    COUNT(aw.ArtworkID) AS NumArtworks
FROM
    Artists a
    INNER JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY
    a.ArtistID, a.Name;

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------