import 'package:biskychat_aug23/apis/friends_api.dart';
import 'package:biskychat_aug23/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsController extends StateNotifier<List<UserModel>> {
  final FriendsApi _friendsApi;
  FriendsController({required FriendsApi friendsApi})
      : _friendsApi = friendsApi,
        super([]);

  UserModel getUserById({required String uId}) {
    return state.firstWhere((element) => element.uid == uId);
  }

  Future<void> getAllFriends({required String currentUserId}) async {
    final documents =
        await _friendsApi.getAllFriends(currentUserId: currentUserId);

    documents.documents
        .map(
          (e) => state.add(
            UserModel(
              uid: e.$id,
              name: e.data['name'],
              imageUrl: e.data['imageUrl'],
            ),
          ),
        )
        .toList();

    final newList = state.toSet().toList();
    state = newList;
  }
}
// -----------------------------------------------------------------------------

final friendsControllerProvider =
    StateNotifierProvider<FriendsController, List<UserModel>>((ref) {
  final friendsApi = ref.watch(friendsApiProvider);
  return FriendsController(friendsApi: friendsApi);
});
