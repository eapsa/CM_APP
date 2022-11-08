import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/feed/bloc/feed_bloc.dart';
import 'package:oart/feed/feed_detail_view.dart';
import 'package:oart/feed/feed_navigator_cubit.dart';
import 'package:oart/feed/feed_tile.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _listBuilder(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("Friends Feed"),
      actions: [
        IconButton(
          onPressed: () {
            BlocProvider.of<FeedNavigatorCubit>(context).showQrcode();
          },
          icon: const Icon(Icons.qr_code_rounded),
        )
      ],
    );
  }

  Future refresh() async {
    context.read<FeedBloc>().add(FeedPageRequest());
    setState(() {});
  }

  Widget _listBuilder(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return Center(
          child: (state is FeedInitialState)
              ? const CircularProgressIndicator()
              : (state is FeedLoadSucessState)
                  ? RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                          addAutomaticKeepAlives: false,
                          itemCount: state.workoutsList.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                                onTap: () {
                                  print("index $index");
                                  BlocProvider.of<FeedNavigatorCubit>(context)
                                      .showDetail(
                                    state.workoutsList[index],
                                    state.imageList[
                                        state.workoutsList[index].id]!,
                                    state.coordList[
                                        state.workoutsList[index].id]!,
                                    state.userNames[
                                        state.workoutsList[index].user_id]!,
                                  );
                                },
                                child: FeedTile(
                                  workout: state.workoutsList[index],
                                  imageList: state
                                      .imageList[state.workoutsList[index].id],
                                  coordList: state
                                      .coordList[state.workoutsList[index].id],
                                  userName: state.userNames[
                                      state.workoutsList[index].user_id]!,
                                )
                                // Text(
                                //     "wawdawd ${state.workoutsList[index].id}"),
                                );
                          })))
                  : Container());
    });
  }
}
