//
//  ContentView.swift
//  SwiftlyTest
//
//  Created by John Russel Usi on 6/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var totalBill = ""
    @State private var numberOfPeople = 1
    @State private var items: [Item] = []
    @State private var currentItemName = ""
    @State private var currentItemPrice = ""
    @FocusState private var priceFieldIsFocused: Bool
    
    private var splitAmount: Double {
        if numberOfPeople <= 0{
            return 0
        }
        
        return itemizedBill / Double(numberOfPeople)
    }
    
    private var itemizedBill: Double {
        items.reduce(0) {
            $0 + $1.price
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                addItemView()
                numberOfPersonsView()
                itemizedBillView()
                splitAmountHeaderView()
                
                Spacer()
                
                splitAmountTilesView()
            }
            .padding()
        }
        .foregroundColor(.white)
    }
    
    private func incrementPeople() {
        numberOfPeople += 1
    }
    
    private func decrementPeople() {
        if numberOfPeople == 1 {
            return
        }
        numberOfPeople -= 1
    }
}

//MARK: - Views
extension ContentView {
    private func amountInputView() -> some View {
        HStack {
            Text("Total Amount: ")
                .foregroundColor(.white)
            
            TextField("Enter Amount", text: $totalBill)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .foregroundColor(.black)
                .padding()
        }
    }
    
    private func numberOfPersonsView() -> some View {
        HStack {
            Button(action: {
                decrementPeople()
            }) {
                Image(systemName: "minus")
                    .foregroundColor(.white)
            }
            
            TextField("Number of People", value: $numberOfPeople, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .foregroundColor(.black)
                .padding()
            
            Button(action: {
                priceFieldIsFocused = false
                incrementPeople()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
    
    private func splitAmountHeaderView() -> some View {
        VStack {
            Text("Each Person Pays:")
                .font(.title)
                .foregroundColor(.white)
        }
    }
    
    private func splitAmountTilesView() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(0..<numberOfPeople, id: \.self) { index in
                    GeometryReader { geometry in
                        SplitAmountTile(amount: splitAmount)
                            .frame(width: min(geometry.size.width, geometry.size.height),
                                   height: min(geometry.size.width, geometry.size.height))
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func addItemView() -> some View {
        VStack {
            Text("Add Item")
                .font(.title)
                .foregroundColor(.white)
            
            HStack {
                TextField("Item Name", text: $currentItemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .padding()
                
                TextField("Item Price",
                          text: $currentItemPrice)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .foregroundColor(.black)
                .focused($priceFieldIsFocused)
                .padding()
                
                Button {
                    if currentItemName != "" && Double(currentItemPrice) ?? 0.0 > 0.0 {
                        addItem()
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func addItem() {
        let item = Item(name: currentItemName,
                        price: Double(currentItemPrice) ?? 0.0)
        items.append(item)
        priceFieldIsFocused = false
        currentItemName = ""
        currentItemPrice = ""
    }
    
    private func itemizedBillView() -> some View {
        VStack {
            Text("Total Amount: \(itemizedBill.formatted(.currency(code: "PHP")))")
                .font(.title)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(items) { item in
                        VStack {
                            Text(item.name)
                                .font(.headline)
                            Text(String(format: "PHP %.2f", item.price))
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SplitAmountTile: View {
    var amount: Double
    
    var body: some View {
        Text(String(format: "PHP %.2f", amount))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pink)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
            .shadow(color: .black, radius: 5, x: 0, y: 2)
            .padding(.bottom, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
