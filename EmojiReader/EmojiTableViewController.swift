//
//  EmojiTableViewController.swift
//  EmojiReader
//
//  Created by Tigran on 11/6/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var objects = [
        Emoji(emoji: "🥰", name: "Love", description: "Love each other", isFavourite: false),
        Emoji(emoji: "😎", name: "Cool", description: "Coolest emoji", isFavourite: false),
        Emoji(emoji: "⚽️", name: "Football", description: "Let's play football together", isFavourite: false)
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.title = "Emoji Reader"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
    }
    
    // MARK: - Table view data source
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        guard unwindSegue.identifier == "saveSegue" else {return}
        let sourceVC = unwindSegue.source as! NewEmojiTableViewController
        let emoji = sourceVC.emoji
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            objects[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            objects.append(emoji)
            let newIndexPath = IndexPath(row: objects.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let navVC = segue.destination as? UINavigationController else{return}
        guard let newEmojiVC = navVC.topViewController as? NewEmojiTableViewController else {return}
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = objects[indexPath.row]
        
        newEmojiVC.emoji = emoji
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
        let object = objects[indexPath.row]
        
        cell.set(object: object)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = objects.remove(at: sourceIndexPath.row)
        objects.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done,favourite])
    }
    func doneAction(at indexpath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") {(action ,view, completion) in
            
            self.objects.remove(at: indexpath.row)
            self.tableView.deleteRows(at: [indexpath], with: .fade)
            completion(true)
            
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "chekmark.circle")
        return action
    }
    
    func favouriteAction(at indexpath: IndexPath) -> UIContextualAction {
        var object = objects[indexpath.row]
        let action = UIContextualAction(style: .normal, title: "Favourite") {(action, view , completeion) in
            object.isFavourite = !object.isFavourite
            self.objects[indexpath.row] = object
            completeion(true)
            
        }
        if object.isFavourite == true {
            action.backgroundColor = .systemPurple
        }else {
            action.backgroundColor = .systemGray
        }
        action.image = UIImage(systemName: "heart")
        return action
    }
    
}
