//
//  ViewController.swift
//  ToDoey
//
//  Created by Meisam Rezaei on 12/31/18.
//  Copyright © 2018 Meysam Rezaeei. All rights reserved.
//

import UIKit

// TODO: - create a UIViewTableController to add a new todo item and delete it -

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // TODO: read itemArray from defaults
        
        
        if let items = defaults.array(forKey: "ToDoListItemArray") as? [Item] {
            itemArray = items
        }
    }

    // MARK: - Tableview Datasource Methods -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Number Of Rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: Create the Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        return cell
    }

    // MARK: - Tableview Delegate Methods -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: Define the accessory type of the selected item
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items -
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //TODO: create the UIAlertController to add a new item
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //TODO: what will happen once the user clicks the add item button
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            //TODO: save itemArray in a UserDefaults var called defaults
            self.defaults.set(self.itemArray, forKey: "ToDoListItemArray")
            self.tableView.reloadData()
        }
        
        //TODO: UIAlertController TextField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}


