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