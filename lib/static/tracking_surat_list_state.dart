import 'package:proyek2/data/models/pengajuan/pengajuan_surat_dummy.dart';

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
