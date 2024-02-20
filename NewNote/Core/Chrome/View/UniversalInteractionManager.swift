//
//  UniversalInteractionManager.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

import SwiftUI
import UIKit

// MARK: Universal Interaction Manager
class InteractionManager: NSObject,ObservableObject,UIGestureRecognizerDelegate{
    @Published var isInteracting: Bool = false
    @Published var isGestureAdded: Bool = false
    
    @Published var currentTranslation: CGSize = .zero
    @Published var activeIcon: IconAlignment = .center
    @Published var isEligibleForAction: Bool = false
    let notificationID: String = UUID().uuidString
    
    func addGesture(){
        if !isGestureAdded{
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(onChange(gesture: )))
            gesture.name = "UNIVERSAL"
            gesture.delegate = self
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return}
            guard let window = windowScene.windows.last?.rootViewController else{return}
            window.view.addGestureRecognizer(gesture)
            isGestureAdded = true
        }
    }
    
    // MARK: Removing Gesture
    func removeGesture(){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return}
        guard let window = windowScene.windows.last?.rootViewController else{return}
        
        window.view.gestureRecognizers?.removeAll(where: { gesture in
            return gesture.name == "UNIVERSAL"
        })
        isGestureAdded = false
    }
    
    @objc
    func onChange(gesture: UIPanGestureRecognizer){
        isInteracting = (gesture.state == .changed)
        let translation = gesture.translation(in: gesture.view)
        currentTranslation = .init(width: translation.x, height: translation.y)
        
        let progress = currentTranslation.width / (screenSize().width * 0.9)
        
        if -progress > 0.25 && -progress < 1{
            activeIcon = .leading
        }else if progress > 0.25 && progress < 1{
            activeIcon = .trailing
        }else{
            activeIcon = .center
        }
        
        if gesture.state == .ended{
            checkForEligibility(gesture: gesture)
        }
    }
    
    func checkForEligibility(gesture: UIPanGestureRecognizer){
        if isEligibleForAction{
            NotificationCenter.default.post(name: .init(notificationID), object: nil)
        }else{
            //print("No Actions Nedeed")
        }
    }
    
    func screenSize()->CGSize{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        return window.screen.bounds.size
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
