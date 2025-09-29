import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/screens/posts/provider/post_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostsScreen extends ConsumerStatefulWidget {
  const PostsScreen({super.key});

  @override
  ConsumerState<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _stateRefresh({bool isRefresh = false}){
    final postsState = ref.read(postNotifierProvider);
    if (postsState.error != null) {
      _refreshController.loadFailed();
      return;
    }
    if (isRefresh) {
      _refreshController.refreshCompleted();
    } else {
      if (postsState.hasMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }
    
  }

  void _onRefresh() async{
    // monitor network fetch
    await ref.read(postNotifierProvider.notifier).loadInitialItems();
    _stateRefresh(isRefresh: true);
  }

  void _onLoading() async{
    final postsState = ref.read(postNotifierProvider);
    if (postsState.isLoadingMore) {
      // _refreshController.loadComplete();
      return;
    }
    // monitor network fetch
    final notifier = ref.read(postNotifierProvider.notifier);
    await notifier.loadNextPage();
    _stateRefresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncPosts = ref.watch(postNotifierProvider);
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus? mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text(loc.postsPullUpLoad);
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text(loc.postsLoadFailed);
            }
            else if(mode == LoadStatus.canLoading){
                body = Text(loc.postsReleaseToLoad);
            }
            else{
              body = Text(loc.postsNoMoreData);
            }
            return SizedBox(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
              itemCount: asyncPosts.items.length,
              itemBuilder: (context, index) {
                final post = asyncPosts.items[index];
                return ListTile(title: Text(loc.postsId(int.tryParse(post.id ?? '0') ?? 0, post.title ?? '')), subtitle: Text('${post.body}'),);
              },
            ),
      ),
    );
  }
}
