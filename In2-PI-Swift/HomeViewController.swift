//
//  ViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Localization example
//        let name = String(format: NSLocalizedString("name", comment: ""))
//        //this comment param for NSLocalizedString is really annoying and unnecessary because you can't set it to nil
//        let msg = String(format: NSLocalizedString("Hello %@", comment: ""), name)
//     
//        println(msg)
        
        var navbarOnnuriLogoImage = UIImage(named: "in2Icon44")
        self.navigationItem.titleView = UIImageView(image: navbarOnnuriLogoImage)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        return cell
    }
    

}

