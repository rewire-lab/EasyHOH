//
//  ViewController.swift
//  Easy HOH
//
//  Created by Michael Murray on 4/14/20.
//  Copyright © 2020 Michael Murray. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }


    //MARK: - TableView DataSource Mehtods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitItemCell", for: indexPath)
        
//        cell.textLabel?.text = itemArray[indexPath.row]
//        cell.detailTextLabel?.text = String(count)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = String(item.count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].count += 1
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func resetCounts(_ sender: Any) {
        print("got reset")
        for item in itemArray {
            item.count = 0
        }
        saveItems()
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Habit", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks Add Item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.count = 0
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
 
    func saveItems() {
        do {
            try context.save()
            
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetchong data from context \(error)")
        }
    }
    
    
}

