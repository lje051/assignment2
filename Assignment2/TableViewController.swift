//
//  ViewController.swift
//  Assignment2
//
//  Created by Jeeeun Lim on 15/06/2019.
//  Copyright © 2019 ASPN. All rights reserved.
//


import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var expandIndexPath : Int = 0
  var expanable = false
  var articles = [Article]()
  var selectedArticle:Article?
  let queryService = QueryService()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    
    //"영어공부"라는 단어를 앱스토어에 검색했을때의 결과를 가져온다.
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    queryService.getSearchResults(searchTerm:"영어공부") { results, errorMessage in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      if let results = results {
        self.articles = results
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
      }
      if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
    }

  
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
    
    let titlelb = cell.viewWithTag(2) as? UILabel
     let authorlb = cell.viewWithTag(1) as? UILabel
    let article = articles[indexPath.row]
    
    if let actualLabel = titlelb {
      actualLabel.text = article.articleTitle
    }
    if let authorlb = authorlb {
      authorlb.text = article.articleDescription
    }

    if article.articleImageUrl != "" {
      let imageView = cell.viewWithTag(100) as? UIImageView
      
      if let actualImageView = imageView {
        
        let url = URL(string: article.articleImageUrl)
        if let actualUrl = url {
          let request = URLRequest(url: actualUrl)
          let session = URLSession.shared
          let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error ) in
            //fire off this work to update the ui to the main thread
            
            DispatchQueue.main.async {
              //the data has been downloaded. create a uiimage objet and assign it into the imageview
              if let actualData = data {
                actualImageView.image = UIImage(data:actualData)
              }
              
            }
          })
          
          
          //fire off the data task
          dataTask.resume()
          
        }
        
        
      }
      
      
    }else{
      //artilce has no image url, so set the imageview to nil image
      let imageview = cell.viewWithTag(100) as? UIImageView
      if let actualImageView = imageview {
        actualImageView.image = nil
      }
    }
    
    
    return cell
    
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if (indexPath.row == expandIndexPath && expanable == true){
        
        return 100
      }else{
        return 300
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    selectedArticle = articles[indexPath.row]
    //Boolean 값을 줘서 특정 인덱스 크기변화를 할지 말지 정함
    expanable = !expanable
    //변수에 특정 인덱스값을 넣어 다시 리로딩할때 어떤것을 크기조정할지 알수 있다.
    expandIndexPath = indexPath.row
    tableView.reloadRows(at: [indexPath], with: .none)
  
    
  }
 
  
}


