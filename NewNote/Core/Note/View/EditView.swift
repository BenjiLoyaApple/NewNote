//
//  EditView.swift
//  NewNote
//
//  Created by Benji Loya on 12.02.2024.
//

import SwiftUI
import PhotosUI

struct EditView: View {
    
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    
    @Environment(\.dismiss) private var dismiss
    let note: Note
    
    @State private var title = ""
    @State private var subTitle = ""
    @State private var date: Date = .init()
    @State private var image: Data? = nil
    @State private var tag: Tag?
    
    /// Photo
    @State private var selectedPhoto: PhotosPickerItem?
    ///showing Pickers
    @State private var showPhotoPicker = false
    @State private var showDatePicker = false
    @State private var isDateVisible = false
    
    // Date Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter }()
    
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
                            VStack(spacing: 20) {
                                
                                VStack {
                                    if let imageData = image,
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: UIScreen.main.bounds.height * 0.25)
                                            .clipShape(.rect(cornerRadius: 10))
                                    }
                                }
                                .shadow(color: .black.opacity(0.4), radius: 10, x: 2, y: 7)
                                .overlay(alignment: .topTrailing) {
                                    if image != nil {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                deletePhoto()
                                            }
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title3)
                                                .foregroundStyle(ColorManager.cardBg)
                                                .background(Color.gray)
                                                .padding(-2)
                                                .clipShape(Circle())
                                                .padding(6)
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    TextField("Title", text: $title)
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundColor(.primary)
                                        .shadow(color: ColorManager.myBg, radius: 2)
                                        .onChange(of: title) {
                                            if title.count > 30 {
                                                title = String(title.prefix(30))
                                            }
                                        }
                                    
                                    TextField("Description", text: $subTitle, axis: .vertical)
                                    
                                    HStack(spacing: 4) {
                                        if isDateVisible {
                                            Text(date, formatter: dateFormatter)
                                                .transition(.opacity)
                                        }
                                        
                                        Spacer()
                                        
                                        if let tag = tag {
                                            Circle()
                                                .frame(height: 10)
                                                .foregroundColor(tag.color)
                                                .padding(4)
                                            
                                            Text(tag.name)
                                        }
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.primary.opacity(0.4))
                                    .padding(.top, 10)
                                    .onChange(of: date) { newDate in
                                        withAnimation {
                                            isDateVisible = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            withAnimation {
                                                isDateVisible = false
                                            }
                                        }
                                    }
                                    
                                }
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
        }
    }
    
    func progressView(fullView: GeometryProxy, ScrollProxy: ScrollViewProxy) -> some View {
        let progress = min(max(0, -scrollOffset / (contentHeight - fullView.size.height)), 1)
        let progressPercentage = Int(progress * 100)
        return ZStack {
            Group {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: 250, height: 55)
                        .foregroundStyle(.ultraThinMaterial)
                    HStack {
                        Text("\(progressPercentage)%")
                            .font(.title3)
                            .bold()
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.green)
                            .frame(width: 150 * progress, height: 8)
                    }
                    .padding(.horizontal)
                    .opacity(progressPercentage > 0 && progressPercentage < 100 ? 1 : 0)
                    .animation(.easeInOut, value: progressPercentage)
                    
                }
            }
            .opacity(progressPercentage > 0 ? 0.9 : 0)
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
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
            .frame(width: progressPercentage > 0 && progressPercentage < 100 ? 250 : 55, height: 55)
            .animation(.easeInOut(duration: 0.33), value: progressPercentage)
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    //MARK: - Delete Photo
    func deletePhoto() {
            if image != nil {
                selectedPhoto = nil
                image = nil
            }
    }
    
}


//#Preview {
//    EditView()
//}

#Preview {
    let preview = Preview(Note.self)
   return  NavigationStack {
       EditView(note: Note.sampleNotes[1])
           .modelContainer(preview.container)
    }
}
