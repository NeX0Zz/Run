import UIKit

class TabBarVIewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        let HomeViewController = createNavController(vc: HomeViewController(), itemName: "login", itemImage: "house")
        let hViewController = createNavController(vc: TableViewController(), itemName: "tt", itemImage: "square.and.arrow.up.badge.clock.fill")
        
        viewControllers = [HomeViewController,hViewController]
    }
    
    func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController{
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage), tag: 0)
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}
