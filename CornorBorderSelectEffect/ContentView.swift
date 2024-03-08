//
//  ContentView.swift
//  CornorBorderSelectEffect
//
//  Created by 香饽饽zizizi on 2024/3/8.
//

import SwiftUI

struct ContentView: View {
    @State private var selected = 0
    @State private var rects: [CGRect] = Array(repeating: .zero, count: 8)
    @State private var offset: CGFloat = 0

    var body: some View {
        ScrollView {
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                ForEach(0..<4) { i in
                    GridRow {
                        ForEach(i*2 ..< i*2 + 2) { j in
                            Image("\(j+1)")
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .padding(5)
                                .background {
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(key: ImagePreferenceKey.self, value: [ImagePreferenceData(viewIndex: j, rect: geo.frame(in: .scrollView))])
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        selected = j
                                    }
                                }
                        }
                    }
                }
            }
            .padding(10)
            .overlay {
                let r = rects[selected]

                Rectangle()
                    .stroke(lineWidth: 4)
                    .frame(width: r.width, height: r.height)
                    .mask {
                        HStack {
                            VStack {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                Spacer()
                                Rectangle()
                                    .frame(width: 40, height: 40)
                            }
                            Spacer()
                            VStack {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                Spacer()
                                Rectangle()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                    .position(x: r.midX, y: r.midY)
                    .offset(y: -offset)
            }
            .onPreferenceChange(ImagePreferenceKey.self) { values in
                for v in values {
                    rects[v.viewIndex] = v.rect
                }
            }
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .scrollView)) { _, newValue in
                            offset = newValue.minY
                        }
                }
            }
        }
    }
}

struct ImagePreferenceData: Equatable {
    let viewIndex: Int
    let rect: CGRect
}

struct ImagePreferenceKey: PreferenceKey {
    typealias Value = [ImagePreferenceData]

    static var defaultValue: [ImagePreferenceData] = []

    static func reduce(value: inout [ImagePreferenceData], nextValue: () -> [ImagePreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    ContentView()
}
