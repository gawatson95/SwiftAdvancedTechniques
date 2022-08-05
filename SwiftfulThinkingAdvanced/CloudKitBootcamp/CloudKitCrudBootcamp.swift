//
//  CloudKitCrudBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 8/4/22.
//

import SwiftUI
import CloudKit
import Combine

struct FruitModel: Hashable, CloudKitProtocol {
    let name: String
    let imageURL: URL?
    let count: Int
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard let name = record["name"] as? String else { return nil }
        self.name = name
        let imageAsset = record["image"] as? CKAsset
        self.imageURL = imageAsset?.fileURL
        let count = record["count"] as? Int
        self.count = count ?? 0
        self.record = record
    }
    
    init?(name: String, imageURL: URL?, count: Int?) {
        let record = CKRecord(recordType: "Fruits")
        record["name"] = name
        if let url = imageURL {
            let asset = CKAsset(fileURL: url)
            record["image"] = asset
        }
        if let count = count {
            record["count"] = count
        }
        self.init(record: record)
    }
    
    func update(newName: String) -> FruitModel? {
        let record = record
        record["name"] = newName
        return FruitModel(record: record)
    }
}

class CloudKitCrudBootcampVM: ObservableObject {
    
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    private func addItem(name: String) {
        guard
            let image = UIImage(named: "ladygaga"),
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("ladygaga.jpg"),
            let data = image.jpegData(compressionQuality: 1.0)
        else { return }
        
        do {
            try data.write(to: url)
            guard let newFruit = FruitModel(name: name, imageURL: url, count: 1) else { return }
            CloudKitUtility.add(item: newFruit) { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.fetchItems()
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let recordType = "Fruits"
        //let predicate = NSPredicate(format: "name = %@", argumentArray: ["Coconut"])
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self?.fruits = returnedItems
            }
            .store(in: &cancellables)
    }
    
    func updateItem(fruit: FruitModel) {
        guard let newFruit = fruit.update(newName: "NEW NAME HERE") else { return }
        CloudKitUtility.update(item: newFruit) { [weak self] result in
            print("Update completed")
            self?.fetchItems()
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        
        CloudKitUtility.delete(item: fruit)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                print("Delete is \(success)")
                self?.fruits.remove(at: index)
            }
            .store(in: &cancellables)
    }
}

struct CloudKitCrudBootcamp: View {
    
    @StateObject private var vm = CloudKitCrudBootcampVM()
    
    var body: some View {
        NavigationView {
            VStack {
                header
                textField
                addButton
                
                List {
                    ForEach(vm.fruits, id: \.self) { fruit in
                        HStack {
                            Text(fruit.name)
                            Text("\(fruit.count)")
                            
                            if let url = fruit.imageURL, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                                
                        }
                            .onTapGesture {
                                vm.updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: vm.deleteItem)
                }
                .listStyle(.plain)

            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct CloudKitCrudBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitCrudBootcamp()
    }
}

extension CloudKitCrudBootcamp {
    
    private var header: some View {
        Text("CloudKit CRUD")
            .font(.headline)
    }
    
    private var textField: some View {
        TextField("Add something here...", text: $vm.text)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
    
    private var addButton: some View {
        Button {
            vm.addButtonPressed()
            vm.text = ""
        } label: {
            Text("Add")
                .frame(height: 55)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .cornerRadius(10)
        }
    }
}
