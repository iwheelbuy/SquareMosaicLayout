import UIKit

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let aaa: ClosedRange<CGFloat> = 0 ... 1
        let bbb: ClosedRange<CGFloat> = 0.5 ... 2.3
        let ccc = aaa.clamped(to: bbb)
        let ddd = bbb.clamped(to: aaa)
        print(ccc, ddd, aaa.overlaps(bbb))

        
        let controllerTab = UITabBarController()
        let controllerExample = UINavigationController(rootViewController: ViewController())
        controllerExample.title = "Example"
//        let controllerTRMosaicLayoutCopy = UINavigationController(rootViewController: TRMosaicLayoutCopyController())
//        controllerTRMosaicLayoutCopy.title = "TRMosaicLayout"
//        let controllerFMMosaicLayoutCopy = UINavigationController(rootViewController: FMMosaicLayoutCopyController())
//        controllerFMMosaicLayoutCopy.title = "FMMosaicLayout"
//        let controllerHungcao = UINavigationController(rootViewController: Hungcao())
//        controllerHungcao.title = "Hungcao"
//        controllerTab.setViewControllers([controllerExample, controllerTRMosaicLayoutCopy, controllerFMMosaicLayoutCopy, controllerHungcao], animated: false)
        controllerTab.setViewControllers([controllerExample], animated: false)
        window?.rootViewController = controllerTab
        window?.makeKeyAndVisible()
        return true
    }
}
