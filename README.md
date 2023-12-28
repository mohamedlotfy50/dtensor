# DTensor
## Unleashing NumPy-like Power in Dart

`DTensor` is dart package Brings the  efficiency and expressiveness of numerical computation to Dart with DaBrain, a tensor-centric package inspired by NumPy.



## Features

- Tensor Variety: Work seamlessly with dense tensors, sparse tensors, ragged tensors, and scalars to suit diverse data structures and optimize memory usage.
- Rich Operations: Explore a comprehensive set of operations, including:
    - Logical operations on boolean tensors: `and`, `or`, `not`
    - Arithmetic operations: `+`,` -`, `*`, `/`
    - Dot product and matrix multiplications
    - Sorting: `argsort`, `max`, `argmax`, `min`, `argmin`, `mean`, `transpose`, etc ..
- Numpy supports: Support parsing saved `.npy` files directly to `DTensor` tensor. Enjoy a familiar syntax and paradigm for those coming from NumPy, easing the transition into Dart numerical computations.

## Basic Usage:

### Tensor creation
For the tensor creation just use `DTensor.tensor` and it's automaticly detect tensor type from the inputed value

```dart
  final scalar = DTensor<int>.tensor(2);
  final dense = DTensor<double>.tensor([
    [1.0, 2.5, 3, 4],
    [5, 6, 7, 8]
  ]);
  final raged = DTensor<int>.tensor([
    [1, 2, 3, 4],
    [5, 6, 7]
  ]);

```
**Note**: It's always best practice to define the tensor type.

### Pre-defined Tensors
Creating `zeros` or `one` tensors with speific shape 
```dart
 final ones = DTensor<int>.ones([9, 5, 7, 4]);
 final zeros = DTensor<int>.zeros([9, 5, 4, 3]);
```

### Numpy Integration

```dart
  final numpy = DTensor.load(File('save_file.npy'));

```

### Mathmatical operations
Use matrix multiplications over ND tensor
```dart 
  final t1 = DTensor<int>.ones([9, 5, 7, 4]);
  final t2 = DTensor<int>.zeros([9, 5, 4, 3]);

  final stopwatch = Stopwatch()..start();

  DTensor.matMult(t1, t2);

  final s = stopwatch.elapsed;

  print('time taken  ${s}'); // time taken  0:00:00.207473
```
## Join the Community:
Share your thoughts and contribute to DaBrain's development
## License

[GPLv3](licence.md)

