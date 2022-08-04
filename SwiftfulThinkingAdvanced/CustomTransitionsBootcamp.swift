//
//  CustomTransitionsBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 5/17/22.
//

import SwiftUI

struct RotateViewModifier: ViewModifier {
    
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .offset(
                x: rotation != 0 ? UIScreen.main.bounds.width : 0,
                y: rotation != 0 ? UIScreen.main.bounds.height: 0
            )
    }
}

extension AnyTransition {
    static var rotating: AnyTransition {
        modifier(
            active: RotateViewModifier(rotation: 180),
            //when not active
            identity: RotateViewModifier(rotation: 0)
        )
    }
    
    static func rotating(rotation: Double) -> AnyTransition {
        return AnyTransition.modifier(
            active: RotateViewModifier(rotation: rotation),
            //when not active
            identity: RotateViewModifier(rotation: 0)
        )
    }
    
    static var rotateOn: AnyTransition {
        return AnyTransition.asymmetric(
            insertion: .rotating,
            removal: .move(edge: .leading))
    }
}
struct CustomTransitionsBootcamp: View {
    
    @State private var showRectangle: Bool = false
    var body: some View {
        VStack {
            Spacer()
            
            if showRectangle {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 250, height: 350)
//                    .transition(.move(edge: .leading))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //.modifier(RotateViewModifier())
                    //.transition(AnyTransition.rotating.animation(.easeInOut))
                    //.transition(.rotating(rotation: 1080))
                    .transition(.rotateOn)
            }
            
            Spacer()
            
            Text("Click me")
                .withDefaultButtonFormatting()
                .padding(40)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showRectangle.toggle()
                    }
                }
        }
    }
}

struct CustomTransitionsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CustomTransitionsBootcamp()
    }
}
