//
//  ViewModifierBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 5/17/22.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
    }
}

extension View {
    
    func withDefaultButtonFormatting(backgroundColor: Color = .blue) -> some View {
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
        
    }
}

struct ViewModifierBootcamp: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .withDefaultButtonFormatting()
            
            Text("Hello, People!")
                .font(.subheadline)
                .modifier(DefaultButtonViewModifier(backgroundColor: .orange))
            
            Text("Hello, Lady Gaga!")
                .font(.title)
                .modifier(DefaultButtonViewModifier(backgroundColor: .pink))
        }
        .padding()
    }
}

struct ViewModifierBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ViewModifierBootcamp()
    }
}
