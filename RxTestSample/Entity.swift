//
//  Entity.swift
//  RxTestSample
//
//  Created by Jumpei Katayama on 2020/08/28.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import Foundation

/// @mockable
protocol CardProtocol {
    var brand: String { get }
    var number: String { get }
}

struct Card: CardProtocol {
    let brand: String
    let number: String
}
