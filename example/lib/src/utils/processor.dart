import 'dart:async';

typedef Processor<I, O> = FutureOr<List<O>> Function(List<I> chunk);

Future<List<O>> processByChunks<I, O>(List<I> data, int chunkSize, Processor<I, O> processor) async {
  final List<O> result = [];

  for (int i = 0; i < data.length; i += chunkSize) {
    final List<I> chunk = data.sublist(i, i + chunkSize > data.length ? data.length : i + chunkSize);
    final List<O> processedChunk = await processor(chunk);
    result.addAll(processedChunk);
  }

  return result;
}
