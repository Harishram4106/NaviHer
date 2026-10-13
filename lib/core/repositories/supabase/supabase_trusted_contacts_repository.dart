import 'package:supabase_flutter/supabase_flutter.dart';
import '../../errors/app_exceptions.dart';
import '../../models/trusted_contact_model.dart';
import '../trusted_contacts_repository.dart';

class SupabaseTrustedContactsRepository implements TrustedContactsRepository {
  final SupabaseClient _client;

  SupabaseTrustedContactsRepository(this._client);

  @override
  Future<List<TrustedContact>> getContacts(String userId) async {
    try {
      final response = await _client
          .from('trusted_contacts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
          
      return (response as List).map((json) => TrustedContact.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }

  @override
  Future<TrustedContact> addContact(TrustedContact contact) async {
    try {
      final response = await _client
          .from('trusted_contacts')
          .insert(contact.toJson()..remove('id')) // Let DB generate ID
          .select()
          .single();
      return TrustedContact.fromJson(response);
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }

  @override
  Future<void> updateContact(TrustedContact contact) async {
    try {
      await _client
          .from('trusted_contacts')
          .update(contact.toJson())
          .eq('id', contact.id);
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }

  @override
  Future<void> deleteContact(String contactId) async {
    try {
      await _client.from('trusted_contacts').delete().eq('id', contactId);
    } on PostgrestException catch (e) {
      throw BackendException(e.message, code: e.code, details: e.details);
    } catch (e) {
      throw BackendException('An unexpected error occurred.', details: e);
    }
  }
}
