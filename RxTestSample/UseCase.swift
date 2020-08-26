//
//  UseCase.swift
//  RxTestSample
//
//  Created by Jumpei Katayama on 2020/08/26.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import RxSwift

class UseCase: UseCaseProtocol {
    var repository: RepositoryProtocol!
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Single<SomeData> {
        return repository.load()
    }
}

// 依存プロトコル2
protocol UseCaseProtocol: class {
    var repository: RepositoryProtocol! { get set }
    
    func execute() -> Single<SomeData> // APIとかでデータ取ってくる
}

