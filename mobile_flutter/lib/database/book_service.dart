import 'package:supabase_flutter/supabase_flutter.dart';

class BookService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> getAllBooks() async {
    final data = await supabase.rpc('get_all_books_with_details').select();
    return data.map((e) => e).toList();
  }

  Future<List<String>> fetchGenres() async {
    final data = await supabase.from('genres').select('name');
    return (data as List<dynamic>).map((e) => e['name'] as String).toList();
  }

  Future<List<String>> fetchAuthors() async {
    final data = await supabase.from('authors').select('first_name, last_name');
    return (data as List<dynamic>)
        .map((e) => '${e['first_name']} ${e['last_name']}')
        .toList();
  }
}
