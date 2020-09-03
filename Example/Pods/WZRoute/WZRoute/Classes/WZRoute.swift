//
//  WZRoute.swift
//  WZRoute
//
//  Created by xiaobin liu on 2019/7/29.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import UIKit


/// MARK - 路由
public class WZRoute {
    
    /// 完成类型别名
    public typealias Completion = (() -> Swift.Void)?
    
    /// push
    ///
    /// - Parameters:
    ///   - viewController: 需要跳转的控制器
    ///   - animated: 是否动画(默认: true)
    ///   - completion: 动画完成回掉(默认: nil)
    open class func push(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {
        
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return
        }
        viewController.hidesBottomBarWhenPushed = true
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.pushViewController(viewController, animated: animated)
        CATransaction.commit()
        
    }
    
    
    /// pop
    ///
    /// - Parameters:
    ///   - animated: 是否动画(默认: true)
    ///   - completion: completion(默认: nil)
    open class func pop(_ animated: Bool = true, completion: Completion = nil) {
        
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.popViewController(animated: animated)
        CATransaction.commit()
    }
    

    /// popRoot
    ///
    /// - Parameters:
    ///   - animated: 是否动画(默认: true)
    ///   - completion: completion(默认: nil)
    open class func popRoot(_ animated: Bool = true, completion: Completion = nil) {
        
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
    
    /// present
    ///
    /// - Parameters:
    ///   - viewController: 需要跳转的控制器
    ///   - animated: 是否动画(默认: true)
    ///   - completion: completion(默认: nil)
    open class func present(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {
        
        guard let fromViewController = UIViewController.topMost else { return  }
        DispatchQueue.main.async {
          fromViewController.present(viewController, animated: animated, completion: completion)
        }
    }
    
    
    /// dismiss
    ///
    /// - Parameters:
    ///   - animated: 是否动画(默认: true)
    ///   - completion: completion(默认: nil)
    open class func dismiss(animated: Bool = true, completion: Completion = nil) {
        
        guard let fromViewController = UIViewController.topMost else { return  }
        fromViewController.view.endEditing(true)
        fromViewController.dismiss(animated: animated, completion: completion)
    }
    
    
    /// showDetail
    ///
    /// - Parameters:
    ///   - viewController: viewController description
    ///   - sender: sender description
    ///   - completion: Completion
    open class func showDetail(_ viewController: UIViewController, sender: Any?, completion: Completion = nil) {
        
        guard let fromViewController = UIViewController.topMost else { return  }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        fromViewController.showDetailViewController(viewController, sender: sender)
        CATransaction.commit()
    }
    
    
    /// setViewControllers
    ///
    /// - Parameters:
    ///   - viewControllers: viewControllers description
    ///   - animated: animated description
    ///   - completion: Completion
    open class func setViewControllers(_ viewControllers: [UIViewController], animated: Bool = true, completion: Completion = nil) {
        
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.setViewControllers(viewControllers, animated: animated)
        CATransaction.commit()
    }
    
    
    /// 获取Window上面的根控制器
    ///
    /// - Returns: <#return value description#>
    open class func rootViewController() -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    /// 跳转新控制器移除上个控制器
    /// - Parameters:
    ///   - viewController: viewControllers description
    ///   - animated: animated description
    ///   - completion: Completion
    open class func setViewControllerRemoveLast(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return
        }
        var temArray: [UIViewController] = navigationController.viewControllers.dropLast()
        temArray.append(viewController)
        setViewControllers(temArray, animated: animated, completion: completion)
    }
    
    /// 跳转新控制器移除某个控制器
    /// - Parameters:
    ///   - viewController: viewControllers description
    ///   - animated: animated description
    ///   - completion: Completion
    open class func setViewControllerRemoveCurrent(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return
        }
        var temArray: [UIViewController] = []
        for vc in navigationController.viewControllers {
            if vc.classForCoder != viewController.classForCoder {
                temArray.append(vc)
            }
        }
        temArray.append(viewController)
        setViewControllers(temArray, animated: animated, completion: completion)
    }
}


// MARK: - Methods
public extension UIViewController {
    
    /// sharedApplication
    private class var sharedApplication: UIApplication? {
        let selector = NSSelectorFromString("sharedApplication")
        return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
    }
    
    
    /// 返回当前应用程序的最顶层视图控制器。
    class var topMost: UIViewController? {
        
        guard let currentWindows = self.sharedApplication?.windows else { return nil }
        var rootViewController: UIViewController?
        for window in currentWindows {
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        
        return self.topMost(of: rootViewController)
    }
    
    
    /// 返回给定视图控制器堆栈中最顶层的视图控制器
    ///
    /// - Parameter viewController: viewController description
    /// - Returns: return value description
    class func topMost(of viewController: UIViewController?) -> UIViewController? {
        
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        return viewController
    }
}
