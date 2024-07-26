import UIKit

class FavoritesVC: UIViewController {
    private var favoriteCities: [FavoriteCity] = []
    private let tableView = UITableView()
    private let noFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorite locations here."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let customTransitionDelegate = CustomTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        setupTableView()
        setupNavigationBar()
        setupNoFavoritesLabel()
        loadFavoriteCities()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteCityCell.self, forCellReuseIdentifier: FavoriteCityCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearFavorites))
        navigationItem.rightBarButtonItem = clearButton
    }

    private func setupNoFavoritesLabel() {
        view.addSubview(noFavoritesLabel)
        NSLayoutConstraint.activate([
            noFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func clearFavorites() {
        FavoriteCitiesManager.shared.clearFavorites()
        loadFavoriteCities()
    }

    private func loadFavoriteCities() {
        favoriteCities = FavoriteCitiesManager.shared.getFavoriteCities()
        tableView.reloadData()
        updateNoFavoritesLabel()
    }

    private func updateNoFavoritesLabel() {
        noFavoritesLabel.isHidden = !favoriteCities.isEmpty
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCityCell.reuseIdentifier, for: indexPath) as! FavoriteCityCell
        let favoriteCity = favoriteCities[indexPath.row]
        
        cell.configure(cityName: favoriteCity.cityName, temperature: favoriteCity.temperature, weatherDescription: favoriteCity.weatherDescription, timestamp: favoriteCity.timestamp)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteCity = favoriteCities[indexPath.row]
        let detailVC = FavoriteCityDetailVC()
        detailVC.favoriteCity = favoriteCity
        
        customTransitionDelegate.originFrame = tableView.rectForRow(at: indexPath)
        customTransitionDelegate.originFrame = tableView.convert(customTransitionDelegate.originFrame, to: tableView.superview)
        
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.transitioningDelegate = customTransitionDelegate
        navigationController.modalPresentationStyle = .custom
        
        present(navigationController, animated: true, completion: nil)
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityName = favoriteCities[indexPath.row].cityName
            FavoriteCitiesManager.shared.removeFavorite(cityName: cityName)
            favoriteCities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateNoFavoritesLabel()
        }
    }
}

