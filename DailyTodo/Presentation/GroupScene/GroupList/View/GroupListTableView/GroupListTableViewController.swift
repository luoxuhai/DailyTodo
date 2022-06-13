//
//  GroupListTableViewController.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/18.
//

import UIKit

class GroupListTableViewController: UITableViewController {
    
    var items: [String] = [
        "1", "2", "3", "4", "5", "55", "6", "7", "8", "88",
    ]
    
    // MARK: - Lifecycle
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setupViews() {
        print("items", items)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GroupListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        let item = self.items[indexPath.item]
        cell.textLabel?.text = item
        print(item)
        return cell
    }
    
}
