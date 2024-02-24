//
//  IntoView.swift
//  ios17
//
//  Created by Benji Loya on 04.11.2023.
//


import SwiftUI

struct IntosView: View {
    
    @State private var intros: [IntroModel] = sampleIntros
    @State private var activeIntro: IntroModel?
    
    @State private var showMainView = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            VStack(spacing: 0) {
                if let activeIntro {
                    Rectangle()
                        .fill(activeIntro.bgColor)
                        .padding(.bottom, -30)
                    /// Circle And Text
                        .overlay {
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundColor(activeIntro.textColor)
                                .background(alignment: .leading, content: {
                                   Capsule()
                                        .fill(activeIntro.bgColor)
                                        .frame(width: size.width)
                                })
                                .background(alignment: .leading) {
                                    Text(activeIntro.text)
                                        .font(.title.bold())
                                        .foregroundStyle(activeIntro.textColor)
                                        .frame(width: textSize(activeIntro.text))
                                        .offset(x: 10)
                                    /// Moving Text based on text Offset
                                        .offset(x: activeIntro.textOffset)
                                }
                            /// Moving Circle in the Opposite Direction
                                .offset(x: -activeIntro.circleOffset)
                        }
                }
            }
            .ignoresSafeArea()
        }
        .task {
            if activeIntro == nil {
                activeIntro = sampleIntros.first
                /// Delaying 0.15s and  Starting Animation
                let nanoSeconds = UInt64(1_000_000_000 * 0.05)
                try? await Task.sleep(nanoseconds: nanoSeconds)
                animate(0)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        showMainView = true
                    }
                }
        .fullScreenCover(isPresented: $showMainView, content: {
            NavigationStack {
                /// Redirecting User Based on Log Status
                if logStatus {
                    Home()
                        .accentColor(.primary)
                } else {
                    HomeOnBoard()
                }
            }
        })
    }
    
    /// Animating Intros
    func animate(_ index: Int, _ loop: Bool = true) {
        if intros.indices.contains(index + 1) {
            /// Updating Text and Text Color
            activeIntro?.text = intros[index].text
            activeIntro?.textColor = intros[index].textColor
            
            /// Animating Offsets
            withAnimation(.snappy(duration: 0.3), completionCriteria: .removed) {
                activeIntro?.textOffset = -(textSize(intros[index].text) + 20)
                activeIntro?.circleOffset = -(textSize(intros[index].text) + 20) / 2
            } completion: {
                /// Reseting the offset with next slide color change
                withAnimation(.snappy(duration: 0.3), completionCriteria:
                        .logicallyComplete) {
                            activeIntro?.textOffset = 0
                            activeIntro?.circleOffset = 0
                            activeIntro?.circleColor = intros[index + 1].circleColor
                            activeIntro?.bgColor = intros[index + 1].bgColor
                        } completion: {
                            /// Going to next slide
                            /// Simply recursion
                     animate(index + 1, loop)
                        }
            }
        } else {
            /// Looping
            if loop {
                animate(0, loop)
            }
        }
    }
    
    /// Fetching Text Size based on Fonts
    func textSize(_ text: String) -> CGFloat {
        return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
    }
}

#Preview {
    IntosView()
}

/// Custom  Modifier
extension View {
    @ViewBuilder
    func fillButton(_ color: Color) -> some View {
        self
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(color, in: .rect(cornerRadius: 15))
    }
}
