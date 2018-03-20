//
//  TableViewController.swift
//  FinalMemeApp
//
//  Created by Mochammad Alamsyah on 19/03/18.
//  Copyright © 2018 malamsyah.id. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var plusButton = UIBarButtonItem()
    var memes = [Meme]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TableViewController.newMeme))
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateData()
        self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "memeCell")!
        let meme = self.memes[indexPath.row]
        cell.textLabel?.text = meme.topText! + " ... " + meme.bottomText!
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = meme.memeImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        detailViewController.meme   = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }


}

