//
//  CustomNavLink.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 5/19/22.
//

import SwiftUI

//struct NavigationLink<Label, Destination> : View where Label : View, Destination : View {
//
//}

struct CustomNavLink<Label:View, Destination:View>: View {
    
    let destination: Destination
    let label: Label
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            CustomNavBarContainerView {
                destination
            }
            .navigationBarHidden(true)
        } label: {
           label
        }

    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView {
            CustomNavLink(
                destination: Text("Destination")) {
                Text("Click me")
                }
        }
    }
}
