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
import SwinjectStoryboard
import Swinject
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
        subscribe()
        viewModel.requestData()
    }
    
    private func subscribe() {
        viewModel.dataToShow.bind(to: label.rx.text)
        .disposed(by: disposeBag)
    }
}


class SomeData {
    let country: String
    
    init(country: String) {
        self.country = country
    }
}
