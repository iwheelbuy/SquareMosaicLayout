import UIKit

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let controllerTab = UITabBarController()
        let controllerExample = UINavigationController(rootViewController: ViewController())
        controllerExample.title = "Example"
        let controllerTRMosaicLayout = UINavigationController(rootViewController: TRMosaicLayoutController())
        controllerTRMosaicLayout.title = "TRMosaicLayout"
        let controllerFMMosaicLayout = UINavigationController(rootViewController: FMMosaicLayoutController())
        controllerFMMosaicLayout.title = "FMMosaicLayout"
        controllerTab.setViewControllers([controllerExample, controllerTRMosaicLayout, controllerFMMosaicLayout], animated: false)
        window?.rootViewController = controllerTab
        window?.makeKeyAndVisible()
        return true
    }
}
