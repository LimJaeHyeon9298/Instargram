//
//  FeedViewController.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/14.
//

import UIKit

class FeedViewController: UIViewController {
    private let limit = 50
    
    private var feeds: [Feed] = []
    private var isLoadingContents = false
    private var expandedContents: [IndexPath: Bool] = [:]
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = self.tableView.frame.height + 100
        
        self.setupRefreshControl()
        self.initialize()
        self.addObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "User", let user = sender as? User {
            let controller = segue.destination as? UserViewController
            
            controller?.user = user
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.resumeMovie()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.pauseMovie()
    }
}


// MARK: - 더보기 관련

extension FeedViewController {
    @objc private func initialize() {
        loadContents(reset: true)
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(initialize), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc private func loadContents(reset: Bool = false) {
        loadingIndicator.startAnimating()
        
        fetchMoreContent(completion: { [weak self] feeds in
            guard let weakself = self else { return }
            
            if reset {
                self?.feeds = feeds
                self?.expandedContents = [:]
            } else {
                self?.feeds.append(contentsOf: feeds)
            }
            
            if weakself.limit <= weakself.feeds.count {
                self?.tableView.tableFooterView?.frame = .zero
            } else {
                self?.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: weakself.tableView.frame.width, height: 44)
            }
            
            self?.tableView.reloadData()
            self?.isLoadingContents = false
            self?.loadingIndicator.stopAnimating()
            self?.tableView.refreshControl?.endRefreshing()
            
            if reset {
                self?.playMovieIfNeeded()
            }
        })
    }
    
    private func fetchMoreContent(completion: @escaping (([Feed]) -> ())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let feeds = (1...20).map{_ in Feed.createRandom()}
            completion(feeds)
        })
    }
}

// MARK: - 영상관련

extension FeedViewController {
    @objc func pauseMovie() {
        tableView.visibleCells.compactMap{$0 as? MoviePlayable}.forEach{$0.pause()}
    }
    
    @objc func resumeMovie() {
        tableView.visibleCells.compactMap{$0 as? MoviePlayable}.forEach{$0.resume()}
    }
    
    private func playMovieIfNeeded() {
        var alreadyPlaying = false
        
        self.tableView.visibleCells.compactMap{$0 as? MoviePlayable}.forEach{
            let isPlayable = $0.isPlayable(from: self.tableView)
            if alreadyPlaying == false && isPlayable {
                $0.resume()
                alreadyPlaying = true
            } else {
                $0.pause()
            }
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseMovie), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeMovie), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

// MARK: - 액션 처리

extension FeedViewController: FeedCellDelegate {
    func feedCell(_ cell: FeedCell, toggleLike feed: Feed) {
        guard let index = feeds.firstIndex(where: {$0.id == feed.id}) else { return }
        
        var feed = feeds[index]
        let liked = feed.liked == false
        let count = feed.likeCount + (liked ? 1 : -1)
        
        feed.liked = liked
        feed.likeCount = count
        
        feeds[index] = feed
        
        cell.feed = feed
        cell.updateLike(feed)
    }
    
    func feedCell(_ cell: FeedCell, selectUser user: User) {
        performSegue(withIdentifier: "User", sender: user)
    }
    
    func feedCellShoudExpand(_ cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        self.expandedContents[indexPath] = true
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        let expanded = expandedContents[indexPath, default: false]
        
        var feed = feeds[indexPath.row]
        
        feed.content = (expanded || feed.content.count < 40) ? feed.content : feed.content.prefix(40) + "... 더보기"
        cell.delegate = self
        cell.feed = feed
        
        return cell
    }
}

extension FeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldLoadMore = scrollView.contentOffset.y + scrollView.frame.height - 30 > scrollView.contentSize.height
        let haveMoreContents = feeds.count < limit
        
        if shouldLoadMore && haveMoreContents && isLoadingContents == false {
            isLoadingContents = true
            loadContents(reset: false)
        }
        
        self.playMovieIfNeeded()
    }
}
