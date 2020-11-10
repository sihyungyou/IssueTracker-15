//
//  IssueListViewModel.swift
//  IssueTracker
//
//  Created by 김신우 on 2020/11/04.
//  Copyright © 2020 IssueTracker-15. All rights reserved.
//
import Foundation

protocol IssueListViewModelProtocol: AnyObject {
    var didFetch: (() -> Void)? { get set }
    var invalidateLayout: (() -> Void)? { get set }
    var didCellChecked: ((IndexPath, Bool) -> Void)? { get set }
    var showTitleWithCheckNum: ((Int) -> Void)? { get set }
    var filter: IssueFilterable? { get set }
    var issues: [IssueItemViewModel] { get }
    func needFetchItems()
    
    func selectCell(at path: IndexPath)
    func clearSelectedCells()
    func selectAllCells()
    
    func closeSelectedIssue(at paths: [IndexPath])
    
    func createFilterViewModel() -> IssueFilterViewModelProtocol?
    func createIssueDetailViewModel(path: IndexPath) -> IssueDetailViewModel?
    
    func addNewIssue(title: String, description: String, authorID: Int)
}

class IssueListViewModel: IssueListViewModelProtocol {
    
    private weak var labelProvider: LabelProvidable?
    private weak var milestoneProvider: MilestoneProvidable?
    private weak var issueProvider: IssueProvidable?
    
    var filter: IssueFilterable?
    var didFetch: (() -> Void)?
    var invalidateLayout: (() -> Void)?
    var showTitleWithCheckNum: ((Int) -> Void)?
    var didCellChecked: ((IndexPath, Bool) -> Void)?
    
    private(set) var issues = [IssueItemViewModel]()
    
    init(labelProvider: LabelProvidable, milestoneProvider: MilestoneProvidable, issueProvider: IssueProvidable) {
        self.labelProvider = labelProvider
        self.milestoneProvider = milestoneProvider
        self.issueProvider = issueProvider
    }
    
    func needFetchItems() {
        issueProvider?.fetchIssues(completion: { [weak self] (datas) in
            guard let `self` = self,
                let issues = datas
                else { return }
            
            self.issues.removeAll()
            
            issues.forEach {
                let itemViewModel = IssueItemViewModel(issue: $0)
                self.issues.append(itemViewModel)
                self.labelProvider?.getLabels(of: $0.labels, completion: { [weak itemViewModel] (labels) in
                    itemViewModel?.setLabels(labels: labels)
                    self.invalidateLayout?()
                })
                
                if let milestoneID = $0.milestone {
                    self.milestoneProvider?.getMilestone(at: milestoneID, completion: { [weak itemViewModel] milestone in
                        itemViewModel?.setMilestone(milestone: milestone)
                        self.invalidateLayout?()
                    })
                }
            }
            
            DispatchQueue.main.async {
                self.didFetch?()
            }
        })
    }
    
    func closeSelectedIssue(at paths: [IndexPath]) {
        
    }
    
    func selectCell(at path: IndexPath) {
        issues[path.row].checked.toggle()
        self.didCellChecked?(path, issues[path.row].checked)
        showTitleWithCheckNum?(issues.filter { $0.checked }.count)
    }
    
    func clearSelectedCells() {
        for (idx, issue) in issues.enumerated() {
            issue.checked = false
            self.didCellChecked?(IndexPath(row: idx, section: 0), false)
        }
        showTitleWithCheckNum?(0)
    }
    
    func selectAllCells() {
        for (idx, issue) in issues.enumerated() {
            issue.checked = true
            self.didCellChecked?(IndexPath(row: idx, section: 0), true)
        }
        showTitleWithCheckNum?(issues.filter { $0.checked }.count)
    }
    
    func createFilterViewModel() -> IssueFilterViewModelProtocol? {
        let generalConditions = filter?.generalConditions ?? [Bool](repeating: false, count: Condition.allCases.count)
        let detailConditions = filter?.detailConditions ?? [Int](repeating: -1, count: DetailSelectionType.allCases.count)
        let viewModel = IssueFilterViewModel(labelProvider: labelProvider,
                                             milestoneProvider: milestoneProvider,
                                             issueProvider: issueProvider,
                                             generalConditions: generalConditions,
                                             detailConditions: detailConditions)
        
        return viewModel
    }
    
    func createIssueDetailViewModel(path: IndexPath) -> IssueDetailViewModel? {
        let cellViewModel = issues[path.row]
        return IssueDetailViewModel(id: cellViewModel.id,
                                    issueProvider: issueProvider,
                                    labelProvier: labelProvider,
                                    milestoneProvider: milestoneProvider)
    }
    
    func addNewIssue(title: String, description: String, authorID: Int) {
        issueProvider?.addIssue(title: title, description: description, authorID: authorID, milestoneID: nil) { [weak self] (createdIssue) in
            guard let `self` = self,
                let createdIssue = createdIssue
                else { return }
            self.issues.append(IssueItemViewModel(issue: createdIssue))
            self.didFetch?()
        }
    }
}
