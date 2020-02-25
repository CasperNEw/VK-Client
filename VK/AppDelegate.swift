//
//  AppDelegate.swift
//  VK
//
//  Created by Дмитрий Константинов on 26.11.2019.
//  Copyright © 2019 Дмитрий Константинов. All rights reserved.
//

import UIKit
import RealmSwift
import KeychainAccess
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Google Firebase Analytics
        FirebaseApp.configure()
        
        if #available(iOS 13, *) { /* Наверное перемудрил =) */ } else {
            let keychain = Keychain(service: "UserSecrets")
            //Делаем проверку на валидность токена по времени
            if let expireIn = Int(keychain["expiresIn"] ?? "0") {
                //На всякий случай компенсируем час
                let realTime = Int(Date().timeIntervalSince1970) + 3600
                if expireIn > realTime {
                    if let token = keychain["token"], let userId = keychain["userId"] {
                        
                        window = UIWindow(frame: UIScreen.main.bounds)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainView")
                        window?.rootViewController = UINavigationController(rootViewController: tabBarVC)
                        window?.makeKeyAndVisible()
                        
                        //присваиваем значения нашему singleton instance
                        Session.instance.token = token
                        Session.instance.userId = userId
                        Session.instance.version = "5.103"
                        
                        print("[Logging] [Keychain] Token exist")
                        print("[Logging] [Keychain] \(token)")
                        print("[Logging] [Keychain] Expires through : " + String(((expireIn - realTime) % 86400) / 3600) + " hours," + String(((expireIn - realTime) % 3600) / 60) + " minutes," + String(((expireIn - realTime) % 3600) % 60) + " seconds")
                    } else {
                        print("[Logging] [Keychain] Token not exist")
                    }
                }
            }
        }
        
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        print(config.fileURL as Any)
        
        
        /*
         
         //Шифрование БД Realm
         if let key = keychain.getKey {
            let config = Realm.Configuration(encryptionKey: key, schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
         } else {
            var key = key.withUnsafeMutableBytes { bytes in
                SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
                записываем в keychain
                let config = Realm.Configuration(encryptionKey: key, schemaVersion: 1)
                Realm.Configuration.defaultConfiguration = config
         }
         */
        
        /*
        //Конфигурация миграции БД Realm
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) { /*Migration code*/ }
            })
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
         // realm.deleteAll() //Принудительное очищение БД
        */
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

