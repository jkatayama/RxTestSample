//
//  ViewController.swift
//  RxTestSample
//
//  Created by Jumpei Katayama on 2020/08/25.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
// テスト対象クラスが適合するプロトコル
//protocol HogePresenter: class {
//    var view: HogeView? { get set }
//    var getDataUseCase: HogeUseCase! { get set }
//
//    func requestData()
//}
// テスト対象クラス
//class HogePresenterImpl: HogePresenter {
//    weak var view: HogeView?
//    var getDataUseCase: HogeUseCase!
//
//    // APIとかでデータ取ってきて画面を更新するイメージ
//    func requestData() {
//        let data = self.getDataUseCase.execute()
//        self.view?.showData(data)
//    }
//}
// 依存プロトコル1
//protocol HogeView: class {
//    func showData(_ data: SomeData) // 画面を更新する
//}

final class ViewController: UIViewController {
    var viewModel: ViewModelProtocol!
    
    private let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let usecase = UseCase(repository: Repository())
        
        viewModel = ViewModel(usecase: usecase)
        subscribe()
        viewModel.requestData()
    }
    
    private func subscribe() {
        viewModel.dataToShow.bind(to: label.rx.text)
        .disposed(by: disposeBag)
    }
}

// 依存プロトコル2
protocol UseCaseProtocol: class {
    var repository: RepositoryProtocol { get set }
    
    func execute() -> Single<SomeData> // APIとかでデータ取ってくる
}

class UseCase: UseCaseProtocol {
    var repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Single<SomeData> {
        return repository.load()
    }
}

class SomeData {
    let country: String
    
    init(country: String) {
        self.country = country
    }
}

protocol ViewModelProtocol: class {
    var usecase: UseCaseProtocol { get set }
    var dataToShow: BehaviorRelay<String?> { get set }
    func requestData()
}

class ViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()

    var usecase: UseCaseProtocol
    
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

protocol RepositoryProtocol: class {
    func load() -> Single<SomeData>
}

class Repository: RepositoryProtocol {
    func load() -> Single<SomeData> {
        return Single.just(SomeData(country: "Japan"))
    }
    
    
}
