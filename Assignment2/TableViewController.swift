//
//  ViewController.swift
//  Assignment2
//
//  Created by Jeeeun Lim on 15/06/2019.
//  Copyright © 2019 ASPN. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class TableViewController: UIViewController {
    var expandIndexPath : Int = 0
    var expanable = false
    var articles = [Article]()
    var selectedArticle:Article?
    let apiService = ApiService()
    let apiClient = APIClient()
    //   let Article = Observable.just(Chocolate.ofEurope)
    
    private let cellIdentifier = "BasicCell"
   
    var disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for app"
        
      
        
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.dimsBackgroundDuringPresentation = false
        
        //tableView.tableHeaderView = searchController.searchBar
        
      
        
        searchController.searchBar.sizeToFit()
        
        
      
        
    

        
        
        
        
        
        return searchController
    }()
    //  let europeanChocolates = Observable.just(Chocolate.ofEurope)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 350

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        queryService.getSearchResults(searchTerm:"영어공부") { results, errorMessage in
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            if let results = results {
//                self.articles = results
//                self.setupCellConfiguration(self.articles)
//
//            }
//            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
//        }
        configureProperties()
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
          searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "") }
            .map { ArticleRequest(name: $0) }
            .flatMap { request -> Observable<[Article]> in
              return self.apiClient.send(apiRequest: request)
            }
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier,   cellType: BasicCell.self)) { index, model, cell in
               cell.configureWithChocolate(article: model)
                
            }
            .disposed(by: disposeBag)
      
     
    }
    //Dispose bag
    
  
    func setupCellConfiguration(_ articleList:[Article]) {
        let listObeservable = Observable.just(articleList)
        listObeservable
            .bind(to: tableView
                .rx
                .items(cellIdentifier: BasicCell.Identifier,
                       cellType: BasicCell.self)) { row, article, cell in
                        cell.configureWithChocolate(article: article)
            }
            .disposed(by:disposeBag)
        
      
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureProperties() {
        navigationItem.searchController = searchController
        navigationItem.title = "TableView"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //    private func configureReactiveBinding() {
    //        searchController.searchBar.rx.text.asObservable()
    //            .map { ($0 ?? "").lowercased() }
    //            .map { ArticleRequest(name: $0)) }
    //            .flatMap { request -> Observable<[Article]> in
    //                return self.apiService.send(apiRequest: request)
    //            }
    //            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { index, model, cell in
    //                cell.textLabel?.text = model.name
    //                cell.detailTextLabel?.text = model.description
    //                cell.textLabel?.adjustsFontSizeToFitWidth = true
    //            }
    //            .disposed(by: disposeBag)
    //        //
    //        //        tableView.rx.modelSelected(UniversityModel.self)
    //        //            .map { URL(string: $0.webPages?.first ?? "")! }
    //        //            .map { SFSafariViewController(url: $0) }
    //        //            .subscribe(onNext: { [weak self] safariViewController in
    //        //                self?.present(safariViewController, animated: true)
    //        //            })
    //        //            .disposed(by: disposeBag)
    //    }
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    //        return articles.count
    //    }
    //

    
    
    
}
extension TableViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
        }
}


