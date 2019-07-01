//
//  CollectionViewController.swift
//  Assignment2
//
//  Created by Jeeeun Lim on 17/06/2019.
//  Copyright © 2019 ASPN. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  var expandIndexPath : Int = 0
  var expanable = false
  var articles = [Article]()
  var selectedArticle:Article?
  let queryService = QueryService()
  let screenWidth = UIScreen.main.bounds.width
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
    layout.itemSize = CGSize(width: screenWidth / 2.1, height: screenWidth / 2.7)
    collectionView!.collectionViewLayout = layout
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //"영어"라는 단어를 앱스토어에 검색했을때의 결과를 가져온다.
    
    queryService.getSearchResults(searchTerm:"영어") { results, errorMessage in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      if let results = results {
        self.articles = results
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
      }
      if !errorMessage.isEmpty { print("error: " + errorMessage) }
    }
    
    
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //implement feedmodeldelegate protocol func
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return articles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //get a cell to reuse
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell", for: indexPath)
    
    let descLb = cell.viewWithTag(1) as? UILabel
    let titleLb = cell.viewWithTag(2) as? UILabel
    
    let article = articles[indexPath.row]
    
    if let actualLabel = titleLb {
      actualLabel.text = article.articleTitle
    }
    if let authorlb = descLb {
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
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if (indexPath.row == expandIndexPath && expanable == true){
      
      return CGSize(width: screenWidth / 1.5, height: screenWidth / 1.5)
      
    }else {
      
      return CGSize(width: screenWidth / 2.1, height: screenWidth / 2.1)
    }
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    selectedArticle = articles[indexPath.row]
    
    //Boolean 값으로 크기변화를 줄지 말지 결정
    expanable = !expanable
    //특정 인덱스를 변수에 할당
    expandIndexPath = indexPath.row
    //특정 인덱스만 새로 로딩
    collectionView.reloadItems(at: [indexPath])
    
    
  }
  
}


