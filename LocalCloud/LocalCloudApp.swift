//
//  LocalCloudApp.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 11.08.2022.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LocalCloudApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var user = UserInfo()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(viewModel: HomeViewViewModel(user: user))
            }
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .background:
                print("background")
            case .inactive:
                print("inactive")
            case .active:
                print("active")
            @unknown default:
                break
            }
        }
    }
}
