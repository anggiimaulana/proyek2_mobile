import 'package:proyek2/data/models/pengajuan_surat.dart';

sealed class TrackingSuratListState {}

class SuratListNoneState extends TrackingSuratListState {}

class SuratListLoadingState extends TrackingSuratListState {}

class SuratListErrorState extends TrackingSuratListState {
  final String error;
  SuratListErrorState(this.error);
}

class SuratListLoadedState extends TrackingSuratListState {
  final List<PengajuanSurat> data;
  SuratListLoadedState(this.data);
}
