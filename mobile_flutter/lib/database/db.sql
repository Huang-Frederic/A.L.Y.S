SELECT
  b.id,
  b.title,
  b.status,
  b.release,
  b.cover_url,
  b.type,
  b.description,
  (SELECT a.first_name || ' ' || a.last_name
   FROM authors a
   JOIN book_authors ba ON ba.author_id = a.id
   WHERE ba.book_id = b.id
   LIMIT 1) AS author,
  latest_chapter.number AS latest_chapter,
  latest_chapter.release AS latest_chapter_release,
  ARRAY(SELECT g.name FROM genres g
        JOIN book_genres bg ON bg.genre_id = g.id
        WHERE bg.book_id = b.id) AS genres
FROM books b
LEFT JOIN (
  SELECT DISTINCT ON (c.book_id)
    c.book_id,
    c.number,
    c.release
  FROM chapters c
  ORDER BY c.book_id, c.release DESC
) AS latest_chapter ON b.id = latest_chapter.book_id;
