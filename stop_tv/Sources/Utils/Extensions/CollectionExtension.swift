//
//  CollectionExtension.swift
//  stop_tv
//
//  Created by Júlia Saboya on 27/06/25.
//


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}