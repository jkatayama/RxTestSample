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
    var dataToShow: BehaviorRelay<String?> { get set }
    func requestData()
}



class ViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()

    var usecase: UseCaseProtocol
    
    /// Test対象
    // 初期値nilのdataToShowがrequestData()が呼ばれた時に期待する文字列が流れることをテストする
    var dataToShow: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    init(usecase: UseCaseProtocol) {
        self.usecase = usecase
    }
    
    func requestData() {
        usecase.execute().observeOn(MainScheduler.instance)
        .subscribe(onSuccess: { data in
            self.dataToShow.accept(data.country)
        }, onError: { e in
            }).disposed(by: disposeBag)
    }
}

