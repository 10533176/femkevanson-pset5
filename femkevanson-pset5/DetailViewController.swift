//
//  DetailViewController.swift
//  femkevanson-pset5
//
//  Created by Femke van Son on 30-11-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newItem: UITextField!
    @IBOutlet weak var newItemAdd: UIButton!

    let db = TodoManager.sharedInstance
    
    var listName = String()
    var notes = [String]()
    var note = String()
    var listID = Int64()
    var checkArray = [Int]()
    var check = 0

    func configureView() {
        
        // Update the user interface for the detail item.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set title to list name
        self.title = listName
        self.configureView()
        
        var count = 0
        
        for _ in notes {
            count = count + 1
            print ("count is \(count)")
            print ("check is \(check)")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: [0,count]) as! todoItemTableViewCell
            
            if check == 1 {
                cell.checkButton.setImage(UIImage(named: "tick-check-box-md.png"), for: UIControlState.normal)
            }
            
            if check == 0 {
                cell.checkButton.setImage(UIImage(named: "tick-check-box-md.png"), for: UIControlState.normal)
            }
        }
        
        // read from the right list
        let id = db!.getID(nameList: listName)
        read(list: id)
        reloadTableView()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // when new item is added, add to list and clear text field
    @IBAction func addNewItem(_ sender: AnyObject) {
        note = newItem.text!
        createItem(todoListName: note, listID: listID)
        newItem.text = ""
    }
    
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    // read data from database from the right list
    func read(list: Int64) {
        do {
            listID = list
            notes = try db!.readItem(id: listID)
        } catch {
            print (error)
        }
    }
    
    // add a new item to the todoList items
    func createItem(todoListName: String, listID: Int64) {
        do {
            try db!.createItem(todoList: todoListName, listID: listID)
        } catch {
            print (error)
        }
        read(list: listID)
        reloadTableView()
    }
    
    func check(note: String, value: Int) {
        do {
            print ("loopt door de check functie heen")
            try db!.changeCheck(todoList: note, value: value)
        } catch {
            print (error)
        }
        readcheck(note: note)
    }
    
    func readcheck(note: String) {
        do {
            print ("loopt door de readCheck heen")
            check = try db!.readCheck(todoList: note)
        } catch {
            print (error)
        }
    }


    var detailItem: NSDate? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    // return number of cells for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
        
    }
    
    // function to show to do notes in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! todoItemTableViewCell
        
        cell.todoItem.text = notes[indexPath.row]
        
        return cell
    }
    
    // if row is clicked, mark as checked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! todoItemTableViewCell
        
        if check == 1 {
            cell.checkButton.setImage(UIImage(named: "yTogj4zEc.png"), for: UIControlState.normal)
            check(note: notes[indexPath.row], value: 0)
        }
        
        if check == 0 {
            cell.checkButton.setImage(UIImage(named: "tick-check-box-md.png"), for: UIControlState.normal)
            check(note: notes[indexPath.row], value: 1)
        }
    }

    // function to delete todo item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            check(note: notes[indexPath.row], value: 0)
            let task = notes[indexPath.row]
            
            do {
                try db!.deleteItem(taskName: task)
            } catch {
                print ("error deleting task")
            }
           
            let id = db!.getID(nameList: listName)
            read(list: id)
            reloadTableView()
        }
    }


}

