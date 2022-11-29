// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i31;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i54;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i56;

import '../../features/authentication/data/datasource/auth_repo_impl.dart'
    as _i99;
import '../../features/authentication/domain/repo/auth_repo.dart' as _i60;
import '../../features/authentication/domain/usecase/login_use_case.dart'
    as _i58;
import '../../features/authentication/domain/usecase/reset_password_use_case.dart'
    as _i82;
import '../../features/authentication/domain/usecase/sign_up_case.dart' as _i87;
import '../../features/authentication/domain/usecase/social_login_use_case.dart'
    as _i59;
import '../../features/authentication/presentation/bloc/login_cubit.dart'
    as _i57;
import '../../features/authentication/presentation/bloc/reset_password_cubit.dart'
    as _i81;
import '../../features/authentication/presentation/bloc/sign_up_cubit.dart'
    as _i86;
import '../../features/feed/data/datasource/feed_repo_impl.dart' as _i37;
import '../../features/feed/domain/repo/feed_repo.dart' as _i36;
import '../../features/feed/domain/usecase/create_post_use_case.dart' as _i24;
import '../../features/feed/domain/usecase/get_drawer_data_use_case.dart'
    as _i26;
import '../../features/feed/domain/usecase/get_feed_posts_use_case.dart'
    as _i33;
import '../../features/feed/domain/usecase/like_unlike_use_case.dart' as _i9;
import '../../features/feed/domain/usecase/repost_use_case.dart' as _i10;
import '../../features/feed/domain/usecase/save_notification_token_use_case.dart'
    as _i35;
import '../../features/feed/domain/usecase/upload_media_use_case.dart' as _i23;
import '../../features/feed/presentation/bloc/feed_cubit.dart' as _i32;
import '../../features/messages/data/repo_impl/message_repo_impl.dart' as _i63;
import '../../features/messages/domain/repo/message_repo.dart' as _i28;
import '../../features/messages/domain/usecase/delete_all_messages_use_case.dart'
    as _i19;
import '../../features/messages/domain/usecase/delete_messag_use_case.dart'
    as _i18;
import '../../features/messages/domain/usecase/get_chats_use_case.dart' as _i15;
import '../../features/messages/domain/usecase/get_messages_use_case.dart'
    as _i46;
import '../../features/messages/domain/usecase/search_chats_use_case.dart'
    as _i21;
import '../../features/messages/domain/usecase/send_chat_message_use_case.dart'
    as _i17;
import '../../features/messages/presentation/bloc/chat_cubit.dart' as _i14;
import '../../features/messages/presentation/bloc/message_cubit.dart' as _i62;
import '../../features/messages/presentation/chat_pagination.dart' as _i20;
import '../../features/notifications/data/repo_impl/notification_repo_impl.dart'
    as _i67;
import '../../features/notifications/domain/repo/notification_repo.dart'
    as _i30;
import '../../features/notifications/domain/usecase/delete_notification_use_case.dart'
    as _i29;
import '../../features/notifications/domain/usecase/get_notification_use_case.dart'
    as _i47;
import '../../features/notifications/presentation/bloc/notification_cubit.dart'
    as _i65;
import '../../features/notifications/presentation/pagination/mentions_pagination.dart'
    as _i61;
import '../../features/notifications/presentation/pagination/notification_pagination.dart'
    as _i66;
import '../../features/posts/data/post_repo_impl.dart' as _i73;
import '../../features/posts/domain/post_repo.dart' as _i4;
import '../../features/posts/domain/usecases/add_remove_bookmark_use_case.dart'
    as _i3;
import '../../features/posts/domain/usecases/delete_media_use_case.dart'
    as _i25;
import '../../features/posts/domain/usecases/delete_post_use_case.dart' as _i11;
import '../../features/posts/domain/usecases/get_followers_use_case.dart'
    as _i40;
import '../../features/posts/domain/usecases/get_likes_use_case.dart' as _i44;
import '../../features/posts/domain/usecases/get_threaded_post_use_case.dart'
    as _i52;
import '../../features/posts/domain/usecases/log_out_use_case.dart' as _i34;
import '../../features/posts/presentation/bloc/createpost_cubit.dart' as _i22;
import '../../features/posts/presentation/bloc/post_cubit.dart' as _i70;
import '../../features/posts/presentation/bloc/view_post_cubit.dart' as _i97;
import '../../features/posts/presentation/pagination/show_likes_pagination.dart'
    as _i72;
import '../../features/profile/data/datasource/profile_repo_impl.dart' as _i80;
import '../../features/profile/domain/repo/profile_repo.dart' as _i13;
import '../../features/profile/domain/usecase/change_language_use_case.dart'
    as _i12;
import '../../features/profile/domain/usecase/delete_account_use_case.dart'
    as _i27;
import '../../features/profile/domain/usecase/follow_unfollow_use_case.dart'
    as _i38;
import '../../features/profile/domain/usecase/get_bookmarks_use_case.dart'
    as _i8;
import '../../features/profile/domain/usecase/get_followers_use_case.dart'
    as _i43;
import '../../features/profile/domain/usecase/get_following_use_case.dart'
    as _i42;
import '../../features/profile/domain/usecase/get_login_mode.dart' as _i45;
import '../../features/profile/domain/usecase/get_profile_data_use_case.dart'
    as _i51;
import '../../features/profile/domain/usecase/get_profile_like_posts.dart'
    as _i48;
import '../../features/profile/domain/usecase/get_profile_media_posts.dart'
    as _i49;
import '../../features/profile/domain/usecase/get_profile_posts.dart' as _i50;
import '../../features/profile/domain/usecase/get_user_settings.dart' as _i53;
import '../../features/profile/domain/usecase/udpate_password_use_case.dart'
    as _i88;
import '../../features/profile/domain/usecase/update_privacy_setting_use_case.dart'
    as _i89;
import '../../features/profile/domain/usecase/update_profile_cover_use_case.dart'
    as _i75;
import '../../features/profile/domain/usecase/update_profile_setting_use_case.dart'
    as _i90;
import '../../features/profile/domain/usecase/uppdate_profile_avatar_use_case.dart'
    as _i76;
import '../../features/profile/domain/usecase/verify_user_account_use_case.dart'
    as _i96;
import '../../features/profile/presentation/bloc/bookmark_cubit.dart' as _i7;
import '../../features/profile/presentation/bloc/followers_following_cubit.dart'
    as _i98;
import '../../features/profile/presentation/bloc/profile_cubit.dart' as _i74;
import '../../features/profile/presentation/bloc/settings/user_setting_cubit.dart'
    as _i95;
import '../../features/profile/presentation/bloc/user_likes/user_likes_cubit.dart'
    as _i92;
import '../../features/profile/presentation/bloc/user_media/user_media_cubit.dart'
    as _i93;
import '../../features/profile/presentation/bloc/user_posts/user_post_cubit.dart'
    as _i94;
import '../../features/profile/presentation/pagination/followers/follower_pagination.dart'
    as _i39;
import '../../features/profile/presentation/pagination/following/following_pagination.dart'
    as _i41;
import '../../features/profile/presentation/pagination/likes/likes_pagination.dart'
    as _i77;
import '../../features/profile/presentation/pagination/media/media_pagination.dart'
    as _i78;
import '../../features/profile/presentation/pagination/posts/post_pagination.dart'
    as _i79;
import '../../features/search/data/repo_impl/search_repo_impl.dart' as _i85;
import '../../features/search/domain/repo/search_repo.dart' as _i84;
import '../../features/search/domain/usecase/search_hastag_use_case.dart'
    as _i55;
import '../../features/search/domain/usecase/search_people_use_case.dart'
    as _i69;
import '../../features/search/domain/usecase/search_post_use_case.dart' as _i71;
import '../../features/search/presentation/bloc/search_cubit.dart' as _i83;
import '../../features/search/presentation/pagination/hashtag_pagination.dart'
    as _i16;
import '../../features/search/presentation/pagination/people_pagination.dart'
    as _i68;
import '../common/api/api_helper.dart' as _i5;
import '../common/api/upload_manager.dart' as _i91;
import '../common/social_share/social_share.dart' as _i64;
import '../datasource/local_data_source.dart' as _i6;
import 'register_module.dart' as _i100; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i3.AddOrRemoveBookmarkUseCase>(
      () => _i3.AddOrRemoveBookmarkUseCase(get<_i4.PostRepo>()));
  gh.factory<_i5.ApiHelper>(() => _i5.ApiHelper(get<_i6.LocalDataSource>()));
  gh.factory<_i7.BookmarkCubit>(() => _i7.BookmarkCubit(
      get<_i8.GetBookmarksUseCase>(),
      get<_i3.AddOrRemoveBookmarkUseCase>(),
      get<_i9.LikeUnlikeUseCase>(),
      get<_i10.RepostUseCase>(),
      get<_i11.DeletePostUseCase>()));
  gh.factory<_i12.ChangeLanguageUseCase>(
      () => _i12.ChangeLanguageUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i14.ChatCubit>(() => _i14.ChatCubit(
      get<_i15.GetChatUseCase>(),
      get<_i16.HashTagPagination>(),
      get<_i17.SendChatMessageUseCase>(),
      get<_i18.DeleteMessageUseCase>(),
      get<_i19.DeleteAllMessagesUseCase>(),
      get<_i20.ChatPagination>()));
  gh.factory<_i20.ChatPagination>(() => _i20.ChatPagination(
      get<_i15.GetChatUseCase>(), get<_i21.SearchChatUseCase>()));
  gh.factory<_i22.CreatePostCubit>(() => _i22.CreatePostCubit(
      get<_i23.UploadMediaUseCase>(),
      get<_i24.CreatePostUseCase>(),
      get<_i25.DeleteMediaUseCase>(),
      get<_i26.GetDrawerDataUseCase>()));
  gh.factory<_i24.CreatePostUseCase>(
      () => _i24.CreatePostUseCase(get<_i4.PostRepo>()));
  gh.factory<_i27.DeleteAccountUseCase>(
      () => _i27.DeleteAccountUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i19.DeleteAllMessagesUseCase>(
      () => _i19.DeleteAllMessagesUseCase(get<_i28.MessageRepo>()));
  gh.factory<_i25.DeleteMediaUseCase>(
      () => _i25.DeleteMediaUseCase(get<_i4.PostRepo>()));
  gh.factory<_i18.DeleteMessageUseCase>(
      () => _i18.DeleteMessageUseCase(get<_i28.MessageRepo>()));
  gh.factory<_i29.DeleteNotificationUseCase>(
      () => _i29.DeleteNotificationUseCase(get<_i30.NotificationRepo>()));
  gh.factory<_i11.DeletePostUseCase>(
      () => _i11.DeletePostUseCase(get<_i4.PostRepo>()));
  gh.lazySingleton<_i31.Dio>(() => registerModule.dio);
  gh.factory<_i32.FeedCubit>(() => _i32.FeedCubit(
      get<_i33.GetFeedPostUseCase>(),
      get<_i26.GetDrawerDataUseCase>(),
      get<_i23.UploadMediaUseCase>(),
      get<_i24.CreatePostUseCase>(),
      get<_i9.LikeUnlikeUseCase>(),
      get<_i25.DeleteMediaUseCase>(),
      get<_i10.RepostUseCase>(),
      get<_i3.AddOrRemoveBookmarkUseCase>(),
      get<_i11.DeletePostUseCase>(),
      get<_i34.LogOutUseCase>(),
      get<_i35.SaveNotificationPushUseCase>()));
  gh.factory<_i36.FeedRepo>(() =>
      _i37.FeedRepoImpl(get<_i5.ApiHelper>(), get<_i6.LocalDataSource>()));
  gh.factory<_i38.FollowUnFollowUseCase>(
      () => _i38.FollowUnFollowUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i39.FollowerPagination>(
      () => _i39.FollowerPagination(get<_i40.GetFollowersUseCase>()));
  gh.factory<_i41.FollowingPagination>(
      () => _i41.FollowingPagination(get<_i42.GetFollowingUseCase>()));
  gh.factory<_i8.GetBookmarksUseCase>(
      () => _i8.GetBookmarksUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i15.GetChatUseCase>(
      () => _i15.GetChatUseCase(get<_i28.MessageRepo>()));
  gh.factory<_i26.GetDrawerDataUseCase>(
      () => _i26.GetDrawerDataUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i33.GetFeedPostUseCase>(
      () => _i33.GetFeedPostUseCase(get<_i36.FeedRepo>()));
  gh.factory<_i40.GetFollowersUseCase>(
      () => _i40.GetFollowersUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i43.GetFollowersUseCase>(
      () => _i43.GetFollowersUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i42.GetFollowingUseCase>(
      () => _i42.GetFollowingUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i44.GetLikesUseCase>(
      () => _i44.GetLikesUseCase(get<_i4.PostRepo>()));
  gh.factory<_i45.GetLoginMode>(
      () => _i45.GetLoginMode(get<_i13.ProfileRepo>()));
  gh.factory<_i46.GetMessagesUseCase>(
      () => _i46.GetMessagesUseCase(get<_i28.MessageRepo>()));
  gh.factory<_i47.GetNotificationUseCase>(
      () => _i47.GetNotificationUseCase(get<_i30.NotificationRepo>()));
  gh.factory<_i48.GetProfileLikedPostsUseCase>(
      () => _i48.GetProfileLikedPostsUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i49.GetProfileMediaUseCase>(
      () => _i49.GetProfileMediaUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i50.GetProfilePostsUseCase>(
      () => _i50.GetProfilePostsUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i51.GetProfileUseCase>(
      () => _i51.GetProfileUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i52.GetThreadedPostUseCase>(
      () => _i52.GetThreadedPostUseCase(get<_i4.PostRepo>()));
  gh.factory<_i53.GetUserSettingsUseCase>(
      () => _i53.GetUserSettingsUseCase(get<_i13.ProfileRepo>()));
  gh.lazySingleton<_i54.GoogleSignIn>(() => registerModule.googleLogin);
  gh.factory<_i16.HashTagPagination>(
      () => _i16.HashTagPagination(get<_i55.SearchHashtagsUseCase>()));
  gh.factory<_i9.LikeUnlikeUseCase>(
      () => _i9.LikeUnlikeUseCase(get<_i4.PostRepo>()));
  gh.factory<_i6.LocalDataSource>(() =>
      _i6.LocalDataSourceImpl(get<_i31.Dio>(), get<_i56.SharedPreferences>()));
  gh.factory<_i34.LogOutUseCase>(
      () => _i34.LogOutUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i57.LoginCubit>(() => _i57.LoginCubit(get<_i6.LocalDataSource>(),
      get<_i58.LoginUseCase>(), get<_i59.SocialLoginUseCase>()));
  gh.factory<_i58.LoginUseCase>(() => _i58.LoginUseCase(get<_i60.AuthRepo>()));
  gh.factory<_i61.MentionsPagination>(() => _i61.MentionsPagination(
      get<_i47.GetNotificationUseCase>(),
      get<_i29.DeleteNotificationUseCase>()));
  gh.factory<_i62.MessageCubit>(() => _i62.MessageCubit(
      get<_i46.GetMessagesUseCase>(), get<_i19.DeleteAllMessagesUseCase>()));
  gh.factory<_i28.MessageRepo>(() =>
      _i63.MessageRepoImpl(get<_i5.ApiHelper>(), get<_i6.LocalDataSource>()));
  gh.factory<_i64.MySocialShare>(() => _i64.MySocialShare());
  gh.factory<_i65.NotificationCubit>(() => _i65.NotificationCubit(
      get<_i66.NotificationPagination>(), get<_i61.MentionsPagination>()));
  gh.factory<_i66.NotificationPagination>(() => _i66.NotificationPagination(
      get<_i47.GetNotificationUseCase>(),
      get<_i29.DeleteNotificationUseCase>()));
  gh.factory<_i30.NotificationRepo>(
      () => _i67.NotificationRepoImpl(get<_i5.ApiHelper>()));
  gh.factory<_i68.PeoplePagination>(
      () => _i68.PeoplePagination(get<_i69.SearchPeopleUseCase>()));
  gh.factory<_i70.PostCubit>(() => _i70.PostCubit(
      get<_i3.AddOrRemoveBookmarkUseCase>(),
      get<_i9.LikeUnlikeUseCase>(),
      get<_i10.RepostUseCase>(),
      get<_i11.DeletePostUseCase>(),
      get<_i71.SearchPostUseCase>(),
      get<_i72.ShowLikesPagination>()));
  gh.factory<_i4.PostRepo>(() =>
      _i73.PostRepoImpl(get<_i5.ApiHelper>(), get<_i6.LocalDataSource>()));
  gh.factory<_i74.ProfileCubit>(() => _i74.ProfileCubit(
      get<_i51.GetProfileUseCase>(),
      get<_i38.FollowUnFollowUseCase>(),
      get<_i34.LogOutUseCase>(),
      get<_i75.UpdateProfileCoverUseCase>(),
      get<_i76.UpdateAvatarProfileUseCase>()));
  gh.factory<_i77.ProfileLikesPagination>(() =>
      _i77.ProfileLikesPagination(get<_i48.GetProfileLikedPostsUseCase>()));
  gh.factory<_i78.ProfileMediaPagination>(
      () => _i78.ProfileMediaPagination(get<_i49.GetProfileMediaUseCase>()));
  gh.factory<_i79.ProfilePostPagination>(
      () => _i79.ProfilePostPagination(get<_i50.GetProfilePostsUseCase>()));
  gh.factory<_i13.ProfileRepo>(() => _i80.ProfileRepoImpl(get<_i5.ApiHelper>(),
      get<_i6.LocalDataSource>(), get<_i54.GoogleSignIn>()));
  gh.factory<_i10.RepostUseCase>(() => _i10.RepostUseCase(get<_i4.PostRepo>()));
  gh.factory<_i81.ResetPasswordCubit>(
      () => _i81.ResetPasswordCubit(get<_i82.ResetPasswordUseCase>()));
  gh.factory<_i82.ResetPasswordUseCase>(
      () => _i82.ResetPasswordUseCase(get<_i60.AuthRepo>()));
  gh.factory<_i35.SaveNotificationPushUseCase>(
      () => _i35.SaveNotificationPushUseCase(get<_i36.FeedRepo>()));
  gh.factory<_i21.SearchChatUseCase>(
      () => _i21.SearchChatUseCase(get<_i28.MessageRepo>()));
  gh.factory<_i83.SearchCubit>(() => _i83.SearchCubit(
      get<_i16.HashTagPagination>(),
      get<_i68.PeoplePagination>(),
      get<_i38.FollowUnFollowUseCase>()));
  gh.factory<_i55.SearchHashtagsUseCase>(
      () => _i55.SearchHashtagsUseCase(get<_i84.SearchRepo>()));
  gh.factory<_i69.SearchPeopleUseCase>(
      () => _i69.SearchPeopleUseCase(get<_i84.SearchRepo>()));
  gh.factory<_i71.SearchPostUseCase>(
      () => _i71.SearchPostUseCase(get<_i84.SearchRepo>()));
  gh.factory<_i84.SearchRepo>(() => _i85.SearchRepoImpl(get<_i5.ApiHelper>()));
  gh.factory<_i17.SendChatMessageUseCase>(
      () => _i17.SendChatMessageUseCase(get<_i28.MessageRepo>()));
  await gh.factoryAsync<_i56.SharedPreferences>(() => registerModule.storage,
      preResolve: true);
  gh.factory<_i72.ShowLikesPagination>(() => _i72.ShowLikesPagination(
      get<_i44.GetLikesUseCase>(), get<_i38.FollowUnFollowUseCase>()));
  gh.factory<_i86.SignUpCubit>(() => _i86.SignUpCubit(
      get<_i87.SignUpUseCase>(), get<_i59.SocialLoginUseCase>()));
  gh.factory<_i87.SignUpUseCase>(
      () => _i87.SignUpUseCase(get<_i60.AuthRepo>()));
  gh.factory<_i59.SocialLoginUseCase>(
      () => _i59.SocialLoginUseCase(get<_i60.AuthRepo>()));
  gh.factory<_i76.UpdateAvatarProfileUseCase>(
      () => _i76.UpdateAvatarProfileUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i88.UpdatePasswordUseCase>(
      () => _i88.UpdatePasswordUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i89.UpdatePrivacyUseCase>(
      () => _i89.UpdatePrivacyUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i75.UpdateProfileCoverUseCase>(
      () => _i75.UpdateProfileCoverUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i90.UpdateUserSettingsUseCase>(
      () => _i90.UpdateUserSettingsUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i91.UploadManager>(
      () => _i91.UploadManager(get<_i6.LocalDataSource>()));
  gh.factory<_i23.UploadMediaUseCase>(
      () => _i23.UploadMediaUseCase(get<_i4.PostRepo>()));
  gh.factory<_i92.UserLikesCubit>(() => _i92.UserLikesCubit(
      get<_i3.AddOrRemoveBookmarkUseCase>(),
      get<_i9.LikeUnlikeUseCase>(),
      get<_i10.RepostUseCase>(),
      get<_i11.DeletePostUseCase>(),
      get<_i71.SearchPostUseCase>(),
      get<_i48.GetProfileLikedPostsUseCase>(),
      get<_i72.ShowLikesPagination>()));
  gh.factory<_i93.UserMediaCubit>(() => _i93.UserMediaCubit(
      get<_i3.AddOrRemoveBookmarkUseCase>(),
      get<_i9.LikeUnlikeUseCase>(),
      get<_i10.RepostUseCase>(),
      get<_i11.DeletePostUseCase>(),
      get<_i71.SearchPostUseCase>(),
      get<_i72.ShowLikesPagination>(),
      get<_i49.GetProfileMediaUseCase>()));
  gh.factory<_i94.UserPostCubit>(() => _i94.UserPostCubit(
      get<_i3.AddOrRemoveBookmarkUseCase>(),
      get<_i9.LikeUnlikeUseCase>(),
      get<_i10.RepostUseCase>(),
      get<_i11.DeletePostUseCase>(),
      get<_i71.SearchPostUseCase>(),
      get<_i72.ShowLikesPagination>(),
      get<_i50.GetProfilePostsUseCase>()));
  gh.factory<_i95.UserSettingCubit>(() => _i95.UserSettingCubit(
      get<_i53.GetUserSettingsUseCase>(),
      get<_i90.UpdateUserSettingsUseCase>(),
      get<_i88.UpdatePasswordUseCase>(),
      get<_i89.UpdatePrivacyUseCase>(),
      get<_i27.DeleteAccountUseCase>(),
      get<_i96.VerifyUserAccountUseCase>(),
      get<_i12.ChangeLanguageUseCase>(),
      get<_i45.GetLoginMode>()));
  gh.factory<_i96.VerifyUserAccountUseCase>(
      () => _i96.VerifyUserAccountUseCase(get<_i13.ProfileRepo>()));
  gh.factory<_i97.ViewPostCubit>(() => _i97.ViewPostCubit(
      get<_i52.GetThreadedPostUseCase>(),
      get<_i24.CreatePostUseCase>(),
      get<_i9.LikeUnlikeUseCase>(),
      get<_i10.RepostUseCase>(),
      get<_i3.AddOrRemoveBookmarkUseCase>(),
      get<_i11.DeletePostUseCase>()));
  gh.factory<_i98.FollowersFollowingCubit>(() => _i98.FollowersFollowingCubit(
      get<_i39.FollowerPagination>(),
      get<_i41.FollowingPagination>(),
      get<_i38.FollowUnFollowUseCase>(),
      get<_i51.GetProfileUseCase>()));
  gh.singleton<_i60.AuthRepo>(_i99.AuthRepoImpl(get<_i5.ApiHelper>(),
      get<_i54.GoogleSignIn>(), get<_i6.LocalDataSource>()));
  return get;
}

class _$RegisterModule extends _i100.RegisterModule {}
