//
//  todoManager.swift
//  femkevanson-pset5
//
//  Created by Femke van Son on 30-11-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import Foundation
import SQLite


// class makes toDoList global for the entire project
class TodoManager{
    
    static let sharedInstance = TodoManager()
    

    private let todoListTable = Table("todoListTable")
    private let todolistItemTable = Table("todolistItemTable")
   
    private let id = Expression<Int64>("id")
    private let listId = Expression<Int64>("listId")
    
    private let todoListName = Expression<String?>("todoListName")
    private let todoItem = Expression<String?>("todoItem")
    private let check = Expression<Int>("check")
   
    private var db: Connection?
    
    
    // initialise data file
    private init? () {
        
        do {
            
            try setupDataBase()
            
        } catch {
            
            print (error)
            return nil
            
        }
    }
    
    private func setupDataBase() throws {
        
        // use to save the data in path
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            
            db = try Connection("\(path)/db.sqlite3")
            try createTableList()
            try createTableItem()
            
        } catch {
            throw error
            
        }
        
        // deletes whole list
        //try db?.run(todoListTable.delete())
    }
    
    //function to create table with columnns
    private func createTableList() throws {
        
        do {
            try db!.run(todoListTable.create(ifNotExists: true) {
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(todoListName)
                
            })
            
        } catch {
            
            throw error
        }
    }
    
    private func createTableItem() throws {
        
        do {
            try db!.run(todolistItemTable.create(ifNotExists: true) {
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(todoItem)
                t.column(listId)
                t.column(check, defaultValue: 0)
            })
            
        } catch {
            
            throw error
        }
    }
    
    func getID(nameList: String) -> Int64 {
        
        var listId = Int64()
        
        do {
            for item in try db!.prepare(todoListTable) {
                if (item[todoListName]! == nameList) {
                    listId = item[id]
                    print (listId)
                    break
                }
            }
        } catch {
            print("error")
        }
        return listId
    }
    
    
    
    // adding a new todoList in data base
    func createList(todoList: String) throws {
        
        let insert = todoListTable.insert(self.todoListName <- todoList)
        do {
            
            let rowID = try db!.run(insert)
            print (rowID)
            
        } catch {
            
            throw error
            
        }
        
    }
    
    // adding a new todoItem (list) at the right to do list, with default checked = false
    func createItem(todoList: String, listID: Int64) throws {
        
        let insert = todolistItemTable.insert(self.todoItem <- todoList, self.listId <- listID)
        do {
            
            let rowID = try db!.run(insert)
            print (rowID)
            
        } catch {
            
            throw error
            
        }
    }
    
    func changeCheck(todoList: String, value: Int) throws {

        let change = todolistItemTable.filter(self.todoItem == todoList)
        print("change is : \(change)")
        print ("value is: \(value)")
        
        do {
            let checked = try db!.run(change.update(self.check <- value)) 
        } catch {
            print ("error in update")
        }
        
    }
    
    func readCheck(todoList: String) throws -> Int {
        print ("hier gaat het mis")
        let query = todolistItemTable.filter(todoItem == todoList)
        
        print ("of hier gaat het mis")
        do {
            print ("of of hier gaat het mis")
            var state = Int()
            for user in try db!.prepare(query) {
                state = user[self.check]
                print ("of of of hier gaat het mis")
            }
            print("Int \(state)")
            return state
            
        } catch {
            throw error
        }
    }
    

    
    // function to read from database, returns array of all the elements
    func readList() throws  -> [String] {
        
        var result = [String]()
        for user in try db!.prepare(todoListTable.select(todoListName)) {
            
            result.insert(user[todoListName]!, at: 0)
            
        }
        print (result)
        return result
    }
    
    func readItem(id: Int64) throws  -> [String] {
        
        var result = [String]()
        for user in try db!.prepare(todolistItemTable) {
            if user[listId] == id {
                result.append(user[todoItem]!)
            }
        }
        print (result)
        return result
    }
    
    // deleting note of the selected row
    func delete(taskName: String) throws {
        let deletedRows = todoListTable.filter(todoListName == taskName)
        
        do {
            try db!.run(deletedRows.delete())
            print ("deleted")
        } catch {
            throw error
        }
    }
    
    func deleteItem(taskName: String) throws {
        let deletedRows = todolistItemTable.filter(todoItem == taskName)
        
        do {
            try db!.run(deletedRows.delete())
            print ("deleted")
        } catch {
            throw error
        }
    }

    
}
