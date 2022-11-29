// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:colibri/core/common/api/api_helper.dart' as _i5;
import 'package:colibri/core/common/api/upload_manager.dart' as _i92;
import 'package:colibri/core/common/social_share/social_share.dart' as _i65;
import 'package:colibri/core/datasource/local_data_source.dart' as _i6;
import 'package:colibri/core/di/register_module.dart' as _i100;
import 'package:colibri/features/authentication/data/datasource/auth_repo_impl.dart'
    as _i8;
import 'package:colibri/features/authentication/domain/repo/auth_repo.dart'
    as _i7;
import 'package:colibri/features/authentication/domain/usecase/login_use_case.dart'
    as _i60;
import 'package:colibri/features/authentication/domain/usecase/reset_password_use_case.dart'
    as _i83;
import 'package:colibri/features/authentication/domain/usecase/sign_up_case.dart'
    as _i88;
import 'package:colibri/features/authentication/domain/usecase/social_login_use_case.dart'
    as _i61;
import 'package:colibri/features/authentication/presentation/bloc/login_cubit.dart'
    as _i59;
import 'package:colibri/features/authentication/presentation/bloc/reset_password_cubit.dart'
    as _i82;
import 'package:colibri/features/authentication/presentation/bloc/sign_up_cubit.dart'
    as _i87;
import 'package:colibri/features/feed/data/datasource/feed_repo_impl.dart'
    as _i41;
import 'package:colibri/features/feed/domain/repo/feed_repo.dart' as _i40;
import 'package:colibri/features/feed/domain/usecase/create_post_use_case.dart'
    as _i27;
import 'package:colibri/features/feed/domain/usecase/get_drawer_data_use_case.dart'
    as _i29;
import 'package:colibri/features/feed/domain/usecase/get_feed_posts_use_case.dart'
    as _i37;
import 'package:colibri/features/feed/domain/usecase/like_unlike_use_case.dart'
    as _i13;
import 'package:colibri/features/feed/domain/usecase/repost_use_case.dart'
    as _i14;
import 'package:colibri/features/feed/domain/usecase/save_notification_token_use_case.dart'
    as _i39;
import 'package:colibri/features/feed/domain/usecase/upload_media_use_case.dart'
    as _i26;
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart'
    as _i36;
import 'package:colibri/features/messages/data/repo_impl/message_repo_impl.dart'
    as _i64;
import 'package:colibri/features/messages/domain/repo/message_repo.dart'
    as _i32;
import 'package:colibri/features/messages/domain/usecase/delete_all_messages_use_case.dart'
    as _i22;
import 'package:colibri/features/messages/domain/usecase/delete_messag_use_case.dart'
    as _i21;
import 'package:colibri/features/messages/domain/usecase/get_chats_use_case.dart'
    as _i18;
import 'package:colibri/features/messages/domain/usecase/get_messages_use_case.dart'
    as _i49;
import 'package:colibri/features/messages/domain/usecase/search_chats_use_case.dart'
    as _i24;
import 'package:colibri/features/messages/domain/usecase/send_chat_message_use_case.dart'
    as _i20;
import 'package:colibri/features/messages/presentation/bloc/chat_cubit.dart'
    as _i17;
import 'package:colibri/features/messages/presentation/bloc/message_cubit.dart'
    as _i63;
import 'package:colibri/features/messages/presentation/chat_pagination.dart'
    as _i23;
import 'package:colibri/features/notifications/data/repo_impl/notification_repo_impl.dart'
    as _i68;
import 'package:colibri/features/notifications/domain/repo/notification_repo.dart'
    as _i34;
import 'package:colibri/features/notifications/domain/usecase/delete_notification_use_case.dart'
    as _i33;
import 'package:colibri/features/notifications/domain/usecase/get_notification_use_case.dart'
    as _i50;
import 'package:colibri/features/notifications/presentation/bloc/notification_cubit.dart'
    as _i66;
import 'package:colibri/features/notifications/presentation/pagination/mentions_pagination.dart'
    as _i62;
import 'package:colibri/features/notifications/presentation/pagination/notification_pagination.dart'
    as _i67;
import 'package:colibri/features/posts/data/post_repo_impl.dart' as _i74;
import 'package:colibri/features/posts/domain/post_repo.dart' as _i30;
import 'package:colibri/features/posts/domain/usecases/add_remove_bookmark_use_case.dart'
    as _i12;
import 'package:colibri/features/posts/domain/usecases/delete_media_use_case.dart'
    as _i28;
import 'package:colibri/features/posts/domain/usecases/delete_post_use_case.dart'
    as _i15;
import 'package:colibri/features/posts/domain/usecases/get_followers_use_case.dart'
    as _i44;
import 'package:colibri/features/posts/domain/usecases/get_likes_use_case.dart'
    as _i48;
import 'package:colibri/features/posts/domain/usecases/get_threaded_post_use_case.dart'
    as _i55;
import 'package:colibri/features/posts/domain/usecases/log_out_use_case.dart'
    as _i38;
import 'package:colibri/features/posts/presentation/bloc/createpost_cubit.dart'
    as _i25;
import 'package:colibri/features/posts/presentation/bloc/post_cubit.dart'
    as _i71;
import 'package:colibri/features/posts/presentation/bloc/view_post_cubit.dart'
    as _i98;
import 'package:colibri/features/posts/presentation/pagination/show_likes_pagination.dart'
    as _i73;
import 'package:colibri/features/profile/data/datasource/profile_repo_impl.dart'
    as _i99;
import 'package:colibri/features/profile/domain/repo/profile_repo.dart' as _i4;
import 'package:colibri/features/profile/domain/usecase/change_language_use_case.dart'
    as _i16;
import 'package:colibri/features/profile/domain/usecase/delete_account_use_case.dart'
    as _i31;
import 'package:colibri/features/profile/domain/usecase/follow_unfollow_use_case.dart'
    as _i42;
import 'package:colibri/features/profile/domain/usecase/get_bookmarks_use_case.dart'
    as _i11;
import 'package:colibri/features/profile/domain/usecase/get_followers_use_case.dart'
    as _i47;
import 'package:colibri/features/profile/domain/usecase/get_following_use_case.dart'
    as _i46;
import 'package:colibri/features/profile/domain/usecase/get_login_mode.dart'
    as _i3;
import 'package:colibri/features/profile/domain/usecase/get_profile_data_use_case.dart'
    as _i54;
import 'package:colibri/features/profile/domain/usecase/get_profile_like_posts.dart'
    as _i51;
import 'package:colibri/features/profile/domain/usecase/get_profile_media_posts.dart'
    as _i52;
import 'package:colibri/features/profile/domain/usecase/get_profile_posts.dart'
    as _i53;
import 'package:colibri/features/profile/domain/usecase/get_user_settings.dart'
    as _i56;
import 'package:colibri/features/profile/domain/usecase/udpate_password_use_case.dart'
    as _i89;
import 'package:colibri/features/profile/domain/usecase/update_privacy_setting_use_case.dart'
    as _i90;
import 'package:colibri/features/profile/domain/usecase/update_profile_cover_use_case.dart'
    as _i76;
import 'package:colibri/features/profile/domain/usecase/update_profile_setting_use_case.dart'
    as _i91;
import 'package:colibri/features/profile/domain/usecase/uppdate_profile_avatar_use_case.dart'
    as _i77;
import 'package:colibri/features/profile/domain/usecase/verify_user_account_use_case.dart'
    as _i97;
import 'package:colibri/features/profile/presentation/bloc/bookmark_cubit.dart'
    as _i10;
import 'package:colibri/features/profile/presentation/bloc/followers_following_cubit.dart'
    as _i81;
import 'package:colibri/features/profile/presentation/bloc/profile_cubit.dart'
    as _i75;
import 'package:colibri/features/profile/presentation/bloc/settings/user_setting_cubit.dart'
    as _i96;
import 'package:colibri/features/profile/presentation/bloc/user_likes/user_likes_cubit.dart'
    as _i93;
import 'package:colibri/features/profile/presentation/bloc/user_media/user_media_cubit.dart'
    as _i94;
import 'package:colibri/features/profile/presentation/bloc/user_posts/user_post_cubit.dart'
    as _i95;
import 'package:colibri/features/profile/presentation/pagination/followers/follower_pagination.dart'
    as _i43;
import 'package:colibri/features/profile/presentation/pagination/following/following_pagination.dart'
    as _i45;
import 'package:colibri/features/profile/presentation/pagination/likes/likes_pagination.dart'
    as _i78;
import 'package:colibri/features/profile/presentation/pagination/media/media_pagination.dart'
    as _i79;
import 'package:colibri/features/profile/presentation/pagination/posts/post_pagination.dart'
    as _i80;
import 'package:colibri/features/search/data/repo_impl/search_repo_impl.dart'
    as _i86;
import 'package:colibri/features/search/domain/repo/search_repo.dart' as _i85;
import 'package:colibri/features/search/domain/usecase/search_hastag_use_case.dart'
    as _i57;
import 'package:colibri/features/search/domain/usecase/search_people_use_case.dart'
    as _i70;
import 'package:colibri/features/search/domain/usecase/search_post_use_case.dart'
    as _i72;
import 'package:colibri/features/search/presentation/bloc/search_cubit.dart'
    as _i84;
import 'package:colibri/features/search/presentation/pagination/hashtag_pagination.dart'
    as _i19;
import 'package:colibri/features/search/presentation/pagination/people_pagination.dart'
    as _i69;
import 'package:dio/dio.dart' as _i35;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i9;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i58;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.GetLoginMode>(() => _i3.GetLoginMode(gh<_i4.ProfileRepo>()));
    gh.factory<_i5.ApiHelper>(() => _i5.ApiHelper(gh<_i6.LocalDataSource>()));
    gh.singleton<_i7.AuthRepo>(_i8.AuthRepoImpl(
      gh<_i5.ApiHelper>(),
      gh<_i9.GoogleSignIn>(),
      gh<_i6.LocalDataSource>(),
    ));
    gh.factory<_i10.BookmarkCubit>(() => _i10.BookmarkCubit(
          gh<_i11.GetBookmarksUseCase>(),
          gh<_i12.AddOrRemoveBookmarkUseCase>(),
          gh<_i13.LikeUnlikeUseCase>(),
          gh<_i14.RepostUseCase>(),
          gh<_i15.DeletePostUseCase>(),
        ));
    gh.factory<_i16.ChangeLanguageUseCase>(
        () => _i16.ChangeLanguageUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i17.ChatCubit>(() => _i17.ChatCubit(
          gh<_i18.GetChatUseCase>(),
          gh<_i19.HashTagPagination>(),
          gh<_i20.SendChatMessageUseCase>(),
          gh<_i21.DeleteMessageUseCase>(),
          gh<_i22.DeleteAllMessagesUseCase>(),
          gh<_i23.ChatPagination>(),
        ));
    gh.factory<_i23.ChatPagination>(() => _i23.ChatPagination(
          gh<_i18.GetChatUseCase>(),
          gh<_i24.SearchChatUseCase>(),
        ));
    gh.factory<_i25.CreatePostCubit>(() => _i25.CreatePostCubit(
          gh<_i26.UploadMediaUseCase>(),
          gh<_i27.CreatePostUseCase>(),
          gh<_i28.DeleteMediaUseCase>(),
          gh<_i29.GetDrawerDataUseCase>(),
        ));
    gh.factory<_i27.CreatePostUseCase>(
        () => _i27.CreatePostUseCase(gh<_i30.PostRepo>()));
    gh.factory<_i31.DeleteAccountUseCase>(
        () => _i31.DeleteAccountUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i22.DeleteAllMessagesUseCase>(
        () => _i22.DeleteAllMessagesUseCase(gh<_i32.MessageRepo>()));
    gh.factory<_i28.DeleteMediaUseCase>(
        () => _i28.DeleteMediaUseCase(gh<_i30.PostRepo>()));
    gh.factory<_i21.DeleteMessageUseCase>(
        () => _i21.DeleteMessageUseCase(gh<_i32.MessageRepo>()));
    gh.factory<_i33.DeleteNotificationUseCase>(
        () => _i33.DeleteNotificationUseCase(gh<_i34.NotificationRepo>()));
    gh.factory<_i15.DeletePostUseCase>(
        () => _i15.DeletePostUseCase(gh<_i30.PostRepo>()));
    gh.lazySingleton<_i35.Dio>(() => registerModule.dio);
    gh.factory<_i36.FeedCubit>(() => _i36.FeedCubit(
          gh<_i37.GetFeedPostUseCase>(),
          gh<_i29.GetDrawerDataUseCase>(),
          gh<_i26.UploadMediaUseCase>(),
          gh<_i27.CreatePostUseCase>(),
          gh<_i13.LikeUnlikeUseCase>(),
          gh<_i28.DeleteMediaUseCase>(),
          gh<_i14.RepostUseCase>(),
          gh<_i12.AddOrRemoveBookmarkUseCase>(),
          gh<_i15.DeletePostUseCase>(),
          gh<_i38.LogOutUseCase>(),
          gh<_i39.SaveNotificationPushUseCase>(),
        ));
    gh.factory<_i40.FeedRepo>(() => _i41.FeedRepoImpl(
          gh<_i5.ApiHelper>(),
          gh<_i6.LocalDataSource>(),
        ));
    gh.factory<_i42.FollowUnFollowUseCase>(
        () => _i42.FollowUnFollowUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i43.FollowerPagination>(
        () => _i43.FollowerPagination(gh<_i44.GetFollowersUseCase>()));
    gh.factory<_i45.FollowingPagination>(
        () => _i45.FollowingPagination(gh<_i46.GetFollowingUseCase>()));
    gh.factory<_i11.GetBookmarksUseCase>(
        () => _i11.GetBookmarksUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i18.GetChatUseCase>(
        () => _i18.GetChatUseCase(gh<_i32.MessageRepo>()));
    gh.factory<_i29.GetDrawerDataUseCase>(
        () => _i29.GetDrawerDataUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i37.GetFeedPostUseCase>(
        () => _i37.GetFeedPostUseCase(gh<_i40.FeedRepo>()));
    gh.factory<_i44.GetFollowersUseCase>(
        () => _i44.GetFollowersUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i47.GetFollowersUseCase>(
        () => _i47.GetFollowersUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i46.GetFollowingUseCase>(
        () => _i46.GetFollowingUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i48.GetLikesUseCase>(
        () => _i48.GetLikesUseCase(gh<_i30.PostRepo>()));
    gh.factory<_i12.AddOrRemoveBookmarkUseCase>(
        () => _i12.AddOrRemoveBookmarkUseCase(gh<_i30.PostRepo>()));
    gh.factory<_i49.GetMessagesUseCase>(
        () => _i49.GetMessagesUseCase(gh<_i32.MessageRepo>()));
    gh.factory<_i50.GetNotificationUseCase>(
        () => _i50.GetNotificationUseCase(gh<_i34.NotificationRepo>()));
    gh.factory<_i51.GetProfileLikedPostsUseCase>(
        () => _i51.GetProfileLikedPostsUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i52.GetProfileMediaUseCase>(
        () => _i52.GetProfileMediaUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i53.GetProfilePostsUseCase>(
        () => _i53.GetProfilePostsUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i54.GetProfileUseCase>(
        () => _i54.GetProfileUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i55.GetThreadedPostUseCase>(
        () => _i55.GetThreadedPostUseCase(gh<_i30.PostRepo>()));
    gh.factory<_i56.GetUserSettingsUseCase>(
        () => _i56.GetUserSettingsUseCase(gh<_i4.ProfileRepo>()));
    gh.lazySingleton<_i9.GoogleSignIn>(() => registerModule.googleLogin);
    gh.factory<_i19.HashTagPagination>(
        () => _i19.HashTagPagination(gh<_i57.SearchHashtagsUseCase>()));
    gh.factory<_i13.LikeUnlikeUseCase>(
        () => _i13.LikeUnlikeUseCase(gh<_i30.PostRepo>()));
    gh.factory<_i6.LocalDataSource>(() => _i6.LocalDataSourceImpl(
          gh<_i35.Dio>(),
          gh<_i58.SharedPreferences>(),
        ));
    gh.factory<_i38.LogOutUseCase>(
        () => _i38.LogOutUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i59.LoginCubit>(() => _i59.LoginCubit(
          gh<_i6.LocalDataSource>(),
          gh<_i60.LoginUseCase>(),
          gh<_i61.SocialLoginUseCase>(),
        ));
    gh.factory<_i60.LoginUseCase>(() => _i60.LoginUseCase(gh<_i7.AuthRepo>()));
    gh.factory<_i62.MentionsPagination>(() => _i62.MentionsPagination(
          gh<_i50.GetNotificationUseCase>(),
          gh<_i33.DeleteNotificationUseCase>(),
        ));
    gh.factory<_i63.MessageCubit>(() => _i63.MessageCubit(
          gh<_i49.GetMessagesUseCase>(),
          gh<_i22.DeleteAllMessagesUseCase>(),
        ));
    gh.factory<_i32.MessageRepo>(() => _i64.MessageRepoImpl(
          gh<_i5.ApiHelper>(),
          gh<_i6.LocalDataSource>(),
        ));
    gh.factory<_i65.MySocialShare>(() => _i65.MySocialShare());
    gh.factory<_i66.NotificationCubit>(() => _i66.NotificationCubit(
          gh<_i67.NotificationPagination>(),
          gh<_i62.MentionsPagination>(),
        ));
    gh.factory<_i67.NotificationPagination>(() => _i67.NotificationPagination(
          gh<_i50.GetNotificationUseCase>(),
          gh<_i33.DeleteNotificationUseCase>(),
        ));
    gh.factory<_i34.NotificationRepo>(
        () => _i68.NotificationRepoImpl(gh<_i5.ApiHelper>()));
    gh.factory<_i69.PeoplePagination>(
        () => _i69.PeoplePagination(gh<_i70.SearchPeopleUseCase>()));
    gh.factory<_i71.PostCubit>(() => _i71.PostCubit(
          gh<_i12.AddOrRemoveBookmarkUseCase>(),
          gh<_i13.LikeUnlikeUseCase>(),
          gh<_i14.RepostUseCase>(),
          gh<_i15.DeletePostUseCase>(),
          gh<_i72.SearchPostUseCase>(),
          gh<_i73.ShowLikesPagination>(),
        ));
    gh.factory<_i30.PostRepo>(() => _i74.PostRepoImpl(
          gh<_i5.ApiHelper>(),
          gh<_i6.LocalDataSource>(),
        ));
    gh.factory<_i75.ProfileCubit>(() => _i75.ProfileCubit(
          gh<_i54.GetProfileUseCase>(),
          gh<_i42.FollowUnFollowUseCase>(),
          gh<_i38.LogOutUseCase>(),
          gh<_i76.UpdateProfileCoverUseCase>(),
          gh<_i77.UpdateAvatarProfileUseCase>(),
        ));
    gh.factory<_i78.ProfileLikesPagination>(() =>
        _i78.ProfileLikesPagination(gh<_i51.GetProfileLikedPostsUseCase>()));
    gh.factory<_i79.ProfileMediaPagination>(
        () => _i79.ProfileMediaPagination(gh<_i52.GetProfileMediaUseCase>()));
    gh.factory<_i80.ProfilePostPagination>(
        () => _i80.ProfilePostPagination(gh<_i53.GetProfilePostsUseCase>()));
    gh.factory<_i81.FollowersFollowingCubit>(() => _i81.FollowersFollowingCubit(
          gh<_i43.FollowerPagination>(),
          gh<_i45.FollowingPagination>(),
          gh<_i42.FollowUnFollowUseCase>(),
          gh<_i54.GetProfileUseCase>(),
        ));
    gh.factory<_i14.RepostUseCase>(
        () => _i14.RepostUseCase(gh<_i30.PostRepo>()));
    gh.factory<_i82.ResetPasswordCubit>(
        () => _i82.ResetPasswordCubit(gh<_i83.ResetPasswordUseCase>()));
    gh.factory<_i83.ResetPasswordUseCase>(
        () => _i83.ResetPasswordUseCase(gh<_i7.AuthRepo>()));
    gh.factory<_i39.SaveNotificationPushUseCase>(
        () => _i39.SaveNotificationPushUseCase(gh<_i40.FeedRepo>()));
    gh.factory<_i24.SearchChatUseCase>(
        () => _i24.SearchChatUseCase(gh<_i32.MessageRepo>()));
    gh.factory<_i84.SearchCubit>(() => _i84.SearchCubit(
          gh<_i19.HashTagPagination>(),
          gh<_i69.PeoplePagination>(),
          gh<_i42.FollowUnFollowUseCase>(),
        ));
    gh.factory<_i57.SearchHashtagsUseCase>(
        () => _i57.SearchHashtagsUseCase(gh<_i85.SearchRepo>()));
    gh.factory<_i70.SearchPeopleUseCase>(
        () => _i70.SearchPeopleUseCase(gh<_i85.SearchRepo>()));
    gh.factory<_i72.SearchPostUseCase>(
        () => _i72.SearchPostUseCase(gh<_i85.SearchRepo>()));
    gh.factory<_i85.SearchRepo>(() => _i86.SearchRepoImpl(gh<_i5.ApiHelper>()));
    gh.factory<_i20.SendChatMessageUseCase>(
        () => _i20.SendChatMessageUseCase(gh<_i32.MessageRepo>()));
    await gh.factoryAsync<_i58.SharedPreferences>(
      () => registerModule.storage,
      preResolve: true,
    );
    gh.factory<_i73.ShowLikesPagination>(() => _i73.ShowLikesPagination(
          gh<_i48.GetLikesUseCase>(),
          gh<_i42.FollowUnFollowUseCase>(),
        ));
    gh.factory<_i87.SignUpCubit>(() => _i87.SignUpCubit(
          gh<_i88.SignUpUseCase>(),
          gh<_i61.SocialLoginUseCase>(),
        ));
    gh.factory<_i88.SignUpUseCase>(
        () => _i88.SignUpUseCase(gh<_i7.AuthRepo>()));
    gh.factory<_i61.SocialLoginUseCase>(
        () => _i61.SocialLoginUseCase(gh<_i7.AuthRepo>()));
    gh.factory<_i77.UpdateAvatarProfileUseCase>(
        () => _i77.UpdateAvatarProfileUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i89.UpdatePasswordUseCase>(
        () => _i89.UpdatePasswordUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i90.UpdatePrivacyUseCase>(
        () => _i90.UpdatePrivacyUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i76.UpdateProfileCoverUseCase>(
        () => _i76.UpdateProfileCoverUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i91.UpdateUserSettingsUseCase>(
        () => _i91.UpdateUserSettingsUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i92.UploadManager>(
        () => _i92.UploadManager(gh<_i6.LocalDataSource>()));
    gh.factory<_i26.UploadMediaUseCase>(
        () => _i26.UploadMediaUseCase(gh<_i30.PostRepo>()));
    gh.factory<_i93.UserLikesCubit>(() => _i93.UserLikesCubit(
          gh<_i12.AddOrRemoveBookmarkUseCase>(),
          gh<_i13.LikeUnlikeUseCase>(),
          gh<_i14.RepostUseCase>(),
          gh<_i15.DeletePostUseCase>(),
          gh<_i72.SearchPostUseCase>(),
          gh<_i51.GetProfileLikedPostsUseCase>(),
          gh<_i73.ShowLikesPagination>(),
        ));
    gh.factory<_i94.UserMediaCubit>(() => _i94.UserMediaCubit(
          gh<_i12.AddOrRemoveBookmarkUseCase>(),
          gh<_i13.LikeUnlikeUseCase>(),
          gh<_i14.RepostUseCase>(),
          gh<_i15.DeletePostUseCase>(),
          gh<_i72.SearchPostUseCase>(),
          gh<_i73.ShowLikesPagination>(),
          gh<_i52.GetProfileMediaUseCase>(),
        ));
    gh.factory<_i95.UserPostCubit>(() => _i95.UserPostCubit(
          gh<_i12.AddOrRemoveBookmarkUseCase>(),
          gh<_i13.LikeUnlikeUseCase>(),
          gh<_i14.RepostUseCase>(),
          gh<_i15.DeletePostUseCase>(),
          gh<_i72.SearchPostUseCase>(),
          gh<_i73.ShowLikesPagination>(),
          gh<_i53.GetProfilePostsUseCase>(),
        ));
    gh.factory<_i96.UserSettingCubit>(() => _i96.UserSettingCubit(
          gh<_i56.GetUserSettingsUseCase>(),
          gh<_i91.UpdateUserSettingsUseCase>(),
          gh<_i89.UpdatePasswordUseCase>(),
          gh<_i90.UpdatePrivacyUseCase>(),
          gh<_i31.DeleteAccountUseCase>(),
          gh<_i97.VerifyUserAccountUseCase>(),
          gh<_i16.ChangeLanguageUseCase>(),
          gh<_i3.GetLoginMode>(),
        ));
    gh.factory<_i97.VerifyUserAccountUseCase>(
        () => _i97.VerifyUserAccountUseCase(gh<_i4.ProfileRepo>()));
    gh.factory<_i98.ViewPostCubit>(() => _i98.ViewPostCubit(
          gh<_i55.GetThreadedPostUseCase>(),
          gh<_i27.CreatePostUseCase>(),
          gh<_i13.LikeUnlikeUseCase>(),
          gh<_i14.RepostUseCase>(),
          gh<_i12.AddOrRemoveBookmarkUseCase>(),
          gh<_i15.DeletePostUseCase>(),
        ));
    gh.factory<_i4.ProfileRepo>(() => _i99.ProfileRepoImpl(
          gh<_i5.ApiHelper>(),
          gh<_i6.LocalDataSource>(),
          gh<_i9.GoogleSignIn>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i100.RegisterModule {}
