//
//  SettingsViewController.swift
//  Road Capture
//
//  Created by Kelvin Boatey on 2/18/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit

class HelpViewController: UIPageViewController {

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            newViewController(name: "Help Page 0"),
            newViewController(name: "Help Page 1"),
            newViewController(name: "Help Page 2"),
            newViewController(name: "Help Page 3"),
            newViewController(name: "Help Page 4"),
            newViewController(name: "Help Page 5"),
            newViewController(name: "Help Page 6"),
            newViewController(name: "Help Page 7"),
            newViewController(name: "Help Page 8"),
            newViewController(name: "Help Page 9"),
            newViewController(name: "Help Page 10"),
            newViewController(name: "Help Page 11"),
            newViewController(name: "Help Page 12"),
            newViewController(name: "Help Page 13"),
            newViewController(name: "Help Page 14")
        ]
    }()
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
    }
}
extension HelpViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
