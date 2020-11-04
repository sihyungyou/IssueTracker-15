//
//  DetailConditionViewModel.swift
//  IssueTracker
//
//  Created by 김신우 on 2020/11/05.
//  Copyright © 2020 IssueTracker-15. All rights reserved.
//

import Foundation

protocol DetailConditionViewModelProtocol: AnyObject {
    
    var detailCondition: DetailCondition { get }
    var result: [ConditionCellViewModel] { get }
    var didChanged: ((IndexPath, IndexPath) -> Void)? { get set }
    
    func cellForRow(at indexPath: IndexPath) -> ConditionCellViewModel
    func cellSelected(at index: Int) -> ConditionCellViewModel
    func cellUnselected(at index: Int) -> ConditionCellViewModel
    func select(at indexPath: IndexPath)
    func numberOfDatas(at section: Int) -> Int
}

class DetailConditionViewModel: DetailConditionViewModelProtocol {
    
    private(set) var detailCondition: DetailCondition
    private var viewModelDataSource: [[ConditionCellViewModel]]
    private var maxSelection: Int
    
    var didChanged: ((IndexPath, IndexPath) -> Void)?
    var result: [ConditionCellViewModel] {
        viewModelDataSource[0]
    }
    
    init(detailCondition: DetailCondition, viewModelDataSource: [[ConditionCellViewModel]], maxSelection: Int) {
        self.detailCondition = detailCondition
        self.viewModelDataSource = viewModelDataSource
        self.maxSelection = maxSelection
    }
    
    func cellForRow(at indexPath: IndexPath) -> ConditionCellViewModel {
        return viewModelDataSource[indexPath.section][indexPath.row]
    }
    
    func cellSelected(at index: Int) -> ConditionCellViewModel {
        return viewModelDataSource[0][index]
    }
    
    func cellUnselected(at index: Int) -> ConditionCellViewModel {
        return viewModelDataSource[1][index]
    }
    
    func select(at indexPath: IndexPath) {
        let source = indexPath.section
        let dest = source == 0 ? 1 : 0
        let indexFrom = indexPath
        let indexTo = IndexPath(row: viewModelDataSource[dest].count, section: dest)
        
        let data = viewModelDataSource[source].remove(at: indexFrom.row)
        viewModelDataSource[dest].append(data)
        
        didChanged?(indexFrom, indexTo)
        
        if viewModelDataSource[0].count > maxSelection {
            let indexFrom = IndexPath(row: 0, section: 0)
            let indexTo = IndexPath(row: viewModelDataSource[1].count, section: 1)
            
            let data = viewModelDataSource[indexFrom.section].remove(at: indexFrom.row)
            viewModelDataSource[indexTo.section].append(data)
            
            didChanged?(indexFrom, indexTo)
        }
    }
    
    func numberOfDatas(at section: Int) -> Int {
        return viewModelDataSource[section].count
    }
    
}
