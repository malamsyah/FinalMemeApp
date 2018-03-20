//
//  DetailViewController.swift
//  FinalMemeApp
//
//  Created by Mochammad Alamsyah on 20/03/18.
//  Copyright © 2018 malamsyah.id. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    @IBOutlet weak var memeImageView:UIImageView!
    var meme:Meme!
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = meme.memeImage
        
    }
    
}
