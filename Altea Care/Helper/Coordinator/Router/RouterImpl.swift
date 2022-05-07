//
//  RouterImpl.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import UIKit
import PanModal

final class RouterImpl: NSObject, Router {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func availableViewController() -> UIViewController?{
        return rootController?.viewControllers.last
    }
    
    func present(_ module: Presentable?) {
        present(module, mode: .fullScreen)
    }
    
    func present(_ module: Presentable?, isWrapNavigation: Bool) {
        present(module, animated: true, mode: .fullScreen, isWrapNavigation: isWrapNavigation)
    }
    
    func present(_ module: Presentable?, mode: PresentMode) {
        present(module, animated: true, mode: mode, isWrapNavigation: false)
    }
    
    func present(_ module: Presentable?, animated: Bool, mode: PresentMode, isWrapNavigation: Bool) {
        guard var controller = module?.toPresent() else { return }
        if isWrapNavigation {
            controller = controller.wrapInNavigationController()
        }
        
        switch mode {
        case .fullScreen:
            controller.modalPresentationStyle = .fullScreen
        case .overContext:
            controller.modalPresentationStyle = .overCurrentContext
        default:
            break
        }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func dismissPanModal() {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.dismiss(animated: true, completion: nil)
        }
    }
    
    func push(_ module: Presentable?)  {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBar: false, hideBottomBar: false, completion: completion)
    }
    
    func push(_ module: Presentable?, animated: Bool, hideBar: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        if hideBar {
            rootController?.isNavigationBarHidden = true
            rootController?.interactivePopGestureRecognizer?.isEnabled = true
            rootController?.interactivePopGestureRecognizer?.delegate = nil
        } else {
            rootController?.isNavigationBarHidden = false
            rootController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func pushPanModal(_ module: Presentable?) {
        guard let controller = module as? (UIViewController&PanModalPresentable) else { return }
     
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.presentPanModal(controller)
        }
    }
    
    func popModule()  {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func popToModule(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        if let controllers = rootController?.popToViewController(controller, animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, completion: (() -> Void)?){
        setRootModule(module, hideBar: false)
        completion?()
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        setRootModule(module, hideBar: hideBar, animation: .fadeIn)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool, animation: Animation) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
        
        switch animation {
        case .fadeIn:
            fadeAnimation(0.3)
        case .bottomUp:
            bottomUpAnimation()
        case .topDown:
            topDownAnimation()
        }
    }
    
    private func fadeAnimation(_ duration: CGFloat) {
        let transition = CATransition()
        transition.duration = CFTimeInterval(duration);
        transition.type = CATransitionType.fade;
        transition.subtype = CATransitionSubtype.fromTop;
        rootController?.view.layer.add(transition, forKey: kCATransition)
    }
    
    private func bottomUpAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        rootController?.view.layer.add(transition, forKey: nil)
    }
    
    private func topDownAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        rootController?.view.layer.add(transition, forKey: nil)
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    enum Animation {
        case fadeIn
        case bottomUp
        case topDown
    }
}
