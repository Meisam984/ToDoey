//
//  ViewController.swift
//  ToDoey
//
//  Created by Meisam Rezaei on 12/31/18.
//  Copyright © 2018 Meysam Rezaeei. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

// TODO: - create a UIViewTableController to add a new todo item and delete it -
class ToDoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let hexColor = selectedCategory?.color else {fatalError()}
        title = selectedCategory!.name
        updateNavBar(withHexCode: hexColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else { fatalError() }
        updateNavBar(withHexCode: originalColor.hexValue())
    }
    
    //MARK: NavigationBarController methods
    func updateNavBar(withHexCode colorHexCode : String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("No Navigation Bar")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        searchBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
    }

    // MARK: - Tableview Datasource Methods -

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Number Of Rows
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //TODO: Create the Reusable Cell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            guard let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) else {fatalError()}
                
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added yet!"
        }
        return cell
    }

    // MARK: - Tableview Delegate Methods -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // TODO: Define the accessory type of the selected item
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error changing accessory type,\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // TODO: delete items from Realm
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemToDelete = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting item,\(error)")
            }
        }
    }

    //MARK: - Add New Items -
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        //TODO: create the UIAlertController to add a new item
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            //TODO: creat the AppDelegate context for coreData
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)   
                    }
                } catch {
                   print(error)
                }
            }
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

    //MARK: load items from Realm
    func loadItems()  {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - UISearchBar Delegate Methods -
extension ToDoListViewController : UISearchBarDelegate {


    //TODO: define the database query format
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
