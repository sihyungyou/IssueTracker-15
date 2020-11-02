//
//  IssueListViewController.swift
//  IssueTracker
//
//  Created by 김신우 on 2020/11/01.
//  Copyright © 2020 IssueTracker-15. All rights reserved.
//

import UIKit

class IssueListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "이슈"
        configureSearchBar()
        configureCollectionView()
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
    }
    
    private func configureCollectionView() {
        setupCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.register(type: IssueCellView.self)
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let cellHeight = self.view.bounds.height / 10
        layout.itemSize = CGSize(width: self.view.bounds.width, height: cellHeight)
        layout.minimumLineSpacing = 1
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    // TODO: editMode 클릭시 테스트용 변수 -> EditMode 액션과 연결 필요
    var editmode: Bool = false
}

// MARK: - Actions
extension IssueListViewController {
    
    @IBAction func editButtonTapped(_ sender: Any) {
        editmode = !editmode
        collectionView.visibleCells.forEach {
            guard let cell = $0 as? IssueCellView else { return }
            cell.showCheckBox(show: editmode, animation: true)
        }
    }
    
    @IBSegueAction func createIssueFilterViewController(_ coder: NSCoder) -> IssueFilterViewController? {
        let vc = IssueFilterViewController(coder: coder)
        
        return vc
    }
    
}

// MARK: - UICollectionViewDataSource Implementation
extension IssueListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellView: IssueCellView = collectionView.dequeueCell(at: indexPath) else { return UICollectionViewCell() }
        cellView.configure()
        cellView.showCheckBox(show: editmode, animation: false)
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
}
