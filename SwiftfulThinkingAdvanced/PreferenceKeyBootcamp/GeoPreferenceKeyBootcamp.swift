//
//  GeoPreferenceKeyBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 5/18/22.
//

import SwiftUI

struct GeoPreferenceKeyBootcamp: View {
    
    @State private var rectSize: CGSize = .zero
    
    var body: some View {
        VStack {
            Text("Hello")
                .frame(width: rectSize.width, height: rectSize.height)
                .background(Color.blue)
            Spacer()
            HStack {
                Rectangle()
                
                GeometryReader { geo in
                    Rectangle()
                        .updateRectGeoSize(geo.size)
                }
                Rectangle()
            }
            .frame(height: 55)
        }
        .onPreferenceChange(RectanglGeoSizePreferenceKey.self) { value in
            self.rectSize = value
        }
    }
}

struct GeoPreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GeoPreferenceKeyBootcamp()
    }
}

struct RectanglGeoSizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    
    func updateRectGeoSize(_ size: CGSize) -> some View {
        preference(key: RectanglGeoSizePreferenceKey.self, value: size)
    }
}
