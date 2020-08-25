//
//  RxTestSampleTests.swift
//  RxTestSampleTests
//
//  Created by Jumpei Katayama on 2020/08/25.
//  Copyright © 2020 Jumpei Katayama. All rights reserved.
//

import XCTest
/* 以下のエラーを防ぐためにもTestCase Target内RxSwiftをimportすべきではない
objc[9760]: Class _TtGC7RxSwift10ObservableC12RxTestSample8SomeData_ is implemented in both /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/swift/libswiftCore.dylib (0x7fff89d4be48) and /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/swift/libswiftCore.dylib (0x7fff89d4e5a8). One of the two will be used. Which one is undefined.
*/
import RxTest
import RxSwift
import RxBlocking
@testable import RxTestSample

class RxTestSampleTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    
    var scheduler: TestScheduler!
    
    class MockUseCase: UseCaseProtocol {
        var repository: RepositoryProtocol
        
//        var scheduler: TestScheduler!
        
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
//            scheduler.createHotObservable([
//                Recorded.next(110, SomeData(country: "U.S."))
//            ])
            //
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

    func testExample() throws {
        /// When
        let mockUseCase = MockUseCase(testScheduler: scheduler)
        sut = ViewModel(usecase: mockUseCase)

        /// Given
        sut.requestData()
        
        let xs = scheduler.createHotObservable([.next(10, nil),
                                        .next(60, "U.S.")])

        xs.bind(to: sut.dataToShow).disposed(by: disposeBag)
        
         let observer = scheduler.createObserver(String?.self)
        
        sut.dataToShow.asDriver().drive(observer).disposed(by: disposeBag)
        
//        sut.dataToShow.asObservable().subscribe(observer).disposed(by: disposeBag)
        
        scheduler.start()

        
        /// Then
        //// 難しいところ
        /// dataToShowにイベントが流れたことをどうテストするか

        XCTAssertEqual(observer.events, [
            .next(10, nil),
            .next(100, "U.S.")
        ])

        /// これは間違い? 固定値を返すなら成功する？
//        XCTAssertEqual(sut.dataToShow.value ?? "", "U.S.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
