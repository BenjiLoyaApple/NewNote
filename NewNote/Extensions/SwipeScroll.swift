//
//  SwipeScroll.swift
//  NewNote
//
//  Created by Benji Loya on 11.02.2024.
//

//import SwiftUI
//
//struct SwipeHome: View {
//    /// Sample Array
//    @State private var colors: [Color] = [.indigo, .blue, .cyan, .teal, .mint, .green, .purple, .red, .pink, .orange,.yellow, .black, .brown, .gray]
//    
//    var body: some View {
//        ScrollView(.vertical) {
//            LazyVStack(spacing: 10) {
//                ForEach(colors, id: \.self) { color in
//                    SwipeAction(cornerRadius: 15, direction: color == .blue ? .leading : .trailing) {
//                        CardView(color)
//                    } actions: {
//                        Action(tint: .blue, icon: "star.fill", iconTint: .white, isEnabled: color == .indigo) {
//                            print("Bookmark")
//                        }
//                        Action(tint: .red, icon: "trash.fill", iconTint: .white) {
//                            print("Delete")
//                            withAnimation(.easeInOut) {
//                                colors.removeAll(where: { $0 == color })
//                            }
//                        }
//                    }
//                }
//            }
//            .padding(15)
//        }
//        .scrollIndicators(.hidden)
//    }
//    
//    // Sample Card View
//    @ViewBuilder
//    func CardView(_ color: Color) -> some View {
//        HStack(spacing: 15) {
//            Circle()
//                .frame(width: 50, height: 50)
//            
//            VStack(alignment: .leading, spacing: 6, content: {
//                RoundedRectangle(cornerRadius: 5)
//                    .frame(width: 80, height: 5)
//                
//                RoundedRectangle(cornerRadius: 5)
//                    .frame(width: 60, height: 5)
//                
//            })
//            Spacer(minLength: 0)
//        }
//        .foregroundStyle(.white.opacity(0.4))
//     //   .foregroundStyle(.black.opacity(0.4))
//        .padding(.horizontal, 15)
//        .padding(.vertical, 10)
//        .background(color.gradient)
//        
//    }
//}
//
//// Custom Swipe action View
//struct SwipeAction<Content: View>: View {
//    var cornerRadius: CGFloat = 0
//    var direction: SwipeDirection = .trailing
//    @ViewBuilder var content: Content
//    @ActionBuilder var actions: [Action]
//    /// View Properties
//    @Environment(\.colorScheme) private var scheme
//    /// View Unique ID
//    let viewID = UUID()
//    @State private var isEnabled: Bool = true
//    @State private var scrollOffset: CGFloat = .zero
//    var body: some View {
//        ScrollViewReader { scrollProxy in
//            ScrollView(.horizontal) {
//                LazyHStack(spacing: 0) {
//                    content
//                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
//                    /// To Take Full Available Space
//                        .containerRelativeFrame(.horizontal)
//                    //    .background(scheme == .dark ? .black : .white)
//                        .background {
//                            if let firstAction = filteredActions.first {
//                                Rectangle()
//                                    .fill(firstAction.tint)
//                                    .opacity(scrollOffset == .zero ? 0 : 1)
//                            }
//                        }
//                        .id(viewID)
//                        .transition(.identity)
//                        .overlay {
//                            GeometryReader {
//                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
//                                
//                                Color.clear
//                                    .preference(key: OffsetKey1.self, value: minX)
//                                    .onPreferenceChange(OffsetKey1.self) {
//                                        scrollOffset = $0
//                                    }
//                            }
//                        }
//                    
//                    ActionButtons {
//                        withAnimation(.snappy) {
//                            scrollProxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
//                        }
//                    }
//                    .opacity(scrollOffset == .zero ? 0 : 1)
//                    
//                }
//                .scrollTargetLayout()
//                .visualEffect { content, geometryProxy in
//                    content
//                        .offset(x: scrollOffset(geometryProxy))
//                }
//            }
//            .scrollIndicators(.hidden)
//            .scrollTargetBehavior(.viewAligned)
//            .background {
//                if let lastAction = filteredActions.last {
//                    Rectangle()
//                        .fill(lastAction.tint)
//                        .opacity(scrollOffset == .zero ? 0 : 1)
//                }
//            }
//            .clipShape(.rect(cornerRadius: cornerRadius))
//            .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
//        }
//        .allowsHitTesting(isEnabled)
//        .transition(CustomTransition())
//    }
//    
//    /// Action Buttons
//    @ViewBuilder
//    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
//        /// Each Button will have 100 width
//        Rectangle()
//            .fill()
//            .frame(width: CGFloat(filteredActions.count) * 100)
//            .overlay(alignment: direction.alignment) {
//                HStack(spacing: 0) {
//                    ForEach(filteredActions) { button in
//                        Button(action: {
//                            Task {
//                                isEnabled = false
//                                resetPosition()
//                                try? await Task.sleep(for: .seconds(0.25))
//                                button.action()
//                                try? await Task.sleep(for: .seconds(0.1))
//                                isEnabled = true
//                            }
//                        }, label: {
//                            Image(systemName: button.icon)
//                                .font(button.iconFont)
//                                .scaleEffect(1.5)
//                                .foregroundStyle(.white, button.iconTint.gradient)
//                                .frame(width: 100)
//                                .frame(maxHeight: .infinity)
//                                .contentShape(.rect)
//                        })
//                        .buttonStyle(.plain)
//                        .background(button.tint)
//                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
//                    }
//                }
//            }
//    }
//    
//    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
//        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
//        
//        return (minX > 0 ? -minX : 0)
//    }
//    
//    var filteredActions: [Action] {
//        return actions.filter({ $0.isEnabled })
//    }
//}
//
//
///// Custom transition
//struct CustomTransition: Transition {
//    func body(content: Content, phase: TransitionPhase) -> some View {
//        content
//            .mask {
//                GeometryReader {
//                    let size = $0.size
//                    
//                    Rectangle()
//                        .offset(y: phase == .identity ? 0 : -size.height)
//                }
//                .containerRelativeFrame(.horizontal)
//            }
//    }
//}
//
///// Swipe Direction
//enum SwipeDirection {
//    case leading
//    case trailing
//    
//    var alignment: Alignment {
//        switch self {
//        case .leading:
//            return .leading
//        case .trailing:
//            return .trailing
//        }
//    }
//}
//
////ACTION  MODEL
//struct Action: Identifiable {
//    private (set) var id: UUID = .init()
//    var tint: Color = .clear
//    var icon: String
//    var iconFont: Font = .largeTitle
//    var iconTint: Color
//    var isEnabled: Bool = true
//    var action: () -> ()
//}
//
//@resultBuilder
//struct ActionBuilder {
//    static func buildBlock(_ components: Action...) -> [Action] {
//        return components
//    }
//}
//
//#Preview {
//    SwipeHome()
//}
