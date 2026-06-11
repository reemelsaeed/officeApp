import 'package:office_application/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authservices {
  final supabase = Supabase.instance.client;

  /////////////for admin to create user////////////////////
  Future<void> createUser(
    String name,
    String email,
    String password,
    userRole role,
  ) async {
    final response = await supabase.auth.admin.createUser(
      AdminUserAttributes(email: email, password: password),
    );
    await supabase.from('users_profile').insert({
      'id': response.user!.id,
      'name': name,
      'role': role.name,
    });
  }

  ///////////////////////////////////////////////////////////////////////////
  ///login
  Future<void> login(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  //////////////////////////////////////////////////////////
  ///get user
  Future<UserModel?> getCurrentUser() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return null;

    final data = await supabase
        .from('users_profile')
        .select()
        .eq('id', authUser.id)
        .single();

    return UserModel.fromMap(data);
  }

  //////////////////////////////////////////////////////////////////
  ///changepassword
  Future<void> changePassword(String newPassword) async {
    await supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  //////////////////////////////////////////////////////////////////
  ///changeName
  Future<void> changeName(String newName) async {
    final id = supabase.auth.currentUser!.id;
    await supabase.from('users_profile').update({'name': newName}).eq('id', id);
  }

  ///////////////////////////////////////////////////////////
  ///getAllUsers
  Future<List<UserModel>> getAllUsers() async {
    final data = await supabase.from('users_profile').select();
    return data.map((map) => UserModel.fromMap(map)).toList();
  }

  /////////////////////////////////////////////////
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  //////////////////////////////////////////////////
  Future<void> deleteUser(String id) async {
    await supabase.auth.admin.deleteUser(id);
    await supabase.from('users_profile').delete().eq('id', id);
  }
}
