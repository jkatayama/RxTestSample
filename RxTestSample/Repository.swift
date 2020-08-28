//
//  Repository.swift
//  RxTestSample
//
//  Created by Jumpei Katayama on 2020/08/26.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import RxSwift

protocol RepositoryProtocol: class {
    func load() -> Single<CardProtocol>
}

class Repository: RepositoryProtocol {
    func load() -> Single<CardProtocol> {
        return Single.just(Card(brand: "VISA", number: "4111111111111111"))
    }
}

