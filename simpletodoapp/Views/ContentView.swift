//
//  ContentView.swift
//  simpletodoapp
//
//  Created by Triệu Hải Lâm on 5/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var todoController = TodoController()
    @State private var showingAddTask = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HeaderStatsView(controller: todoController)
                
                SearchBarView(controller: todoController)
                
                FillterSortControlsView(controller: todoController)
                
                TaskListViewMain(controller: todoController)
            }
            .navigationTitle("My Task")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                    }
                    
                    Button(action: {showingAddTask = true})
                    {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(controller: todoController)
            }
        
            .sheet(isPresented: $showingSettings){
                SettingViews(controller: todoController)
            }
        }
    }
}

struct HeaderStatsView: View {
    @ObservedObject var controller: TodoController
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15){
                StatCard(
                    title: "Tổng số",
                    value: "\(controller.task.count)",
                    icon: "list.bullet",
                    color: .blue
                )
                StatCard(
                    title: "Hoàn Thành",
                    value: "\(controller.completedTaskCount)",
                    icon: "list.bullet",
                    color: .blue
                )
                StatCard(
                    title: "Chưa xong",
                    value: "\(controller.pendingTaskCount)",
                    icon: "list.bullet",
                    color: .blue
                )
                StatCard(
                    title: "Quá Hạn",
                    value: "\(controller.overdueTaskCount)",
                    icon: "list.bullet",
                    color: .blue
                )
                StatCard(
                    title: "Ưu tiên cao",
                    value: "\(controller.highPriorityTaskCount)",
                    icon: "list.bullet",
                    color: .blue
                )
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body : some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Spacer()
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(width: 120, height: 80)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SearchBarView: View {
    @ObservedObject var controller: TodoController
    
    var body : some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Tìm kiếm", text: Binding (
                get: {controller.searchText},
                set: {controller.setSearchText($0)}
            ))
            .textFieldStyle(PlainTextFieldStyle())
            
            if !controller.searchText.isEmpty {
                Button(action: {
                    controller.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
                
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct FillterSortControlsView : View {
    @ObservedObject var controller: TodoController
    
    var body : some View {
        HStack {
            Picker("Filter", selection: Binding(
                get: {controller.currentFilter},
                set: {controller.setFilter($0)}
            )) {
                ForEach(TaskFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 20)
            
            Picker("Sort", selection: Binding (
                get: {controller.currentSort},
                set: {controller.setSort($0)}
        
            )) {
                ForEach(TaskSort.allCases, id: \.self) {sort in
                    Text(sort.rawValue).tag(sort)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
