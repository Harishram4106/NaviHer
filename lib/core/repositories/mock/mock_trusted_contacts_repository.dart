import 'package:uuid/uuid.dart';
import '../../models/trusted_contact_model.dart';
import '../trusted_contacts_repository.dart';

class MockTrustedContactsRepository implements TrustedContactsRepository {
  final List<TrustedContact> _contacts = [
    const TrustedContact(
      id: 'contact_1',
      userId: 'mock_user_123',
      name: 'Mom',
      phoneNumber: '+1234567890',
    ),
    const TrustedContact(
      id: 'contact_2',
      userId: 'mock_user_123',
      name: 'Emma',
      phoneNumber: '+0987654321',
    ),
  ];

  @override
  Future<List<TrustedContact>> getContacts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _contacts.where((c) => c.userId == userId).toList();
  }

  @override
  Future<TrustedContact> addContact(TrustedContact contact) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newContact = TrustedContact(
      id: const Uuid().v4(),
      userId: contact.userId,
      name: contact.name,
      phoneNumber: contact.phoneNumber,
      isActive: contact.isActive,
    );
    _contacts.add(newContact);
    return newContact;
  }

  @override
  Future<void> updateContact(TrustedContact contact) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
    }
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _contacts.removeWhere((c) => c.id == contactId);
  }
}
