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
