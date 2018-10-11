
import UIKit

class SearchVewController: UITableViewController{
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let apiService = APIService()
    var searchModel: SearchModel!{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cell: SearchCell.self)
        
        configSearchBar()
    }
    
    func configSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.barTintColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
        searchController.searchBar.tintColor = .white
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1).cgColor
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchModel != nil else { return 0 }
        return searchModel.predictions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: SearchCell.self, for: indexPath)
        let searchResult = searchModel.predictions[indexPath.row]
        cell.config(for: searchResult)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wVC = ViewController.instantiate()
        wVC.requestType = .cityName
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        wVC.cityName = cell.cityLabel.text?.components(separatedBy: ",").first!
        self.navigationController?.pushViewController(wVC, animated: true)
    }
 }

//MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension SearchVewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty{
            apiService.getSearchResult(forRequest: searchText.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)) { (result) in
                guard result != nil else { return }
                self.searchModel = result!
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchModel = nil
        tableView.reloadData()
    }
}
