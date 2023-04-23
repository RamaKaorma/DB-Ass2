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
)


