import 'package:colibri/core/common/widget/common_divider.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/widgets/animations/fade_widget.dart';
import 'package:colibri/core/widgets/loading_bar.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/posts/presentation/bloc/post_cubit.dart';
import 'package:colibri/features/posts/presentation/widgets/post_pagination_widget.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:colibri/features/search/domain/entity/hashtag_entity.dart';
import 'package:colibri/features/search/presentation/bloc/search_cubit.dart';
import 'package:colibri/features/search/presentation/widgets/hasttag_item.dart';
import 'package:colibri/features/search/presentation/widgets/people_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:colibri/extensions.dart';


class SearchScreen extends StatefulWidget {
  final String searchedText;
  const SearchScreen({Key key, this.searchedText}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin{
  SearchCubit searchCubit;
  PostCubit postCubit;
  TabController tabController;
  FocusNode focusNode;
  TextEditingController textEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCubit = getIt<SearchCubit>();
    postCubit = getIt<PostCubit>();
    tabController=TabController(length: 3, vsync: this);
    focusNode=FocusNode();
    textEditingController=TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(widget.searchedText?.isNotEmpty==true){
        tabController.animateTo(2,duration: const Duration(milliseconds: 300));
        // textEditingController.text=widget.searchedText.replaceAll("#", "");
        postCubit.searchedText=widget.searchedText.replaceAll("#", "");
        // postCubit.searchedText=widget.searchedText;
        // postCubit.changeSearch(widget.searchedText.replaceAll("#", ""));
      }
    });
    tabController.addListener(() {
      FocusManager.instance.primaryFocus.unfocus();
      var s=textEditingController.text;
      if(tabController.index==0){
        searchCubit.hashTagPagination.queryText=s;
      }
      else if(tabController.index==1){
        searchCubit.peoplePagination.queryText=s;
      }
      else {
        postCubit.searchedText=s;
      }
      // doSearch(textEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (_, value) => [
          SliverAppBar (
            title: AppIcons.appLogo.toContainer(height: 35, width: 35).toVisibility(widget.searchedText!=null),
            centerTitle: true,
            elevation: 0.0,
            floating: true,
            pinned: true,
            expandedHeight: widget.searchedText!=null?160.toHeight:115.toHeight,
            flexibleSpace: "#hashtag, username, etc..."
                .toSearchBarField(onTextChange: (s){
                  // textEditingController.text=s;
                  print(textEditingController.text);
                 doSearch(s);
            },focusNode: focusNode,textEditingController: textEditingController).toHorizontalPadding(24)
                .toContainer(height: widget.searchedText!=null?140:60),
            // automaticallyImplyLeading: ,
            leading: const BackButton(color: AppColors.colorPrimary,).toVisibility(widget.searchedText!=null),
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(context.getScreenWidth, 56.toHeight),
              child: Stack(
                children: [
                  Positioned.fill(
                    top: 0.0,
                    child: Container(
                      color: Colors.white,
                    ).makeVerticalBorders,
                  ),
                  TabBar (
                    onTap: (value) {
                      FocusManager.instance.primaryFocus.unfocus();
                    },
                    controller: tabController,
                    tabs: [
                      // "Hashtags".toTab(),
                      const Tab(text: "Hashtags"),
                      const Tab(text: "People"),
                      const Tab(text: "Posts"),
                      // "People".toTab(),
                      // "Posts".toTab(),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
        body: TabBarView (
          controller: tabController,
          children: [

            Container (
                child: RefreshIndicator (

                  onRefresh: () {
                    searchCubit.hashTagPagination.onRefresh();
                    return Future.value();
                  },

                  child: PagedListView.separated (
                    key: const PageStorageKey("Hashtags"),
                    pagingController: searchCubit.hashTagPagination.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<HashTagEntity> (
                        noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen (
                          buttonText: "GO TO HOMEPAGE",
                          icon: const Icon(Icons.search,color: AppColors.colorPrimary,size: 40,),
                          title: "Nothing Found",
                          message:'Sorry, but we could not find anything in our database for your search query  "${textEditingController.text}."  Please try again by typing other keywords.',
                          onTapButton: () {
                            BlocProvider.of<FeedCubit>(context).changeCurrentPage(const ScreenType.home());
                          },
                        ),
                    itemBuilder: (c,item,index){
                      return Padding(
                        padding:  EdgeInsets.only(top: index==0?8.0:0,left: 10),
                        child: getHastTagItem(item,(s){
                          // DefaultTabController.of(context).animateTo(1);

                          // context.showSnackBar(message: s);
                          textEditingController.text=s.replaceAll("#", "");
                          postCubit.searchedText=s.replaceAll("#", "");
                          // FocusScope.of(context).requestFocus(focusNode);
                          tabController.animateTo(2,duration: const Duration(milliseconds: 300));

                        }),
                      );
                    }
                  ), separatorBuilder: (BuildContext context, int index) =>commonDivider,

                  ),
                )),

            RefreshIndicator (
              onRefresh: (){
                searchCubit.peoplePagination.onRefresh();
                return Future.value();
              },
              child: PagedListView.separated(
                key: const PageStorageKey("People"),
                pagingController: searchCubit.peoplePagination.pagingController,
                padding: const EdgeInsets.only(top: 10),
                builderDelegate: PagedChildBuilderDelegate<PeopleEntity> (
                    noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen (
                      buttonText: "GO TO HOMEPAGE",
                      icon: const Icon(Icons.search,color: AppColors.colorPrimary,size: 40,),
                      title: "Nothing Found",
                      message:'Sorry, but we could not find anything in our database for your search query  "${textEditingController.text}."  Please try again by typing other keywords.',
                      onTapButton: () {
                        BlocProvider.of<FeedCubit>(context).changeCurrentPage(const ScreenType.home());
                      },
                    ),
                  itemBuilder: (c,item,index){
                    return PeopleItem(peopleEntity: item,onFollowTap: (){
                      // context.showSnackBar(message:"test");
                       searchCubit.followUnFollow(index);
                    },);
                  }
              ), separatorBuilder: (BuildContext context, int index) =>commonDivider,),
              ),

            RefreshIndicator (
              onRefresh: () {
                postCubit.onRefresh();
                return Future.value();
              },
              child: PostPaginationWidget (
                isComeHome: true,
                isSliverList: false,
                noDataFoundScreen: StreamBuilder<String> (
                  stream: postCubit.search,
                  initialData: textEditingController.text,
                  builder: (context, snapshot) {
                    return snapshot.data.isEmpty ? LoadingBar() : NoDataFoundScreen (
                      buttonText: "GO TO HOMEPAGE",
                      icon: const Icon(Icons.search,color: AppColors.colorPrimary,size: 40),
                      title: "Nothing Found",
                      message:'Sorry, but we could not find anything in our database for your search query "${snapshot.data??""}."  Please try again by typing other keywords.',
                      onTapButton: () {
                        BlocProvider.of<FeedCubit>(context).changeCurrentPage(const ScreenType.home());
                      },
                    );
                  }
                ),
                pagingController: postCubit.pagingController,
                onTapLike: postCubit.likeUnlikePost,
                onTapRepost: postCubit.repost,
                onOptionItemTap: postCubit.onOptionItemSelected,
                isFromProfileSearch: true,
              ),
            )

          ],
        ),
      ).toSafeArea,
    );
  }

  void doSearch(String s) {
    print("inside methid $s");
    if(tabController.index==0){
      searchCubit.hashTagPagination.changeSearch(s);
    }
    else if(tabController.index==1){
      searchCubit.peoplePagination.changeSearch(s);
    }
    else {
      postCubit.changeSearch(s);
    }
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
