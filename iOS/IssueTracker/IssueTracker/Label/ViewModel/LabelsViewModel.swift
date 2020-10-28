//
//  LabelListViewModel.swift
//  IssueTracker
//
//  Created by 김신우 on 2020/10/28.
//  Copyright © 2020 IssueTracker-15. All rights reserved.
//

import Foundation

protocol LabelsViewModelProtocol {
    var didFetch: (() -> Void)? { get set }
    func needFetchItems()
    func cellForItemAt(path: IndexPath) -> LabelItemViewModel
    func numberOfItem() -> Int
    func didAddNewLabel(title: String, desc: String, hexColor: String)
    func didEditLabel(at indexPath: IndexPath, title: String, desc: String, hexColor: String)
}

class LabelsViewModel: LabelsViewModelProtocol {
    
    var didFetch: (() -> Void)?
    private var labels = [Label]()
    
    func didEditLabel(at indexPath: IndexPath, title: String, desc: String, hexColor: String) {
        labels[indexPath.row] = Label(title: title, description: desc, hexColor: hexColor)
        
        didFetch?()
    }
    
    func didAddNewLabel(title: String, desc: String, hexColor: String) {
        let newLabel: Label = Label(title: title, description: desc, hexColor: hexColor)
        labels.append(newLabel)
        
        didFetch?()
    }
    
    func needFetchItems() {
        labels = [Label(title: "feature", description: "기능에 대한 레이블입니다.", hexColor: "#FF5D5D"),
                  Label(title: "bug", description: "수정할 버그에 대한 레이블입니다.", hexColor: "#96F879")]
        didFetch?()
    }
    
    func cellForItemAt(path: IndexPath) -> LabelItemViewModel {
        return LabelItemViewModel(label: labels[path.row])
    }
    
    func numberOfItem() -> Int {
        labels.count
    }
    
}
