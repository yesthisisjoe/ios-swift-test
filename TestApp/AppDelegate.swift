//
//  AppDelegate.swift
//  TestApp
//
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationWillTerminate(_ application: UIApplication) {
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TestApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                let errorAlert = UIAlertController(title: "Core Data Error", message: "There was an error loading persistent stores. \(error), \(error.userInfo)", preferredStyle: .alert)
                self.window?.rootViewController?.present(errorAlert, animated: true)
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                let errorAlert = UIAlertController(title: "Core Data Error", message: "There was an error saving the core data context. \(nserror), \(nserror.userInfo)", preferredStyle: .alert)
                window?.rootViewController?.present(errorAlert, animated: true)
            }
        }
    }

}

