import UIKit
import SwiftUI
import PinLayout

class GroupListViewController: UIViewController {
    var tableVC: UITableViewController?
    private let searchBarController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = LocalizedString("Lists.Title")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func handleEdit() {
        
    }
    
    @objc func handleAddClick() {
        print("handleAddClick")
    }
    
    @objc func handlePresentSetting() {
        print("handlePresentSetting")
        let settingsView = UIHostingController(rootView: SettingsView()
                                               // .environmentObject(self.appViewModel)
            .environmentObject(GroupListViewModel())
            .environmentObject(TodoItemsViewModel())
            .environmentObject(SettingsViewModel())
        )
        DispatchQueue.main.async { [weak self] in
            self?.present(settingsView, animated: true)
        }
    }
    
    private func setupViews() {
        self.setupSearchController()
        self.setupTableView()
        self.setupToobar()
    }
    
    private func setupTableView() {
        self.tableVC = GroupListTableViewController()
        
        if let tableVC = self.tableVC {
            self.addChild(tableVC)
            self.view.addSubview(tableVC.tableView)
            tableVC.tableView.pin.all()
        }
    }
    
    private func setupToobar() {
        GroupListToolbarView(self)
    }
}

// MARK: - Search Controller

extension GroupListViewController {
    private func setupSearchController() {
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.placeholder = "搜索任务"
        searchBarController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarController.obscuresBackgroundDuringPresentation = true
        self.navigationItem.searchController = searchBarController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension GroupListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
       // searchController.isActive = false
       // viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      //  viewModel.didCancelSearch()
    }
}

extension GroupListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
       // updateQueriesSuggestions()
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
       // updateQueriesSuggestions()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
       // updateQueriesSuggestions()
    }
}
