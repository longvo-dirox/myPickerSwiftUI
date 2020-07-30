//
//  ContentView.swift
//  PaginatedScrollView
//
//  Created by Aleksey Ozerov on 24.10.2019.
//  Copyright © 2019 Aleksey Ozerov. All rights reserved.
//

import SwiftUI
import Foundation

var segmentWidth: CGFloat = 90
var segmentHeight: CGFloat = 50
struct Segment: View, Identifiable {
    let id : Int
    let color: Color
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("Page \(id)")
        }
        .frame(width: segmentWidth, height: segmentHeight).background(color.opacity(0.5))
        .border(Color.black, width: 2)
    }
}

struct MyPickerView: View {
    var colors = [Color.yellow, Color.green, Color.yellow, Color.pink]
    var body: some View {
        MyPicker(
            pages: (0..<4).map {
                Segment( id: $0, color: colors[$0])
        })
    }
}

struct MyPicker<Content: View & Identifiable>: View {
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false
    
    var pages: [Content]
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading)
            {
                
                Text("offset=\(self.index)")
                
                Color.red.opacity(0.51)
                    .overlay(
                        HStack (spacing: 0){
                            ForEach(0..<4) {idx in
                                Button(action: {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        self.index = idx
                                    }
                                }) {
                                    Rectangle().stroke()
                                }
                                .frame(width: segmentWidth, height: segmentHeight)
                                .border(Color.blue, width: 1)
                                
                            }
                        }
                )
                    .frame(width: 4*segmentWidth, height: segmentHeight, alignment: .leading)
                
                self.pages[1]
                    .offset(x: self.isGestureActive ? self.offset : segmentWidth * CGFloat(self.index))
                    .gesture(DragGesture(minimumDistance: 0 , coordinateSpace: .global)
                        .onChanged({ value in
                            self.isGestureActive = true
                            self.offset = value.translation.width + segmentWidth * CGFloat(self.index)
                        })
                        .onEnded({ value in
                            if abs(value.translation.width) >= segmentWidth / 2 {
                                var nextIndex: Int = Int(round(Double(value.translation.width/segmentWidth)))
                                nextIndex += self.index
                                self.index = nextIndex.keepIndexInRange(min: 0, max: self.pages.endIndex - 1)
                                print("index=\(self.index)")
                            }
                            withAnimation { self.offset = +segmentWidth * CGFloat(self.index) }
                            self.isGestureActive = false
                        })
                )
                
                
            }
        }//.background(Color.yellow)
    }
}



extension Int {
    func keepIndexInRange(min: Int, max: Int) -> Int {
        switch self {
        case ..<min: return min
        case max...: return max
        default: return self
        }
    }
}

func getRandomColor() -> Color {
    let r = Double.random(in: 0..<1)
    let g = Double.random(in: 0..<1)
    let b = Double.random(in: 0..<1)
    return Color(red: r, green: g, blue: b, opacity: 1.0)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MyPickerView()
    }
}
