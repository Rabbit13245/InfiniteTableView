//
//  TableViewController.swift
//  InfiniteTableView
//
//  Created by Дмитрий Зайцев on 25.04.2021.
//

import UIKit

class TableViewController: UITableViewController {

    var isMoreDataLoading = false
    var currentPage = 0
    var range = 100
    var cellHeight: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //tableView.contentOffset.y = cellHeight * CGFloat(4)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return range
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = "\(currentPage * range / 2 + indexPath.row)"
        return cell
    }
}

extension TableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            if scrollView.contentOffset.y <= -20 && tableView.isDragging {
                print("up: \(scrollView.contentOffset.y)")
                isMoreDataLoading = true
                currentPage -= 1
                tableView.reloadData()
                scrollView.contentOffset.y = cellHeight * CGFloat(tableView.visibleCells.count * 2 + tableView.visibleCells.count / 2 + 3)
                isMoreDataLoading = false
            }
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                print("down")
                isMoreDataLoading = true
                currentPage += 1
                scrollView.contentOffset.y = cellHeight * CGFloat(range / 2 + 4)
                isMoreDataLoading = false
                //scrollView.contentOffset.y = cellHeight * CGFloat(tableView.visibleCells.count)
            }
        }
    }
    
    func loadDataPlus() {
        currentPage += 1
    }
    
    func loadDataMinus() {
        
        isMoreDataLoading = false
    }
}
