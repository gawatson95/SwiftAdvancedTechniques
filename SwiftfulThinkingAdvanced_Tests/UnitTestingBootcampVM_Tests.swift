//
//  UnitTestingBootcampVM_Tests.swift
//  SwiftfulThinkingAdvanced_Tests
//
//  Created by Grant Watson on 5/23/22.
//

// NAMING STRUCTURE: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// NAMING STRUCTURE: test_[struct or class]_[variable or function]_[expected result]

// TESTING STRUCTURE: Given, When, Then

import Combine
import XCTest
@testable import SwiftfulThinkingAdvanced

class UnitTestingBootcampVM_Tests: XCTestCase {
    
    var viewModel: UnitTestingBootcampVM?
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = UnitTestingBootcampVM(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        viewModel = nil
    }

    func test_UnitTestingBootcampVM_isPremium_shouldBeTrue() {
        // Given
        let userIsPremium: Bool = true
        
        // When
        let vm = UnitTestingBootcampVM(isPremium: userIsPremium)
        
        // Then
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_UnitTestingBootcampVM_isPremium_shouldBeFalse() {
        // Given
        let userIsPremium: Bool = false
        
        // When
        let vm = UnitTestingBootcampVM(isPremium: userIsPremium)
        
        // Then
        XCTAssertFalse(vm.isPremium)
    }
    
    func test_UnitTestingBootcampVM_isPremium_shouldBeInjectedValue() {
        // Given
        let userIsPremium: Bool = Bool.random()
        
        // When
        let vm = UnitTestingBootcampVM(isPremium: userIsPremium)
        
        // Then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    
    func test_UnitTestingBootcampVM_isPremium_shouldBeInjectedValue_Stress() {
        for _ in 0..<10 {
            // Given
            let userIsPremium: Bool = Bool.random()
            
            // When
            let vm = UnitTestingBootcampVM(isPremium: userIsPremium)
            
            // Then
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }
    
    func tests_UnitTestingBootcampVM_dataArray_shouldBeEmpty() {
        //Given
        
        // When
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func tests_UnitTestingBootcampVM_dataArray_shouldAddItems() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        // Then
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
        XCTAssertNotEqual(vm.dataArray.count, 0)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func tests_UnitTestingBootcampVM_dataArray_shouldNotAddBlankString() {
        // Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        vm.addItem(item: "")
        
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func tests_UnitTestingBootcampVM_dataArray_shouldNotAddBlankString2() {
        // Given
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        vm.addItem(item: "")
        
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func tests_UnitTestingBootcampVM_selectedItem_shouldStartAsNil() {
        //Given
        
        // When
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func tests_UnitTestingBootcampVM_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        
        //select correct item
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        // select incorrect item
        vm.selectItem(item: UUID().uuidString)
        
        // Then
        XCTAssertNil(vm.selectedItem)
    }
    
    func tests_UnitTestingBootcampVM_selectedItem_shouldBeSelected() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        // Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
    }
    
    func tests_UnitTestingBootcampVM_selectedItem_shouldBeSelected_stress() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        vm.selectItem(item: randomItem)
        
        // Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem)
    }
    
    func tests_UnitTestingBootcampVM_saveItem_shouldThrowError_itemNotFound() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        // Then
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item Not Found error") { error in
            let returnedError = error as? UnitTestingBootcampVM.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampVM.DataError.itemNotFound)
        }
    }
    
    func tests_UnitTestingBootcampVM_saveItem_shouldThrowError_noData() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        // Then
        
        do {
            try vm.saveItem(item: "")
        } catch let error {
            let returnedError = error as? UnitTestingBootcampVM.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampVM.DataError.noData)
        }
    }
    
    func tests_UnitTestingBootcampVM_saveItem_shouldSaveItem() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        
        // Then
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))
        
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }

    func tests_UnitTestingBootcampVM_downloadWithEscaping_shouldReturnItems() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after three seconds")
        
        
        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithEscaping()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func tests_UnitTestingBootcampVM_downloadWithCombine_shouldReturnItems() {
        //Given
        let vm = UnitTestingBootcampVM(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after a second")
        
        
        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithCombine()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
}
