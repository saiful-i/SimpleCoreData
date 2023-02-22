//
//  CoreDataService.swift
//  SimpleCoreData
//
//  Created by Saiful Islam on 12/02/23.
//

import CoreData
import UIKit

class CoreDataService {
    func create(firstName: String, lastName: String, email: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let viewContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: viewContext)
        
        let insert = NSManagedObject(entity: userEntity!, insertInto: viewContext)
        insert.setValue(firstName, forKey: "first_name")
        insert.setValue(lastName, forKey: "last_name")
        insert.setValue(email, forKey: "email")

        do {
            try viewContext.save()
        } catch let error {
            print("Fail save user entity, reason: \(error)")
        }
    }
    
    
    func retrieve() -> [UserModel] {
        var users = [UserModel]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { user in
                users.append(
                    UserModel(
                        firstName: user.value(forKey: "first_name") as! String,
                        lastName: user.value(forKey: "last_name") as! String,
                        email: user.value(forKey: "email") as! String
                    )
                )
            }
        } catch let error {
            print(error)
        }
        
        return users
    }
    
    func update(_ firstName:String, _ lastName:String, _ email:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        
        do {
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            dataToUpdate.setValue(firstName, forKey: "first_name")
            dataToUpdate.setValue(lastName, forKey: "last_name")
            dataToUpdate.setValue(email, forKey: "email")
            
            try managedContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func delete(_ email:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        
        do {
            let dataToDelete = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            managedContext.delete(dataToDelete)
            
            try managedContext.save()
        } catch let err {
            print(err)
        }
    }
}
