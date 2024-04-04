//
//  FolloweListVC.swift
//  GitHubFollowers
//
//  Created by Lee Sangoroh on 26/02/2024.
//

import UIKit

class FollowerListVC: UIViewController {
    
    // enum conforms to hashable
    // enum for sections of the collection view
    enum Section {
        case main
    }
    
    
    var username: String!
    var followers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    
    var collectionView: UICollectionView!
    // creating data source
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureCollectionView()
        configureDataSource()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView(){
        // view.bounds fills up the whole view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    
    func getFollowers(username: String, page: Int){
        
        showLoadingView()
        // introduce [weak self] capture list
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            
            // unwrapping self optional
            // - now we are safe from memory leaks
            guard let self = self else {return}
            
            self.dismissLoadingView()
            
            switch result {
                case .success(let followers):
                    if followers.count < 100 {
                        self.hasMoreFollowers = false
                    }
                    // network call has a strong reference to 'self' (FollowerListVC) which could cause a memory leak
                    // solution is to make self weak, which in turn makes it an optional
                    self.followers.append(contentsOf: followers)
                    print(followers)
                    self.updateData()
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    // configure data source
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: {(collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }

    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // how far we have scrolled
        let offsetY = scrollView.contentOffset.y
        // height of all content of 100 followers
        let contentHeight = scrollView.contentSize.height
        // height of screen
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {
                return
            }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}
