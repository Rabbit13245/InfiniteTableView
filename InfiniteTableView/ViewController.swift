//
//  ViewController.swift
//  InfiniteTableView
//
//  Created by Дмитрий Зайцев on 26.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var isMoreDataLoading = false
    var currentPage = 0
    var range = 100
    var cellHeight: CGFloat = 40
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.allowsSelection = false
//        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.contentOffset.y = tableView.contentSize.height / 2 - tableView.bounds.height / 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row % 2 == 0 ? cellHeight * 2: cellHeight
        //return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return range
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = "\(currentPage * range / 2 + indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            if scrollView.contentOffset.y <= 0 && tableView.isDragging {
                //print("up: \(scrollView.contentOffset.y)")
                isMoreDataLoading = true
                currentPage -= 1
                tableView.reloadData()
                scrollView.contentOffset.y = tableView.contentSize.height / 2
                isMoreDataLoading = false
            }
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                currentPage += 1
                tableView.reloadData()
                scrollView.contentOffset.y = tableView.contentSize.height / 2 - tableView.bounds.height
                isMoreDataLoading = false
            }
        }
    }
}
