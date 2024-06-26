//
//  ContentView.swift
//  iExpense
//
//  Created by Vounatsou, Maria on 7/6/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    var amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
    
    var totalAmount: Double {
        return items.reduce(0) { $0 + $1.amount }
    }
    
    var personalTotalAmount: Double {
        return items.filter { $0.type == "Personal" }.reduce(0) { $0 + $1.amount }
    }
    
    var businessTotalAmount: Double {
        return items.filter { $0.type == "Business" }.reduce(0) { $0 + $1.amount }
    }
}

//Extention for less decimal places(zeroes), instead of format: .currency
//extension Double {
//    func removeZerosFromEnd() -> String {
//        let formatter = NumberFormatter()
//        let number = NSNumber(value: self)
//        formatter.minimumFractionDigits = 0
//        formatter.maximumFractionDigits = 16
//        return String(formatter.string(from: number) ?? "")
//    }
//}

struct ContentView: View {
    
    @State private var title = TitleView(text: "i", secondText: "Expense")
    @State private var expenses = Expenses()
    @State private var showingAddExpence = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("ColorV")
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                Image("paper")
                    .opacity(10)
                    .ignoresSafeArea()
                    .padding()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 750, alignment: .bottom)
                
                VStack {
                    List {
                        Section(header: HStack {
                            Spacer()
                            Text("Personal Expenses")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color("ColorTitle"))
                            Spacer()
                        }){
                            ForEach(expenses.items) { item in
                                if item.type == "Personal" {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                                .font(.headline)
                                        }
                                        Spacer()
                                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                            .foregroundColor(foregroundColor(for: item.amount))
                                    }
                                    .foregroundColor(.black)
                                    .listRowBackground(Color("Colortext"))
                                }
                            }
                            .onDelete(perform: removeItems)
                            
                            Text("Total: \(expenses.personalTotalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                .bold()
                                .listRowBackground(Color("Colortext"))
                                .cornerRadius(20)
                        }
                        
                        Section(header: HStack {
                            Spacer()
                            Text("Business Expenses")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color("ColorTitle"))
                            Spacer()
                        }){
                            ForEach(expenses.items) { item in
                                if item.type == "Business" {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                                .font(.headline)
                                        }
                                        Spacer()
                                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                            .foregroundColor(foregroundColor(for: item.amount))
                                    }
                                    .foregroundColor(.black)
                                    .listRowBackground(Color("Colortext"))
                                }
                            }
                            .onDelete(perform: removeItems)
                            
                            Text("Total: \(expenses.businessTotalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                .bold()
                                .listRowBackground(Color("Colortext"))
                                .cornerRadius(20)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .toolbar {
                        Button("Add Expense", systemImage: "plus.viewfinder") {
                            showingAddExpence = true
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .sheet(isPresented: $showingAddExpence) {
                        Addview(expenses: expenses)
                    }
                    
                    Text("Total: \(expenses.totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                        .padding(0)
                        .bold()
                        .padding()
                        .font(.system(size: 15))
                        .frame(width: 200, height: 50)
                        .background(Color("ColorTitle"))
                        .foregroundColor(.yellow)
                        .cornerRadius(15)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    title
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func foregroundColor(for amount: Double) -> Color {
        if amount < 50 {
            return Color.green
        } else if amount < 150 {
            return Color.yellow
        } else {
            return Color.red
        }
    }
    
}

#Preview {
    ContentView()
}
