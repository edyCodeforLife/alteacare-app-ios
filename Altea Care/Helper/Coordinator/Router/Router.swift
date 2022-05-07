//
//  Router.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

protocol Router: Presentable {
    
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, isWrapNavigation: Bool)
    func present(_ module: Presentable?, mode: PresentMode)
    func present(_ module: Presentable?, animated: Bool, mode: PresentMode, isWrapNavigation: Bool)
    
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable?, animated: Bool, hideBar: Bool, hideBottomBar: Bool, completion: (() -> Void)?)
    func pushPanModal(_ module: Presentable?)

    func popModule()
    func popModule(animated: Bool)
    
    func popToModule(_ module: Presentable?, animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func dismissPanModal()

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func setRootModule(_ module: Presentable?, hideBar: Bool, animation: RouterImpl.Animation)
    func setRootModule(_ module: Presentable?, completion: (() -> Void)?)
    func popToRootModule(animated: Bool)
}

enum PresentMode {
    case overContext
    case fullScreen
    case basic
}
