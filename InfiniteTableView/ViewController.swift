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
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.contentOffset.y = cellHeight * CGFloat(range / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return range
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
//        print("\(currentPage * range / 2 + indexPath.row); IP = \(indexPath.row)")
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
                scrollView.contentOffset.y = cellHeight * CGFloat(tableView.visibleCells.count * 2 + tableView.visibleCells.count / 2 + 3)
                isMoreDataLoading = false
            }
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                //print("down")
                isMoreDataLoading = true
                currentPage += 1
                tableView.reloadData()
                scrollView.contentOffset.y = cellHeight * CGFloat(tableView.visibleCells.count * 2 - tableView.visibleCells.count / 2 + 3)
                isMoreDataLoading = false
            }
        }
    }
}
