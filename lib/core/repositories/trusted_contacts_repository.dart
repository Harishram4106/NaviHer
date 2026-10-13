import '../models/trusted_contact_model.dart';

abstract class TrustedContactsRepository {
  Future<List<TrustedContact>> getContacts(String userId);
  Future<TrustedContact> addContact(TrustedContact contact);
  Future<void> updateContact(TrustedContact contact);
  Future<void> deleteContact(String contactId);
}
