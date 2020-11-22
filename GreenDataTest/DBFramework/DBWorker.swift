//
//  File.swift
//  GreenDataTest
//
//  Created by yaruncle on 11.11.2020.
//  Copyright © 2020 yaruncle. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// Класс управления базой данных
class DBWorker{
    
    // Получение контекста
    static func coreDataContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // Функция сохранения данных в БД
    static func savePersonOnDB(users : Array<Person>) {
        
        var completeArray: [EPerson]?
        
        for i in users {
            var newPerson = EPerson(context: self.coreDataContext())
            newPerson = i.convertToEntity(context: newPerson)
            completeArray?.append(newPerson)
        }
            
            do{
            try
            self.coreDataContext().save()
                    }
                    catch{
                }
    }
    
    // Функция удаления данных из БД
    static func deleteEntites(entity: String) {
        let managedContext = coreDataContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}
