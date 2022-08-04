//
//  GenericsBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 5/18/22.
//

import SwiftUI

struct StringModel {
    let info: String?
    
    func removeInfo() -> StringModel {
        return StringModel(info: nil)
    }
}

struct GenericModel<T> {
    let info: T?
    
    func removeInfo() -> GenericModel {
        GenericModel(info: nil)
    }
}

class GenericsBootcampVM: ObservableObject {
    
    @Published var stringModel = StringModel(info: "Hello world")
    
    @Published var genericStringModel = GenericModel(info: "Hello, world")
    @Published var genericBoolModel = GenericModel(info: true)
    
    func removeData() {
        stringModel = stringModel.removeInfo()
        genericBoolModel = genericBoolModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
    }
    
}

struct GenericsBootcamp: View {
    @StateObject private var vm = GenericsBootcampVM()
    
    var body: some View {
        VStack {
            Text(vm.stringModel.info ?? "No data")
            Text(vm.genericStringModel.info ?? "No data")
            Text(vm.genericBoolModel.info?.description ?? "No data")
            
            GenericView(content:
                            RoundedRectangle(cornerRadius: 10)
                .frame(width: 20, height: 20), title: "Title")
        }
        .onTapGesture {
            vm.removeData()
        }
    }
}

struct GenericView<T:View>: View {
    
    let content: T
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
            content
        }
    }
}

struct GenericsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GenericsBootcamp()
    }
}
