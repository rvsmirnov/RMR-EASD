part of 'for_meeting_list_bloc.dart';

abstract class ForMeetingListEvent extends Equatable {
  const ForMeetingListEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends ForMeetingListEvent {}

class SortDataSave extends ForMeetingListEvent {
  final List<SortColumnDetails>? sortDataList;

  const SortDataSave({
    @required this.sortDataList,
  });
  
  @override
  List<Object?> get props => [sortDataList];
  
  @override
  String toString() =>
      'SortDataSave { sortDataList: $sortDataList }';
}


