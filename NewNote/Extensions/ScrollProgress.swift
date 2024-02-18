//
//  ScrollProgress.swift
//  NewNote
//
//  Created by Benji Loya on 12.02.2024.
//

import SwiftUI

struct ScrollProgress: View {
    
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    
    var text: String = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum \n\n(The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham. Contrary to popular belief, Lorem Ipsum is not simply random text. \n \n It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.Contrary to popular belief, Lorem Ipsum is not simply random text. \n \n It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., "
    
    var body: some View {
        NavigationStack {
            ScrollViewReader(content: { scrollProxy in
                // 1
                GeometryReader(content: { fullView in
                    ZStack(alignment: .top) {
                        ScrollView(.vertical) {
                            // 3
                            GeometryReader(content: { ScrollViewGeo in
                                Color.clear.preference(key: OffsetKey.self, value: ScrollViewGeo.frame(in: .global).minY)
                            })
                            .frame(height: 0).id(0)
                            
                            VStack {
                                Image("cali")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: UIScreen.main.bounds.height * 0.25)
                                    .clipShape(.rect(cornerRadius: 10))
                                
                                Text(text)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // 2
                            .background(GeometryReader { contentGeo in
                                Color.clear.preference(key: ContentPreferenceKey.self, value: contentGeo.size.height)
                            })
                        }
                        .scrollIndicators(.hidden)
                        .onPreferenceChange(OffsetKey.self) {
                            self.scrollOffset = $0 - fullView.safeAreaInsets.top
                        }
                        .onPreferenceChange(ContentPreferenceKey.self) {
                            self.contentHeight = $0
                        }
                        progressView(fullView: fullView, ScrollProxy: scrollProxy)
                    }
                })
            })
            .navigationTitle("Scroll Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
//
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .foregroundStyle(.black)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
//
                    } label: {
                        Image(systemName: "square.3.stack.3d")
                            .font(.title3)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
    
    func progressView(fullView: GeometryProxy, ScrollProxy: ScrollViewProxy) -> some View {
        let progress = min(max(0, -scrollOffset / (contentHeight - fullView.size.height)), 1)
        let progressPercentage = Int(progress * 100)
        return ZStack {
            Group {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: 200, height: 45)
                        .foregroundStyle(.ultraThinMaterial)
                    HStack {
                        Text("\(progressPercentage)%")
                            .font(.title3)
                            .bold()
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.blue)
                            .frame(width: 115 * progress, height: 8)
                    }
                    .padding(.horizontal)
                    .opacity(progressPercentage > 0 && progressPercentage < 100 ? 1 : 0)
                    .animation(.easeInOut, value: progressPercentage)
                    
                }
            }
            .opacity(progressPercentage > 0 ? 1 : 0)
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    ScrollProxy.scrollTo(0)
                }
            } label: {
                Image(systemName: "arrow.up")
                    .font(.title.bold())
                    .foregroundStyle(.black)
            }
            .offset(y: progressPercentage == 100 ? 0 : 100)
            .animation(.easeInOut, value: progressPercentage)
        }
        .mask(
            RoundedRectangle(cornerRadius: 40)
            .frame(width: progressPercentage > 0 && progressPercentage < 100 ? 200 : 55, height: 45)
            .animation(.easeInOut(duration: 0.33), value: progressPercentage)
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
}


struct ContentPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    ScrollProgress()
}
