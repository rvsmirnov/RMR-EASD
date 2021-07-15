part of 'for_meeting_list_bloc.dart';

abstract class ForMeetingListState extends Equatable {
  const ForMeetingListState();

  @override
  List<Object?> get props => [];
}

class ForMeetingListInitial extends ForMeetingListState {}

class ForMeetingListLoading extends ForMeetingListState {}

class ForMeetingListSortInit extends ForMeetingListState {
  final List<SortColumnDetails>? sortDataList;

  const ForMeetingListSortInit({@required this.sortDataList});

  @override
  List<Object?> get props => [sortDataList];

  @override
  String toString() => 'ForMeetingListSortInit { sortDataList: $sortDataList }';

}

class ForMeetingListFailure extends ForMeetingListState {
  final String? error;

  const ForMeetingListFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'ForMeetingListFailure { error: $error }';
}
