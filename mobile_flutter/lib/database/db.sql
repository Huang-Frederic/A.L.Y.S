create
or replace function public.get_all_books_with_details () returns setof RECORD language sql as $$
SELECT
  b.id,
  b.title,
  b.status,
  b.release,
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
) AS latest_chapter
ON b.id = latest_chapter.book_id;
$$;
