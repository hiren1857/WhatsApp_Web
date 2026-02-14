//
//  DataManager.swift
//  WhatsApp Web
//
//  Created by mac on 13/06/24.
//

import Foundation
import UIKit
import CoreData

class Generate_Data {
    
    func Save_GenerateCode(context : NSManagedObjectContext, Generate : CodeGenerateData?) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "GenerateEntity",in: context)!
        let data = NSManagedObject(entity: entity,insertInto: context)
        data.setValue(Generate?.img_code, forKey: "img_code")
        data.setValue(Generate?.code_name, forKey: "code_name")
        data.setValue(Generate?.timeStemp, forKey: "timeStemp")
        data.setValue(Generate?.date, forKey: "date")
        do {
            try context.save()
            print("Save")
            return true
        } catch {
            return false
        }
    }
    
    func fetch_GenerateCode_Data(context: NSManagedObjectContext, complation: @escaping ([GenerateEntity]) -> ()) {
        var arrReminder = [GenerateEntity]()
        
        let fetchRequest: NSFetchRequest<GenerateEntity> = GenerateEntity.fetchRequest()
        
        do {
            arrReminder = try context.fetch(fetchRequest)
            complation(arrReminder)
        } catch {
            complation([GenerateEntity]())
        }
    }
    
    func delete_GenerateCode_Data(context: NSManagedObjectContext, selectedProduct: GenerateEntity) -> Bool {
        context.delete(selectedProduct)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func updateGenerateCodeName(context : NSManagedObjectContext, Generate : CodeGenerateData?) -> Bool {
        let fetchRequest = NSFetchRequest<GenerateEntity>(entityName: "GenerateEntity")
        fetchRequest.predicate = NSPredicate(format: "timeStemp = %@", Generate!.timeStemp)
        do {
            let value = try context.fetch(fetchRequest)
            let data = value[0] as NSManagedObject
            data.setValue(Generate?.code_name, forKey: "code_name")
            
            do {
                try context.save()
                return true
            } catch {
                return false
            }
        } catch {
            return false
        }
    }
    
    func deleteAll_GenerateCode_Data(context: NSManagedObjectContext, isQR_Code: Bool) -> Bool {
        let fetchRequest: NSFetchRequest<GenerateEntity> = GenerateEntity.fetchRequest()
        
        let predicate = NSPredicate(format: "isQR_Code == %@", NSNumber(value: isQR_Code))
        fetchRequest.predicate = predicate
        
        do {
            let productsToDelete = try context.fetch(fetchRequest)
            for product in productsToDelete {
                context.delete(product)
            }
            try context.save()
            return true
        } catch {
            return false
        }
    }
}
