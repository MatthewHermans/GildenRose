//
//  Item.swift
//  SwiftlyTest
//
//  Created by John Russel Usi on 6/14/23.
//

import Foundation

struct Item: Identifiable {
    let id = UUID()
    var name: String
    var price: Double
}
