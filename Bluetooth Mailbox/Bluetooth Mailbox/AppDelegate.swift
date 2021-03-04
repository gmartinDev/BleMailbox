//
//  AppDelegate.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 2/2/21.
//

import UIKit
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpMainView()
        return true
    }

    private func setUpMainView() {
        let mainWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        let packagesVC = createPackageListVC()
        let navController = UINavigationController(rootViewController: packagesVC)
        navController.navigationBar.isTranslucent = false
        mainWindow.rootViewController = navController
        mainWindow.makeKeyAndVisible()
        window = mainWindow
    }
    
    private func createPackageListVC() -> PackageListViewController {
        let mailBox = MailboxModel(name: "EP1", uuid: UUID().uuidString)
        let mailboxBleService = MailboxBluetoothService(mailbox: mailBox)
        return PackageListViewController(mailboxService: mailboxBleService)
    }
}

