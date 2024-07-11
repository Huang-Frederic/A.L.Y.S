import 'package:supabase_flutter/supabase_flutter.dart';

class BookService {
  // Get a reference your Supabase client
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> getAllBooks() async {
    final data = await supabase.rpc('get_all_books_with_details').select();
    print("ARA");
    return data as List<dynamic>;
  }
}
