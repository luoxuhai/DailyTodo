//
//  AppDelegate.swift
//  SyncKitCoreDataExample
//
//  Created by Manuel Entrena on 08/06/2019.
//  Copyright © 2019 Manuel Entrena. All rights reserved.
//

import UIKit
import RealmSwift
import SyncKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var realm: Realm!
    var settingsManager = SettingsManager()
    var settingsViewController: SettingsViewController?
    
    var synchronizer: CloudKitSynchronizer?
    lazy var sharedSynchronizer = CloudKitSynchronizer.sharedSynchronizer(containerName: "your-iCloud-container", configuration: self.realmConfiguration)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        settingsManager.delegate = self
        loadRealm()
        loadSyncKit()
        loadPrivateModule()
        loadSharedModule()
        loadSettingsModule()
        
        return true
    }
    
    func loadSyncKit() {
        if settingsManager.isSyncEnabled {
            synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "your-iCloud-container", configuration: self.realmConfiguration)
        }
    }
    
    func loadPrivateModule() {
        let tabBarController: UITabBarController! = window?.rootViewController as? UITabBarController
        let navigationController: UINavigationController! = tabBarController.viewControllers?[0] as? UINavigationController
        let employeeWireframe = RealmEmployeeWireframe(navigationController: navigationController,
                                                          realm: realm)
        let companyWireframe = RealmCompanyWireframe(navigationController: navigationController,
                                                         realm: realm,
                                                         employeeWireframe: employeeWireframe,
                                                         synchronizer: synchronizer,
                                                         settingsManager: settingsManager)
        companyWireframe.show()
    }
    
    func loadSharedModule() {
        let tabBarController: UITabBarController! = window?.rootViewController as? UITabBarController
        let sharedNavigationController: UINavigationController! = tabBarController.viewControllers?[1] as? UINavigationController
        let realmSharedWireframe = RealmSharedCompanyWireframe(navigationController: sharedNavigationController,
                                                               synchronizer: sharedSynchronizer,
                                                               settingsManager: settingsManager)
        realmSharedWireframe.show()
    }
    
    func loadSettingsModule() {
        let tabBarController: UITabBarController! = window?.rootViewController as? UITabBarController
        let settingsNavigationController: UINavigationController! = tabBarController.viewControllers?[2] as? UINavigationController
        settingsViewController = settingsNavigationController.topViewController as? SettingsViewController
        settingsViewController?.settingsManager = settingsManager
        settingsViewController?.privateSynchronizer = synchronizer
    }

    // MARK: - Core Data stack
    
    func loadRealm() {
        realm = try! Realm(configuration: realmConfiguration)
    }
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        let container = CKContainer(identifier: cloudKitShareMetadata.containerIdentifier)
        let acceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        acceptSharesOperation.qualityOfService = .userInteractive
        acceptSharesOperation.acceptSharesCompletionBlock = { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                } else {
                    self?.sharedSynchronizer.synchronize(completion: nil)
                }
            }
        }
        container.add(acceptSharesOperation)
    }
    
    lazy var realmConfiguration: Realm.Configuration = {
        var configuration = Realm.Configuration()
        configuration.schemaVersion = 1
        configuration.migrationBlock = { migration, oldSchemaVersion in
            
            if (oldSchemaVersion < 1) {
            }
        }
        
        #if USE_INT_KEY
        configuration.objectTypes = [QSCompany_Int.self, QSEmployee_Int.self]
        #else
        configuration.objectTypes = [QSCompany.self, QSEmployee.self]
        #endif
        return configuration
    }()
}

extension AppDelegate: SettingsManagerDelegate {
    func didSetSyncEnabled(value: Bool) {
        if value == false {
            synchronizer?.eraseLocalMetadata()
            synchronizer = nil
            settingsViewController?.privateSynchronizer = nil
            loadPrivateModule()
            
        } else {
            connectSyncKit()
        }
    }
    
    func connectSyncKit() {
        let alertController = UIAlertController(title: "Connecting CloudKit", message: "Would you like to bring existing data into CloudKit?", preferredStyle: .alert)
        let keepData = UIAlertAction(title: "Keep existing data", style: .default) { (_) in
            self.createNewSynchronizer()
        }
        
        let removeData = UIAlertAction(title: "No", style: .destructive) { (_) in
            #if USE_INT_KEY
            let interactor = RealmCompanyInteractor_Int(realm: self.realm,
                                                        shareController: nil)
            #else
            let interactor = RealmCompanyInteractor(realm: self.realm,
                                                    shareController: nil)
            #endif
            
            interactor.load()
            interactor.deleteAll()
            self.createNewSynchronizer()
        }
        alertController.addAction(keepData)
        alertController.addAction(removeData)
        settingsViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func createNewSynchronizer() {
        loadSyncKit()
        settingsViewController?.privateSynchronizer = synchronizer
        loadPrivateModule()
    }
}
