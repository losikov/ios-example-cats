//
//  CatsFeedCollectionViewController.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

import UIKit

class CatsFeedCollectionViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = CatsFeedViewModel()
    
    lazy var collectionView: UICollectionView = {
        let usersCollectionViewLayout = CatsFeedCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: usersCollectionViewLayout)
        collectionView.register(
            CatsFeedCollectionViewCell.self,
            forCellWithReuseIdentifier: CatsFeedViewModel.cellIdentifier
        )
        collectionView.backgroundColor = .primaryBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
    }
}

// MARK: - Setup
extension CatsFeedCollectionViewController {
    private func setupUI() {
        // navigation bar
        title = viewModel.title
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.title
        ]
        navigationController?.navigationBar.backgroundColor = .secondaryBackground
        
        // collection view
        view.addSubview(collectionView)
        collectionView.prefetchDataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.reloadCollectionViewClosure =  { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.showAlertClosure = { [weak self] (message) in
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.initFetch()
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension CatsFeedCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let m = viewModel.items[indexPath.row]
            
            UIImageView().loadImageWithUrl(
                string: m.imageUrl(),
                placeholder: #imageLiteral(resourceName: "placeholder"),
                startedHandler: {},
                completionHandler: {image in}
            )
        }
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension CatsFeedCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CatsFeedViewModel.cellIdentifier,
            for: indexPath
        ) as! CatsFeedCollectionViewCell
        
        let u = viewModel.items[indexPath.row]
        cell.configure(with: u)
        
        return cell
    }
}
