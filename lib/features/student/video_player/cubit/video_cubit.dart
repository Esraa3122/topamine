import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:test/features/student/home/data/model/lecture_model.dart';
import 'package:video_player/video_player.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());

  VideoPlayerController? videoController;
  ChewieController? chewieController;

  Future<void> loadLectureVideo(LectureModel lecture) async {
    emit(VideoLoading());

    await videoController?.dispose();
    chewieController?.dispose();

    videoController = VideoPlayerController.network(lecture.videoUrl);
    await videoController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoController!,
      autoPlay: true,
      aspectRatio: videoController!.value.aspectRatio,
    );

    emit(VideoLoaded(lecture));
  }

  @override
  Future<void> close() {
    videoController?.dispose();
    chewieController?.dispose();
    return super.close();
  }
}

@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  VideoLoaded(this.lecture);
  final LectureModel lecture;
}
