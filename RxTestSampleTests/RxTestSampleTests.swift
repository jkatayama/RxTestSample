//
//  RxTestSampleTests.swift
//  RxTestSampleTests
//
//  Created by Jumpei Katayama on 2020/08/25.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import XCTest
import RxTest
import Swinject
import RxSwift
import RxBlocking
@testable import RxTestSample

class RxTestSampleTests: XCTestCase {
    var container: Container!
    
    var disposeBag: DisposeBag!
    
    var scheduler: TestScheduler!

    var sut: ViewModel!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        container = Container()
        
        container.register(UseCaseProtocolMock.self) { r in
            UseCaseProtocolMock()
        }

        container.register(ViewModel.self) { r in
            return ViewModel(usecase: r.resolve(UseCaseProtocolMock.self)!)
        }
    }
    
    private func setupDI() {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWithNoRxTest() throws {
        // RxTestは必ずしも必要ではない
        // Mockが固定値を返すのでTestSchedulerのことは考えなくていい
        // 単純なテストであればこれで十分
        // ただし、関わってくるイベントが増えるにつれてより多くのcode量が必要になりtest codeの可読性が下がる
        
        /// Given
        let mock = container.resolve(UseCaseProtocolMock.self)!
        
        mock.executeHandler = {
            return Single.just(SomeData(country: "U.S."))
        }
        
        sut = container.resolve(ViewModel.self)!
        sut.usecase = mock
        var result: String?
        
        sut.dataToShow.asObservable().subscribe(onNext: { text in
            result = text
            }).disposed(by: disposeBag)

        /// When
        sut.requestData()
        
        /// Then
        XCTAssertEqual(result, "U.S.")
    }

    /// 初回ローディングのようなviewModelがusecaseを実行した後期待するイベントが送られることを検証

    func testWithNoTestObservable() throws {
        /// Given
        let mock = container.resolve(UseCaseProtocolMock.self)!
        
        mock.executeHandler = {
            return Single.just(SomeData(country: "U.S."))
        }
        
        sut = container.resolve(ViewModel.self)!
        sut.usecase = mock
        let observer = scheduler.createObserver(String?.self)

        
        /// When
        sut.requestData()
        sut.dataToShow.asObservable().subscribe(observer).disposed(by: disposeBag)
        scheduler.start()
        
        /// Then
        XCTAssertEqual(observer.events, [
            .next(0, "U.S.")
        ])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
