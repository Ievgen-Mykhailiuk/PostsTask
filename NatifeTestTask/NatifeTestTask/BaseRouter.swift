//
//  BaseRouter.swift
//  NatifeTestTask
//
//  Created by Евгений  on 01/09/2022.
//

import UIKit

typealias EmptyBlock = () -> Void

protocol BaseModuleRouter: AnyObject {
    func show(viewController: UIViewController,
              isModal: Bool,
              animated: Bool,
              completion: EmptyBlock?)
    
    func close(animated: Bool,
               completion: EmptyBlock?)
    
    func goBack(to viewController: UIViewController,
                animated: Bool,
                completion: EmptyBlock?)
}

class BaseRouter: BaseModuleRouter {
    
    //MARK: - Properties
    private let viewController: UIViewController
    private var navigationController: UINavigationController?  {
        return viewController.navigationController
    }
    
    //MARK: - Life Cycle
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    //MARK: - Base protocol methods
    func show(viewController: UIViewController,
              isModal: Bool,
              animated: Bool,
              completion: EmptyBlock?) {
        let presentingViewController = navigationController ?? self.viewController
        if isModal {
            presentingViewController.present(viewController,
                                             animated: animated,
                                             completion: completion)
        } else {
            navigationController?.pushViewController(viewController,
                                                     animated: animated,
                                                     completion: completion)
        }
    }
    
    func close(animated: Bool,
               completion: EmptyBlock?) {
        if viewController.isModal {
            if let navigationController = navigationController {
                navigationController.dismiss(animated: animated,
                                             completion: completion)
            } else {
            viewController.dismiss(animated: animated,
                                   completion: completion)
            }
        } else {
            navigationController?.popViewController(animated: animated,
                                                    completion: completion)
        }
    }
    
    func goBack(to viewController: UIViewController,
                animated: Bool,
                completion: EmptyBlock?) {
        navigationController?.popToViewController(viewController,
                                                  animated: animated,
                                                  completion: completion)
    }
}

