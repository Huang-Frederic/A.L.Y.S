import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

required_env_vars = ['SUPABASE_URL', 'SUPABASE_KEY']
missing_vars = [var for var in required_env_vars if not os.getenv(var)]

if missing_vars:
    raise EnvironmentError(f'Missing environment variables: {", ".join(missing_vars)}')

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')

# Create Supabase client
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def insert_db(books):
    for book in books:
        book_id = insert_or_get_book_id(book)

        # Insert authors if they don't exist and link to the book
        for author in book.authors:
            author_id = insert_author_if_not_exists(author)
            link_book_author(book_id, author_id)

        # Insert genres if they don't exist and link to the book
        for genre in book.genres:
            genre_id = insert_genre_if_not_exists(genre)
            link_book_genre(book_id, genre_id)

        # Insert chapters if they don't exist and link to the book
        for chapter_data in book.chapters:
            chapter_id = insert_or_get_chapter_id(book_id, chapter_data)

            # Insert images if they don't exist and link to the chapter
            for image_data in chapter_data.images:
                insert_image_if_not_exists(chapter_id, image_data)

def insert_or_get_book_id(book):
    # Check if the book already exists
    existing_book_response = supabase.table('books').select('id').eq('title', book.title).eq('release', book.release).execute()
    
    if existing_book_response.data:
        book_id = existing_book_response.data[0]['id']
    else:
        # Insert the book if it doesn't exist
        inserted_book_response = supabase.table('books').insert({
            'title': book.title,
            'release': book.release,  
            'type': book.type.value,
            'status': book.status.value,
            'description': book.description,
            'cover_url': book.cover_url
        }).execute()

        if inserted_book_response.data:
            book_id = inserted_book_response.data[0]['id']
        else:
            raise Exception(f"Failed to insert book: {inserted_book_response}")

    return book_id


def insert_author_if_not_exists(author):
    # Check if author exists
    existing_author_response = supabase.table('authors').select('id').eq('first_name', author.first_name).eq('last_name', author.last_name).execute()

    if existing_author_response.data:
        author_id = existing_author_response.data[0]['id']
    else:
        # Insert new author
        inserted_author_response = supabase.table('authors').insert({
            'first_name': author.first_name,
            'last_name': author.last_name
        }).execute()

        if inserted_author_response.data:
            author_id = inserted_author_response.data[0]['id']
        else:
            raise Exception(f"Failed to insert author: {inserted_author_response}")

    return author_id


def link_book_author(book_id, author_id):
    # Check if the link between book and author already exists
    existing_link_response = supabase.table('book_authors').select('*').eq('book_id', book_id).eq('author_id', author_id).execute()

    if not existing_link_response.data:
        # Link book to author
        insert_response = supabase.table('book_authors').insert({
            'book_id': book_id,
            'author_id': author_id
        }).execute()

        if not insert_response.data:
            raise Exception(f"Failed to link book and author: {insert_response}")


def insert_genre_if_not_exists(genre):
    # Check if genre exists
    existing_genre_response = supabase.table('genres').select('id').eq('name', genre.name).execute()

    if existing_genre_response.data:
        genre_id = existing_genre_response.data[0]['id']
    else:
        # Insert new genre
        inserted_genre_response = supabase.table('genres').insert({'name': genre.name}).execute()

        if inserted_genre_response.data:
            genre_id = inserted_genre_response.data[0]['id']
        else:
            raise Exception(f"Failed to insert genre: {inserted_genre_response}")

    return genre_id

def link_book_genre(book_id, genre_id):
    # Check if the link between book and genre already exists
    existing_link_response = supabase.table('book_genres').select('*').eq('book_id', book_id).eq('genre_id', genre_id).execute()

    if not existing_link_response.data:
        # Link book to genre
        insert_response = supabase.table('book_genres').insert({
            'book_id': book_id,
            'genre_id': genre_id
        }).execute()
        
        if not insert_response.data:
            raise Exception(f"Failed to link book and genre: {insert_response}")
            
def insert_or_get_chapter_id(book_id, chapter_data):
    # Check if chapter exists
    existing_chapter_response = supabase.table('chapters').select('id').eq('number', chapter_data.number).eq('book_id', book_id).execute()

    if existing_chapter_response.data:
        chapter_id = existing_chapter_response.data[0]['id']
    else:
        # Insert new chapter
        inserted_chapter_response = supabase.table('chapters').insert({
            'number': chapter_data.number,
            'release': chapter_data.release,
            'book_id': book_id
        }).execute()

        if inserted_chapter_response.data:
            chapter_id = inserted_chapter_response.data[0]['id']
        else:
            raise Exception(f"Failed to insert chapter: {inserted_chapter_response}")

    return chapter_id

def insert_image_if_not_exists(chapter_id, image_data):
    # Check if image exists
    existing_image_response = supabase.table('images').select('id').eq('chapter_id', chapter_id).eq('number', image_data.number).execute()

    if not existing_image_response.data:
        # Insert new image
        inserted_image_response = supabase.table('images').insert({
            'url': image_data.url,
            'number': image_data.number,
            'chapter_id': chapter_id
        }).execute()

        if not inserted_image_response.data:
            raise Exception(f"Failed to insert image: {inserted_image_response}")
