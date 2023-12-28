class TensorSlice {
  final int start, end, step;
  final TensorSlice? slice;
  TensorSlice({
    required this.start,
    required this.end,
    this.step = 1,
    this.slice,
  });
}
