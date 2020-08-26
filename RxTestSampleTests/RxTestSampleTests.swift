//
//  RxTestSampleTests.swift
//  RxTestSampleTests
//
//  Created by Jumpei Katayama on 2020/08/25.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxBlocking
@testable import RxTestSample

class RxTestSampleTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    
    var scheduler: TestScheduler!
    
    class MockUseCase: UseCaseProtocol {
        var repository: RepositoryProtocol
        
        init(testScheduler: TestScheduler) {
            self.repository = MockRepository(testScheduler: testScheduler)
        }
        
        func execute() -> Single<SomeData> {
            return repository.load()
        }
    }
    
    class MockRepository: RepositoryProtocol {
        var scheduler: TestScheduler!
        
        init(testScheduler: TestScheduler) {
            self.scheduler = testScheduler
        }

        func load() -> Single<SomeData> {
            // SingleはtestObservableに対応していない
            // stubはSignleの固定を返すだけでいい、なぜならテストしたいことはイベントが流れてきた時にbindが正しくされるかであって非同期かどうかは重要でないため
            return  Single.just(SomeData(country: "U.S."))
        }

    }
    
    var sut: ViewModel!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        
        
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
        disposeBag = DisposeBag()
        let mockUseCase = MockUseCase(testScheduler: scheduler)
        sut = ViewModel(usecase: mockUseCase)
        
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
        let mockUseCase = MockUseCase(testScheduler: scheduler)
        // 本来はここでusecase.execのstubを実装
        sut = ViewModel(usecase: mockUseCase)
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
