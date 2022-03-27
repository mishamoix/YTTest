//
//  ViewController.swift
//  YTTest
//
//  Created by mike on 27.03.2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
	func show(videos: [VideoModel])
}

final class MainViewController: UIViewController {
	private var data: [VideoModel] = []
	private let interactor: MainInteractable
	
	private lazy var tableView: UITableView = {
		let view = UITableView()
		view.delegate = self
		view.dataSource = self
		view.keyboardDismissMode = .onDrag
		view.alwaysBounceVertical = true
		view.translatesAutoresizingMaskIntoConstraints = false
		view.register(YTCell.self, forCellReuseIdentifier: "YTCell")
		return view
	}()
	
	private lazy var searchController: UISearchController = {
		let view = UISearchController(searchResultsController: nil)
		view.searchResultsUpdater = self
		view.obscuresBackgroundDuringPresentation = false
		view.searchBar.placeholder = "Tap to search"
		return view
	}()
	
	init(interactor: MainInteractable) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}

}

extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		cellHeight
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		cellHeight
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		if indexPath.row == data.count - 1 {
			interactor.needLoadNext()
		}
	}
}

extension MainViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		data.count
	}
	
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "YTCell", for: indexPath)
		if let cell = cell as? YTCell {
			cell.update(with: data[indexPath.row])
		}
		return cell
	}
}

extension MainViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text ?? ""
		interactor.searchTextDidChange(text: text)
	}
}

extension MainViewController: MainViewProtocol {
	func show(videos: [VideoModel]) {
		self.data = videos
		tableView.reloadData()
	}
}

private extension MainViewController {
	var cellHeight: CGFloat {
		9.0 * view.frame.width / 16.0
	}
	
	func setup() {
		view.backgroundColor = .white
		
		setupNavbar()
		setupTableView()
	}
	
	func setupTableView() {
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])

	}
	
	func setupNavbar() {
		navigationItem.title = "Youtube"
		navigationItem.searchController = searchController
	}
}

