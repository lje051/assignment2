//
//  CollectionViewController.swift
//  Assignment2
//
//  Created by Jeeeun Lim on 17/06/2019.
//  Copyright © 2019 ASPN. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var expandIndexPath : Int = 0
    var expanable = false
    var articles = [Article]()
    var selectedArticle:Article?
    let queryService = QueryService()
    let screenWidth = UIScreen.main.bounds.width
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: PinterestLayoutDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
        //    layout.itemSize = CGSize(width: screenWidth / 2.1, height: screenWidth / 2.7)
        //    collectionView!.collectionViewLayout = layout
        
        
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self as PinterestLayoutDelegate
        }
        
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        let article = articles[indexPath.row]
        
         cell.configureWithChocolate(article: article)
        
        return cell
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

//MARK: - PINTEREST LAYOUT DELEGATE
extension CollectionViewController : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
//        let image = comics[indexPath.row].image
//        let aspectRatioImg = image.size.height / image.size.width

        return 100
    }
    
}


