//
//  GridViewController.swift
//  FinalMemeApp
//
//  Created by Mochammad Alamsyah on 19/03/18.
//  Copyright © 2018 malamsyah.id. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var plusButton = UIBarButtonItem()
    var memes = [Meme]()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TableViewController.newMeme))
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = plusButton
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        self.collectionView?.reloadData()
    }
    
    @objc func newMeme(){
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "CreateMeme", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateMeme" {
            if let _ = segue.destination as? CreateMemeViewController {
                
            }
        }
    }
    
    func updateData(){
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeGridCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.memeImageView?.image = meme.memeImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        detailViewController.meme   = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    

    
    
    
}

