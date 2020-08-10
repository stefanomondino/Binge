import Foundation

public extension Collection {
    func asDictionaryOfValues<Key: Hashable>(indexedBy key: KeyPath<Element, Key>) -> [Key: Element] {
        reduce([:]) { accumulator, item in
            var accumulator = accumulator
            accumulator[item[keyPath: key]] = item
            return accumulator
        }
    }

    func asDictionaryOfCollections<Key: Hashable>(indexedBy key: KeyPath<Element, Key>) -> [Key: [Element]] {
        reduce([:]) { accumulator, item in
            var accumulator = accumulator
            accumulator[item[keyPath: key]] = (accumulator[item[keyPath: key]] ?? []) + [item]
            return accumulator
        }
    }
}
