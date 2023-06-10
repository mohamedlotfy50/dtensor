enum MemoryOrder { c, f }

extension MemoryOrderExtension on MemoryOrder {
  MemoryOrder transpose() {
    if (this == MemoryOrder.c) {
      return MemoryOrder.f;
    }
    return MemoryOrder.c;
  }
}
