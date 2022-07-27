//
//  StoredSingle.swift
//  
//
//  Created by Ben Scheirman on 7/27/22.
//

import Boutique
import Combine
import Foundation

@MainActor
@propertyWrapper
public struct StoredSingle<Object: Codable & Equatable> {

    private let box: Box

    public init(in store: Store<Object>) {
        self.box = Box(store)
    }

    public var wrappedValue: Object? {
        box.store.items.first
    }

    public var projectedValue: Store<Object> {
        box.store
    }

    public func save(_ object: Object) async throws {
        try await box.store.add(object)
    }

    public static subscript<Instance: ObservableObject>(
        _enclosingInstance instance: Instance,
        wrapped wrappedKeyPath: KeyPath<Instance, Object?>,
        storage storageKeyPath: KeyPath<Instance, Self>
    ) -> Object?
    where Instance.ObjectWillChangePublisher == ObservableObjectPublisher
    {
        let propertyWrapper = instance[keyPath: storageKeyPath]
        if propertyWrapper.box.cancellable == nil {
            let store = propertyWrapper.projectedValue
            propertyWrapper.box.cancellable = store.objectWillChange
                .sink(receiveValue: { [willChange = instance.objectWillChange] in
                    willChange.send()
                })
        }

        return propertyWrapper.wrappedValue
    }

    private class Box {
        let store: Store<Object>
        var cancellable: AnyCancellable?
        init(_ store: Store<Object>) {
            self.store = store
        }
    }
}
