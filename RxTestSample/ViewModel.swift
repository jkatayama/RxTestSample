//
//  ViewModel.swift
//  RxTestSample
//
//  Created by Jumpei Katayama on 2020/08/26.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ViewModelProtocol: class {
    var usecase: UseCaseProtocol { get set }
    var cardNumber: BehaviorRelay<String?> { get set }
    func requestData()
}



class ViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()

    var usecase: UseCaseProtocol
    
    /// Test対象
    var cardNumber: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    init(usecase: UseCaseProtocol) {
        self.usecase = usecase
    }
    
    func requestData() {
        usecase.execute().observeOn(MainScheduler.instance)
        .subscribe(onSuccess: { data in
            self.cardNumber.accept(data.number)
        }, onError: { e in
            }).disposed(by: disposeBag)
    }
}

