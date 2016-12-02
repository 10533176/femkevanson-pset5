//
//  MasterViewController.swift
//  femkevanson-pset5
//
//  Created by Femke van Son on 30-11-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit

let db = TodoManager.sharedInstance

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var text = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()

        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newName(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    // read data from database
    func read() {
        do {
            text = try db!.readList()
        } catch {
            print (error)
        }
    }
    
    func createList(todoListName: String) {
        do {
            try db!.createList(todoList: todoListName)
        } catch {
            print (error)
        }
        read()
        reloadTableView()
    }
    
    
    func newName(_ sender: Any) {
        // Make alert
        let alertNewList = UIAlertController(title: "New list", message: "Enter a name", preferredStyle: .alert)
        
        alertNewList.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "Type a name"
        }
        
        alertNewList.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = alertNewList.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            
            // Use string in textfield to create new list
            if textField.text == "" {
                print("Error: fill in a name to create a new list")
            }
            else {
                
                if self.text.contains(textField.text!) {
                    print("Error: this list already exists")
                }
                else {
                    self.createList(todoListName: textField.text!)
                    self.read()
                    self.reloadTableView()
                }
                textField.text = ""
            }
        }))
        self.present(alertNewList, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let object = text[indexPath.row]

                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                controller.listName = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = text[indexPath.row]
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let task = text[indexPath.row]
            
            do {
                try db!.delete(taskName: task)
            } catch {
                print ("error deleting task")
            }
            
            read()
            reloadTableView()

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

