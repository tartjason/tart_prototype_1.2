import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isManaging = false
    @State private var selectedItems: Set<String> = []
    
    // Sample history data - replace with your actual data model
    @State private var historyItems = [
        HistoryItem(id: "1", title: "(Summer)", medium: "Colored Pencil", date: "Today", imageName: "garden")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                
                Text("History")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.leading)
                
                Spacer()
                
                // Manage/Done button
                Button(action: {
                    withAnimation {
                        isManaging.toggle()
                        if !isManaging {
                            selectedItems.removeAll()
                        }
                    }
                }) {
                    Text(isManaging ? "Done" : "Manage")
                        .font(.system(size: 16))
                        .foregroundColor(isManaging ? .blue : .black)
                }
            }
            .padding()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Today section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.horizontal)
                        
                        ForEach(historyItems) { item in
                            HistoryItemView(
                                item: item,
                                isManaging: isManaging,
                                isSelected: selectedItems.contains(item.id)
                            ) {
                                // Toggle selection
                                if selectedItems.contains(item.id) {
                                    selectedItems.remove(item.id)
                                } else {
                                    selectedItems.insert(item.id)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            
            // Bottom toolbar when managing
            if isManaging {
                HStack {
                    Button(action: {
                        // Select all functionality
                        if selectedItems.count == historyItems.count {
                            selectedItems.removeAll()
                        } else {
                            selectedItems = Set(historyItems.map { $0.id })
                        }
                    }) {
                        Text("Select All")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Delete selected items
                        historyItems.removeAll { selectedItems.contains($0.id) }
                        selectedItems.removeAll()
                    }) {
                        Text("Delete")
                            .font(.system(size: 16))
                            .foregroundColor(selectedItems.isEmpty ? .gray : .black)
                    }
                    .disabled(selectedItems.isEmpty)
                }
                .padding()
                .background(Color.white)
                .border(Color.gray.opacity(0.3), width: 0.5)
            }
        }
        .navigationBarHidden(true)
    }
}

struct HistoryItemView: View {
    let item: HistoryItem
    let isManaging: Bool
    let isSelected: Bool
    let onSelectionToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                // Image
                ZStack(alignment: .bottom) {
                    // Placeholder for the garden image
                    Rectangle()
                        .fill(Color.green.opacity(0.4))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "leaf.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(40)
                                .foregroundColor(.white.opacity(0.8))
                        )
                    
                    // Bottom labels
                    HStack {
                        Text(item.title)
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(item.medium)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.6))
                }
            }
            .cornerRadius(8)
            .padding(.horizontal)
            
            // Selection circle when managing
            if isManaging {
                Button(action: onSelectionToggle) {
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 24, height: 24)
                            .background(
                                Circle()
                                    .fill(isSelected ? Color.blue : Color.clear)
                                    .frame(width: 24, height: 24)
                            )
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.trailing, 24)
            }
        }
    }
}

// Data model for history items
struct HistoryItem: Identifiable {
    let id: String
    let title: String
    let medium: String
    let date: String
    let imageName: String
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
        }
    }
}
