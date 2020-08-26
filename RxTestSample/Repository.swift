//
//  Repository.swift
//  RxTestSample
//
//  Created by Jumpei Katayama on 2020/08/26.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import RxSwift

protocol RepositoryProtocol: class {
    func load() -> Single<SomeData>
}

class Repository: RepositoryProtocol {
    func load() -> Single<SomeData> {
        return Single.just(SomeData(country: "Japan"))
    }
}

