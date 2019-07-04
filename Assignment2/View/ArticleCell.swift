//
//  ArticleCell.swift
//  Assignment2
//
//  Created by QUALSON_MACBOOKPRO_2012_15 on 02/07/2019.
//  Copyright © 2019 ASPN. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    static let Identifier = "ArticleCell"
    
    @IBOutlet  var mainImg: UIImageView!
    @IBOutlet  var titlelb: UILabel!
    @IBOutlet  var companylb: UILabel!
    
    func configureWithChocolate(article: Article) {
        
        if article.articleImageUrl != "" {
            
            if let actualImageView = mainImg {
                
                let url = URL(string: article.articleImageUrl)
                if let actualUrl = url {
                    let request = URLRequest(url: actualUrl)
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error ) in
                        //fire off this work to update the ui to the main thread
                        //사용자가 눈치채기전에 이미지 교환
                        DispatchQueue.main.async {
                            //the data has been downloaded. create a uiimage objet and assign it into the imageview
                            if let actualData = data {
                                actualImageView.image = UIImage(data:actualData)
                            }
                            
                        }
                    })
                    
                    titlelb.text = article.articleTitle
                    
                    companylb.text = article.articleDescription
                    //fire off the data task
                    dataTask.resume()
                    
                }
                
                
            }
            
            
        }else{
            //artilce has no image url, so set the imageview to nil image
            if let actualImageView = mainImg {
                actualImageView.image = nil
            }
        }
        
    }
}
