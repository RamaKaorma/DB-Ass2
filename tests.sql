-- Select publications cited at least twice
SELECT referencedPublicationId
FROM referencing
GROUP BY referencedPublicationId
HAVING COUNT(referencedPublicationId) >= 2;

-- Select publications in the topten at least once
SELECT PublicationId
FROM topten
GROUP BY PublicationId
HAVING COUNT(PublicationId) >= 1;

-- Select publications that satisfy both previous conditions
SELECT Id
FROM publication
WHERE Id IN (
	SELECT referencedPublicationId
	FROM referencing
	GROUP BY referencedPublicationId
	HAVING COUNT(referencedPublicationId) >= 2
) AND Id IN (
	SELECT PublicationId
	FROM topten
	GROUP BY PublicationId
	HAVING COUNT(PublicationId) >= 1
);
-- PROBLEM: I pick publications that have at least 2 citations. 
-- I need to pick researchers that have at least 2 citations 
-- So it can be on multiple publications
-- We want the SUM of publications to be >= 2

-- Select publications by a specific researcher and those in topten
SELECT researcher.Id, researcher.FirstName, researcher.LastName, coauthors.PublicationID, COUNT(researcher.Id)
FROM researcher JOIN coauthors
ON researcher.Id = coauthors.AuthorID
JOIN referencing 
ON coauthors.PublicationID = referencing.referencedPublicationId
GROUP BY researcher.Id, referencing.referencedPublicationId;

SELECT researcher.Id, researcher.FirstName, researcher.LastName, coauthors.PublicationID
FROM researcher JOIN coauthors
ON researcher.Id = coauthors.AuthorID
JOIN referencing
ON coauthors.PublicationID = referencing.referencedPublicationId


