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
        setupDI()
    }
    
    private func setupDI() {
        container = Container()
        
        container.register(CardProtocolMock.self) { r in
            return CardProtocolMock(brand: "Mastercard", number: "5444444444444444")
        }
        
        container.register(UseCaseProtocolMock.self) { r in
            let usecase = UseCaseProtocolMock()
            usecase.executeHandler = {
                return Single.just(r.resolve(CardProtocolMock.self)!)
            }
            return usecase
        }

        container.register(ViewModel.self) { r in
            return ViewModel(usecase: r.resolve(UseCaseProtocolMock.self)!)
        }
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

        sut = container.resolve(ViewModel.self)!
        var result: String?
        
        sut.cardNumber.asObservable().subscribe(onNext: { text in
            result = text
            }).disposed(by: disposeBag)

        /// When
        sut.requestData()
        
        /// Then
        XCTAssertEqual(result, "5444444444444444")
    }

    /// 初回ローディングのようなviewModelがusecaseを実行した後期待するイベントが送られることを検証
    /// Mock対象のUseCaseがsingleを返すのでTestObserable

    func testWithNoTestObservable() throws {
        /// Given

        sut = container.resolve(ViewModel.self)!

        let observer = scheduler.createObserver(String?.self)

        
        /// When
        sut.requestData()
        sut.cardNumber.asObservable().subscribe(observer).disposed(by: disposeBag)
        scheduler.start()
        
        /// Then
        XCTAssertEqual(observer.events, [
            .next(0, "5444444444444444")
        ])
    }
    
    
    
    func test_Given_UserIsActivated_When_RequestData_Then_ValidSomeData() throws {
        /// Given
        sut = container.resolve(ViewModel.self)!
        let observer = scheduler.createObserver(String?.self)

        
        /// When
        sut.requestData()
        sut.cardNumber.asObservable().subscribe(observer).disposed(by: disposeBag)
        scheduler.start()
        
        /// Then
        XCTAssertEqual(observer.events, [
            .next(0, "5444444444444444")
        ])

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
