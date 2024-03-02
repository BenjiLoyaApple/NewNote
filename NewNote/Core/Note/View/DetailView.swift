//
//  DetailView.swift
//  NewNote
//
//  Created by Benji Loya on 29.02.2024.
//

import SwiftUI

//MARK: - Detail View
struct DetailView: View {
    
    @Binding var image: Data?
    
    @Binding var showDetailview: Bool
    @Binding var detailviewAnimation: Bool
    
    var size: CGSize
    var safeArea: EdgeInsets
        
    @State  private var currentAmount: CGFloat = 0
    
    // Dispatch Tasks
    @State private var startTask1: DispatchWorkItem?
    @State private var startTask2: DispatchWorkItem?
    
    var body: some View {
        VStack(spacing: 0) {
            let imageSize = CGSize(width: size.width , height: size.height )
            
            ZStack {
                // Photo Content
                if let imageData = image, let uiImage = UIImage(data: imageData) {
                    /// Image Detail
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .containerRelativeFrame(.horizontal)
                        .clipped()
                        .scaleEffect(1 + currentAmount)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    currentAmount = value - 1
                                }
                                .onEnded { value in
                                    withAnimation(.bouncy()) {
                                        currentAmount = 0
                                    }
                                }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                          ///Close Button
                        .overlay(alignment: .topLeading) {
                            CloseButton()
                                .padding(.top, 70)
                                .padding(.leading)
                        }
                }
            }
            .frame(width: imageSize.width, height: imageSize.height)
            .onAppear {
                cancelTasks()
                /// This only Executes for one time
                // Giving Some time to set the Scroll Position
                initiateTask(ref: &startTask1, task: .init(block: {
                    withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                        detailviewAnimation = true
                    }
                    // Removing Layer View
                    initiateTask(ref: &startTask2, task: .init(block: {
                    }), duration: 0.3)
                    
                }), duration: 0.05)
            }
        }
    }
    
    @ViewBuilder
    func CloseButton() -> some View {
        Button("", systemImage: "xmark.circle.fill") {
            cancelTasks()
            // Giving Some time to set the Scroll Position
            initiateTask(ref: &startTask1, task: .init(block: {
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    detailviewAnimation = false
                }
                
                // Removing Layer View
                initiateTask(ref: &startTask2, task: .init(block: {
                    showDetailview = false
                }), duration: 0.3)
                
            }), duration: 0.05)
            
        }
        .font(.title)
        .foregroundStyle(.white.opacity(0.8), .white.opacity(0.15))
    }
    
    
    func initiateTask(ref: inout DispatchWorkItem?, task: DispatchWorkItem, duration: CGFloat) {
        ref = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
    
    func cancelTasks() {
        if let startTask1, let startTask2 {
            startTask1.cancel()
            startTask2.cancel()
            self.startTask1 = nil
            self.startTask2 = nil
        }
    }
}
