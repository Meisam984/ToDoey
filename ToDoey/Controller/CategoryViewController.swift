//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Meisam Rezaei on 1/8/19.
//  Copyright © 2019 Meysam Rezaeei. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Added Category yet!"
        return cell
    }
    
    //MARK: - Data Manipulation Methods -
    func loadCategories() {
//        //TODO: loading Data from Realm
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    func save(category : Category) {
        //TODO: Saving Data to CoreData
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving,\(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "New Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
}
