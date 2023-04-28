-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\____/\\\\\_________/\\\\\\\\\_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\________________/\\\\\\\\\_______/\\\\\\\\\_____        
--  _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////___/\\\///\\\_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___       
--   _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\____________/\\\/__\///\\\__\///______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\_____________/\\\/////////\\\_\///______\//\\\__      
--    _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\___/\\\______\//\\\___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//_____________\/\\\_______\/\\\___________/\\\/___     
--     _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////___\/\\\_______\/\\\________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\____________\/\\\\\\\\\\\\\\\________/\\\//_____    
--      _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\__________\//\\\______/\\\______/\\\//________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\___________\/\\\/////////\\\_____/\\\//________   
--       _____\/\\\_____\/\\\__\//\\\\\\_\/\\\___________\///\\\__/\\\______/\\\/___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\____________\/\\\_______\/\\\___/\\\/___________  
--        __/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\_____________\///\\\\\/______/\\\\\\\\\\\\\\\__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\_______\/\\\__/\\\\\\\\\\\\\\\_ 
--         _\///////////__\///_____\/////__\///________________\/////_______\///////////////_____\///////________\///////________\///////_______\/////////_______________\///________\///__\///////////////__

-- Your Name: Rama Kaorma
-- Your Student Number: 1353255
-- By submitting, you declare that this work was completed entirely by yourself.

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1

SELECT ID, Title
FROM publication 
WHERE publication.ID NOT IN (
	SELECT ID 
    FROM publication 
    INNER JOIN referencing 
    ON publication.ID = referencing.referencingPublicationId
);

-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2

SELECT ID, Title, DateOfPublication
FROM publication
ORDER BY DateOfPublication DESC
LIMIT 1;

-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3

-- Publications that are at least 10 pages long
SELECT ID, Title
FROM publication
WHERE EndPage - StartPage >= 10 AND ID in (
	-- Publication ID of authors that have publications longer than 10 pages
	SELECT DISTINCT PublicationID
	FROM coauthors
	WHERE AuthorID IN (
		-- Select Renata
		SELECT ID
		FROM researcher
        WHERE FirstName = 'Renata' 
        AND   LastName = 'Borovica-Gajic'
	)
);

-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4

SELECT p.id, p.Title, COUNT(r.referencedPublicationId) AS PubCount 
FROM publication AS p JOIN referencing AS r
ON p.Id = r.referencedPublicationId
GROUP BY referencedPublicationId 
HAVING PubCount = (
	-- Maximum number of citations
	SELECT MAX(PubCount) FROM (
		-- Count the number of times each publication is cited
		SELECT referencedPublicationId, COUNT(referencedPublicationId) AS PubCount 
		FROM referencing 
		GROUP BY referencedPublicationId 
	) AS maxCount 
);

-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5

-- SELECT publications with that same ID
SELECT Id, documentURL
FROM publication
WHERE ID IN (
	-- Select publication id with database topic
	SELECT publicationID
	FROM publication_has_keyword
	WHERE keywordID = (
		-- Select keyword id of databases
		SELECT Id 
		FROM keyword
		WHERE Word = 'Databases'
	)
)
AND ID IN (
	-- Check publication has been cited
	SELECT DISTINCT referencedPublicationId 
    FROM referencing
);

-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6

SELECT firstName, LastName
FROM researcher 
WHERE researcher.Id IN (
	-- Select researchers with at least 2 citations
	SELECT researcher.Id
	FROM researcher
	JOIN coauthors ON researcher.Id = AuthorID
	JOIN referencing ON PublicationID = referencedPublicationId
	GROUP BY researcher.Id
	HAVING COUNT(referencedPublicationId) >= 2
	ORDER BY researcher.Id
) AND researcher.Id IN (
	-- Select researchers at the topten list
	SELECT researcher.Id 
	FROM researcher
	JOIN coauthors ON researcher.Id = AuthorID
	JOIN topten ON coauthors.PublicationID = topten.PublicationId
	GROUP BY researcher.Id
    HAVING COUNT(topten.PublicationId) >= 1
);

-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7

SELECT DISTINCT keyword.Id, keyword.Word
FROM keyword
JOIN publication_has_keyword ON keyword.Id = publication_has_keyword.keywordID
WHERE publication_has_keyword.keywordID IN (
	SELECT DISTINCT PublicationId
	FROM topten
	GROUP BY PublicationId
	HAVING COUNT(PublicationId) = (
		SELECT MAX(PubCount) FROM (
			SELECT PublicationId, COUNT(PublicationId) AS PubCount 
			FROM topten 
			GROUP BY PublicationId 
		) AS maxCount
	)
);

-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8

SELECT FirstName, LastName 
FROM researcher
WHERE researcher.Id IN (
	SELECT researcher.Id
	FROM researcher
	JOIN coauthors ON researcher.Id = AuthorID
	JOIN referencing ON PublicationID = referencedPublicationId
	GROUP BY researcher.Id
    HAVING COUNT(referencedPublicationId)  = (
		SELECT MAX(PubCount) FROM (
            SELECT researcher.Id, COUNT(referencedPublicationId) AS PubCount
			FROM researcher
			JOIN coauthors ON researcher.Id = AuthorID
			JOIN referencing ON PublicationID = referencedPublicationId
			GROUP BY researcher.Id
        ) as maxNumCitations
    )
	ORDER BY researcher.Id
);

-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9





-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10





-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- END OF ASSIGNMENT Do not write below this line