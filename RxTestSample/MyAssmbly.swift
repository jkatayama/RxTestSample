//
//  MyAssmbly.swift
//  RxTestSample
//
//  Created by Jumpei Katayama on 2020/08/26.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import Swinject
import SwinjectStoryboard

class MyAssmbly: Assembly {
    func assemble(container: Container) {

        container.register(Repository.self) { _ in
            Repository()
            
        }.inObjectScope(.container)

        container.register(UseCase.self) { _ in
            UseCase(repository: container.resolve(Repository.self)!)
        }.inObjectScope(.container)
        
        container.register(ViewModel.self) { _ in
            ViewModel(usecase: container.resolve(UseCase.self)!)
        }.inObjectScope(.container)
        
        container.storyboardInitCompleted(ViewController.self) { r, vc in
            vc.viewModel = r.resolve(ViewModel.self)
        }
        
        SwinjectStoryboard.defaultContainer = container
    }
}
