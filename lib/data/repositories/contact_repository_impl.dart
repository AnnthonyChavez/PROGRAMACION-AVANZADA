import '../../domain/entities/contact.dart';
import '../datasources/contact_api.dart';

class ContactRepositoryImpl {
  final ContactAPI api;
  ContactRepositoryImpl(this.api);

  Future<List<Contact>> getContacts() => api.fetchContacts();
  Future<Contact> create(Contact contact) => api.createContact(contact);
  Future<Contact> update(Contact contact) => api.updateContact(contact);
  Future<void> delete(int id) => api.deleteContact(id);
}
