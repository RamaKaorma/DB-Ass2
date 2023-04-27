SELECT DISTINCT keyword.Id, keyword.Word
FROM keyword
JOIN publication_has_keyword ON keyword.Id = publication_has_keyword.keywordID
WHERE publication_has_keyword.keywordID IN (
	SELECT DISTINCT PublicationId
	FROM topten
	GROUP BY PublicationId
	HAVING COUNT(PublicationId) = (
		SELECT MAX(count) FROM (
			SELECT PublicationId, COUNT(PublicationId) AS count 
			FROM topten 
			GROUP BY PublicationId 
		) AS maxCount
	)
);











