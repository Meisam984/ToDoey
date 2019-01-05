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
    //TODO: define the file path to save data
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // TODO: read itemArray from dataFilePath plist
        loadItems()
    }

    // MARK: - Tableview Datasource Methods -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Number Of Rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: Create the Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    // MARK: - Tableview Delegate Methods -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: Define the accessory type of the selected item
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.reloadData()
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
            //TODO: save itemArray in a plist in dataFilePath
            self.saveItems()
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
    
    //MARK: save data method
    func saveItems () {
        //TODO: encode itemArray into a plist
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to : dataFilePath!)
        } catch{
            print("Error encoding!\(error)")
        }
    }
    
    func loadItems() {
        //TODO: decode dataFilePath into itemArray
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print("Error decoding!\(error)")
            }
            
        }
    }
    

}


