import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/contact.dart';
import '../../data/datasources/contact_api.dart';
import '../../data/repositories/contact_repository_impl.dart';
import '../../application/usecases/contact_usecase.dart';

final contactProvider = StateNotifierProvider<ContactNotifier, AsyncValue<List<Contact>>>((ref) {
  return ContactNotifier();
});

class ContactNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  final ContactUseCases useCases = ContactUseCases(ContactRepositoryImpl(ContactAPI()));
  ContactNotifier() : super(const AsyncValue.loading()) {
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    try {
      final contacts = await useCases.fetchAll();
      state = AsyncValue.data(contacts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addContact(Contact contact) async {
    await useCases.create(contact);
    await fetchContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await useCases.update(contact);
    await fetchContacts();
  }

  Future<void> deleteContact(int id) async {
    await useCases.delete(id);
    await fetchContacts();
  }
}
