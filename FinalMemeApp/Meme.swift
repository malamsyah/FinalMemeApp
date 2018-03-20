//
//  Meme.swift
//  FinalMemeApp
//
//  Created by Mochammad Alamsyah on 20/03/18.
//  Copyright © 2018 malamsyah.id. All rights reserved.
//

import UIKit

struct Meme {
    let topText:String!
    let bottomText:String!
    let originalImage:UIImage!
    let memeImage:UIImage!
    
    init(topText:String, bottomText:String, originalImage:UIImage, memeImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
}
