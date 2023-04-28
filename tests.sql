-- Find researchers that research databases
-- Find researchers that research machine learning
-- Cut out researchers from databases that do not coauthor with researchers from machine learning
SELECT *
FROM researcher
JOIN coauthors ON researcher.Id = AuthorID
JOIN publication ON publication.Id = PublicationID
WHERE publication.Id IN (
	SELECT publication.Id
	FROM publication
	JOIN publication_has_keyword ON publication.Id = publicationID
	JOIN keyword ON publication_has_keyword.keywordID = keyword.Id
	WHERE Word = 'Databases'
);

-- Find researchers that research machine learning
SELECT *
FROM researcher
JOIN coauthors ON researcher.Id = AuthorID
JOIN publication ON publication.Id = PublicationID
WHERE publication.Id IN (
	SELECT publication.Id
	FROM publication
	JOIN publication_has_keyword ON publication.Id = publicationID
	JOIN keyword ON publication_has_keyword.keywordID = keyword.Id
	WHERE Word = 'Machine Learning'
);

-- Find authors that coauthor
SELECT FirstName, LastName
FROM researcher 
JOIN coauthors AS first ON researcher.Id = AuthorID
WHERE AuthorID IN (
	SELECT AuthorID
    FROM researcher 
    JOIN coauthors AS second ON researcher.Id = AuthorID
    WHERE first.PublicationID = second.PublicationID
)