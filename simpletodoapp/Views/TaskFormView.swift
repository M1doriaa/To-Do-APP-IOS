//
//  TaskFormView.swift
//  simpletodoapp
//
//  Created by Triệu Hải Lâm on 6/7/25.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var controller: TodoController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var taskTitle: String = ""
    @State private var selectedPriority: ToDoTask.Priority = .medium
    @State private var selectedCategory = "General"
    @State private var customCategory = ""
    @State private var showingCustomCategory = false
    
    private let predefinedCategories = ["General", "Work", "Personal", "Shopping"]
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thông tin task")) {
                    TextField("Tiêu đề task", text: $taskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("Ưu Tiên")) {
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(ToDoTask.Priority.allCases, id: \.self) { priority in
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(priorityColor(priority))
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
//                    .pickerStyle()
                }
                
                Section(header: Text("Danh Mục")) {
                    if !showingCustomCategory {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(predefinedCategories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Button("Thêm danh mục mới") {
                            showingCustomCategory = true
                        }
                        .foregroundColor(.blue)
                    } else {
                        TextField("Danh mục mới", text: $customCategory)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            Button("Hủy") {
                                showingCustomCategory = false
                                customCategory = ""
                            }
                            .foregroundColor(.red)
                            
                            Button("Xác nhận") {
                                if !customCategory.isEmpty {
                                    selectedCategory = customCategory
                                    showingCustomCategory = false
                                }
                            }
                            .foregroundColor(.blue)
                            .disabled(customCategory.isEmpty)
                        }
                    }
                }
                
                Section {
                    Button(action: addTask) {
                        HStack {
                            Spacer()
                            Text("Thêm task")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .disabled(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
            }
            .navigationTitle("Thêm task mới")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Huỷ") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Lưu") {
                        addTask()
                    }
                    .disabled(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func addTask() {
        let category = showingCustomCategory && !customCategory.isEmpty ? customCategory : selectedCategory
        controller.addTask(title: taskTitle, priority: selectedPriority, category: category)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func priorityColor(_ priority: ToDoTask.Priority) -> Color {
        switch priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
}

//extension ToDoTask {
//    static let sample = ToDoTask(
//        title: "Sample Task for Preview",
//        isCompleted: false,
//        priority: .high,
//        category: "Work"
//    )
//}

struct EditTaskView: View {
    let task: ToDoTask
    @ObservedObject var controller: TodoController
    @Environment(\.presentationMode) var persentationMode
    
    @State private var taskTitle: String = ""
    @State private var selectedPriority: ToDoTask.Priority = .medium
    @State private var selectedCategory = "General"
    @State private var customCategory = ""
    @State private var showingCustomCategory = false
    
    private let predefinedCategories = ["General", "Work", "Personal", "Shopping"]
    
    init(task: ToDoTask,controller: TodoController) {
        self.task = task
        self.controller = controller
        self._taskTitle = State(initialValue: task.title)
        self._selectedPriority = State(initialValue: task.priority)
        self._selectedCategory = State(initialValue: task.category)
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thông tin task")) {
                    TextField("Thiêu đề task", text: $taskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("Ưu Tiên")) {
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(ToDoTask.Priority.allCases, id: \.self) { priority in
                            HStack {
                                Image(systemName: "start.fill")
                                    .foregroundColor(priorityColor(priority))
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
                }
                
                Section(header: Text("Danh mục")) {
                    if !showingCustomCategory {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(predefinedCategories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        
                        
                        Button("Thêm Danh mục mới") {
                            showingCustomCategory = true
                        }
                        
                    } else {
                        TextField("Danh mục mới", text: $customCategory)
                        
                        HStack {
                            Button("Huỷ") {
                                showingCustomCategory = false
                                customCategory = ""
                            }
                            .foregroundColor(.red)
                            
                            Spacer()
                            
                            Button("Xác nhận") {
                                if !customCategory.isEmpty {
                                    selectedCategory = customCategory
                                    showingCustomCategory = false
                                    
                                }
                            }
                            .disabled(customCategory.isEmpty)
                        }
                        
                    }
                }
                
                
                Section(header: Text("Thông tin thêm")){
                    HStack{
                        Text("Ngày tạo:")
                        Spacer()
                        Text(task.formattedDateOnly)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Trạng thái")
                        Spacer()
                        Text(task.isCompleted ? "Đã hoàn thành" : "Chưa hoàn thành")
                            .foregroundColor(task.isCompleted ? .green : .red)
                    }
                }
                
                Section {
                    Button(action: updateTask) {
                        HStack {
                            Spacer()
                            Text("Cập nhật task")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationBarTitle("Chỉnh sửa task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Huỷ") {
                        persentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") {
                        updateTask()
                    }
                    .disabled(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func updateTask() {
        let category = showingCustomCategory && !customCategory.isEmpty ? customCategory : selectedCategory
        
        controller.updateTask(task, title: taskTitle, priority: selectedPriority, category: category)
        persentationMode.wrappedValue.dismiss()
    }
    
    private func priorityColor(_ priority: ToDoTask.Priority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

//#Preview {
//    EditTaskView(task: ToDoTask.sample, controller: TodoController())
//}

