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
    let queryService = QueryService()
    
    //   let Article = Observable.just(Chocolate.ofEurope)
    
    private let cellIdentifier = "BasicCell"
    private let apiService = ApiService()
    var disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for university"
        return searchController
    }()
    //  let europeanChocolates = Observable.just(Chocolate.ofEurope)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryService.getSearchResults(searchTerm:"영어공부") { results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let results = results {
                self.articles = results
                self.setupCellConfiguration(self.articles)
                
            }
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }
        
        configureProperties()
    }
    //Dispose bag
    
    
    func setupCellConfiguration(_ articleList:[Article]) {
        let europeanChocolates = Observable.just(articleList)
        europeanChocolates
            .bind(to: tableView
                .rx
                .items(cellIdentifier: BasicCell.Identifier,
                       cellType: BasicCell.self)) { row, article, cell in
                        cell.configureWithChocolate(article: article)
            }
            .disposed(by:disposeBag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureProperties() {
        navigationItem.searchController = searchController
        navigationItem.title = "University finder"
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
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
    //
    //        let titlelb = cell.viewWithTag(2) as? UILabel
    //        let authorlb = cell.viewWithTag(1) as? UILabel
    //        let article = articles[indexPath.row]
    //
    //
    //
    //        return cell
    //
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if (indexPath.row == expandIndexPath && expanable == true){
    //
    //            return 100
    //        }else{
    //            return 300
    //        }
    //    }
    //
    
    
    
}
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedArticle = articles[indexPath.row]
        //Boolean 값을 줘서 특정 인덱스 크기변화를 할지 말지 정함
        expanable = !expanable
        //변수에 특정 인덱스값을 넣어 다시 리로딩할때 어떤것을 크기조정할지 알수 있다.
        expandIndexPath = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .none)
        
        
    }
}


