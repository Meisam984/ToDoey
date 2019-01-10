//
//  ViewController.swift
//  ToDoey
//
//  Created by Meisam Rezaei on 12/31/18.
//  Copyright © 2018 Meysam Rezaeei. All rights reserved.
//

import UIKit
import CoreData

// TODO: - create a UIViewTableController to add a new todo item and delete it -
class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
            
            //TODO: creat the AppDelegate context for coreData
            let newItem = Item(context: self.context!)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            //TODO: save itemArray in DB
            self.saveItems()
            self.tableView.reloadData()
        }
        
        //TODO: UIAlertController TextField
        alert.addTextField { (field) in
            field.placeholder = "create new Category"
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: save data method
    func saveItems () {
    
        do{
            try context?.save()
        } catch{
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil)  {
        
        //TODO: decode dataFilePath into itemArray
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try (context?.fetch(request))!
        } catch {
            print("Error fetching Items \(error)")
        }
        tableView.reloadData()
    }
    
}
//MARK: - UISearchBar Delegate Methods -
extension ToDoListViewController : UISearchBarDelegate {
    
    
    //TODO: define the database query format
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate )
    }
    
    //TODO: back to original list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}
