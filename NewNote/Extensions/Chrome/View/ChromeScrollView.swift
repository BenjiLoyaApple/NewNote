//
//  ChromeScrollView.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

import SwiftUI

struct ChromeScrollView<Content: View,NavBar: View>: View{
    var content: Content
    var navBar: NavBar
    var config: Config
    var leadingAction: ()->()
    var centerAction: ()->()
    var trailingAction: ()->()
    
    init(config: Config,@ViewBuilder content: @escaping ()->Content,@ViewBuilder navbar: @escaping ()->NavBar,leadingAction: @escaping()->(),centerAction: @escaping()->(),trailingAction: @escaping()->()) {
        self.content = content()
        self.navBar = navbar()
        self.config = config
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
        self.centerAction = centerAction
    }
    
    @State var offsetY: CGFloat = 0
    @StateObject var gestureManager: InteractionManager = .init()
    @Namespace var animation
    
    var body: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0){
                NavBarView()
                
                content
            }
            .offset(y: offsetY > 60 ? -offsetY + 60 : 0)
            .offset { rect in
                offsetY = rect.minY
                if rect.minY > 60{
                    if !gestureManager.isEligibleForAction{
                        gestureManager.isEligibleForAction = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        //print("Impact Occured")
                    }
                }else{
                    gestureManager.isEligibleForAction = false
                }
            }
        }
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: gestureManager.addGesture)
        .onDisappear(perform: gestureManager.removeGesture)
        .onReceive(NotificationCenter.default.publisher(for: .init(gestureManager.notificationID))) { _ in
            switch gestureManager.activeIcon{
            case .center: centerAction()
            case .leading: leadingAction()
            case .trailing: trailingAction()
            }
        }
    }
    
    @ViewBuilder
    func NavBarView()->some View{
        ZStack{
            let modifiedOffset = offsetY > 60 ? 60 : offsetY
            let opacity = ((modifiedOffset - 10) / 60)
            let opacity1 = (modifiedOffset / 10)
            
            navBar
            .frame(minHeight: 40)
            .padding(.horizontal,15)
            .opacity(1.0 - opacity1)
            
            HStack{
                IconView(icon: config.leading, iconAlignment: .leading)
                IconView(icon: config.center, iconAlignment: .center)
                IconView(icon: config.trailing, iconAlignment: .trailing)
            }
            .padding(.horizontal,15)
            .frame(height: 40)
            .scaleEffect(0.6 + (opacity1 > 0.4 ? 0.4 : opacity1), anchor: .center)
            .opacity(modifiedOffset > 10 ? opacity : 0)
            .offset(y: opacity * -45)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 40)
        //.frame(maxHeight: 75)
        .offset(y: offsetY > 60 ? 0 : 0)
    }
    
    @ViewBuilder
    func IconView(icon: Icon,iconAlignment: IconAlignment)->some View{
        let modifiedOffset = offsetY > 60 ? 60 : offsetY
        let opacity2 = ((modifiedOffset) / 60)
        let width = iconAlignment == .leading ? 50.0 : iconAlignment == .trailing ? -50.0 : 0
        
        VStack{
            Image(systemName: icon.name)
                .font(.title3)
                .frame(width: 55, height: 55)
                .background(content: {
                    CircleView(icon: icon,iconAlignment: iconAlignment)
                })
                .offset(x: width)
                .offset(x: opacity2 * -width)
                .frame(maxWidth: .infinity)
            
            Text(icon.title)
                .font(.caption)
                .foregroundColor(.gray)
                .opacity(gestureManager.activeIcon == iconAlignment && offsetY > 60 ? 1 : 0)
                .animation(.easeInOut,value: gestureManager.activeIcon)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func CircleView(icon: Icon,iconAlignment: IconAlignment)->some View{
        VStack{
            if gestureManager.activeIcon == iconAlignment{
                Circle()
                    .fill(.gray.opacity(0.2))
                    .matchedGeometryEffect(id: "TAB", in: animation)
                    .opacity(offsetY > 60 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: offsetY > 60)
                    // MARK: Disable this if you dont want Tint Scaling Effect When Releasing Interaction
                    .scaleEffect(gestureManager.isEligibleForAction && !gestureManager.isInteracting ? 50 : 1)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: gestureManager.isEligibleForAction && !gestureManager.isInteracting)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.75, blendDuration: 0.75), value: gestureManager.activeIcon)
    }
}
