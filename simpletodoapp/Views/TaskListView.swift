//
//  TaskLisstView.swift
//  simpletodoapp
//
//  Created by Triệu Hải Lâm on 6/7/25.
//

import SwiftUI

struct TaskListViewMain: View {
    @ObservedObject var controller: TodoController
    
    var body: some View {
        List{
            if controller.filteredAndSortedTask.isEmpty {
                EmptyStateView(controller: controller)
            } else {
                ForEach(controller.filteredAndSortedTask) { task in
                    TaskRowView(task: task, controller: controller)
                        .swipeActions(edge: .trailing, allowsFullSwipe:  true) {
                            Button(role: .destructive) {
                                withAnimation {
                                    controller.deleteTask(task)
                                }
                            } label: {
                                Label("Xoá", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                withAnimation {
                                    controller.toggleTaskCompletion(task)
                                }
                            } label: {
                                Label(
                                    task.isCompleted ? "Chưa xong" : "Hoàn thành",
                                    systemImage: task.isCompleted ? "arrow.uturn.backward" : "checkmark"
                                )
                            }
                            tint(task.isCompleted ? .orange : .green)
                        }
                }
                .onDelete(perform: controller.deleteTask)
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            
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

struct TaskRowView : View {
    let task: ToDoTask
    @ObservedObject var controller: TodoController
    @State private var showingEditTask = false
    var body : some View {
        HStack(spacing: 12) {
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    controller.toggleTaskCompletion(task)
                }
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                        .font(.title2)
                        .scaleEffect(task.isCompleted ? 1.1 : 1.0)
                }
                .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.displayTitle)
                        .font(.body)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                        .lineLimit(2)
                    Spacer()
                    
                    if task.priority != .medium {
                        PriorityBage(priority: task.priority)
                    }
                }
                
                HStack {
                    if task.category != "General" {
                        CategoryBadge(category: task.category)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if task.isOverdue && !task.isCompleted {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Text(task.formattedDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
            
            Button(action: {showingEditTask = true}) {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
                    .font(.caption)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                controller.toggleTaskCompletion(task)
            }
        }
        .sheet(isPresented: $showingEditTask) {
            EditTaskView(task: task, controller: controller)
        }
    }
}

struct PriorityBage: View {
    let priority: ToDoTask.Priority
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption2)
            Text(priority.rawValue)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(priorityColor.opacity(0.2))
        .foregroundColor(priorityColor)
        .cornerRadius(8)
        
    }
    
    private var priorityColor: Color {
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

struct CategoryBadge: View {
    let category: String
    var body: some View {
        Text(category)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.blue.opacity(0.2))
            .foregroundColor(.blue)
            .cornerRadius(8)
        
    }
}

struct EmptyStateView: View {
    @ObservedObject var controller: TodoController
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: emptyStateIcon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(emptyStateTitle)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Text(emptyStateMesssage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var emptyStateIcon: String {
        switch controller.currentFilter {
        case .all: return controller.task.isEmpty ? "plus.circle" : "magnifyingglass"
        case .pending: return "circle"
        case .completed: return "checkmark.circle"
        case .overdue: return "exclamationmark.triangle"
        case .highPriority: return "star"
        }
    }
    
    private var emptyStateTitle: String {
        switch controller.currentFilter {
        case .all: return controller.task.isEmpty ? "Chưa có task nào" : "Không tìm thấy task"
        case .pending: return "Không có task chưa hoàn thành"
        case .completed: return "Chưa hoàn thành task nào"
        case .overdue: return "Không có task hết hạn"
        case .highPriority: return "Không có task ưu tiên cao"
        }
    }
    
    private var emptyStateMesssage: String {
        if controller.task.isEmpty {
            return "Hãy thêm task đầu tiên của bạn!"
        } else if !controller.searchText.isEmpty {
            return "Hãy tìm kiếm với từ khoá khác"
        } else {
            switch controller.currentFilter {
            case .all: return ""
            case .pending: return "Tất cả tas đã được hoàn thành!"
            case .completed: return "Hãy hoàn thành một số task"
            case .overdue: return "Không có task nào quá hạn"
            case .highPriority: return "Không có task ưu tiên cao nào"
            }
        }
    }
}


#Preview {
    EmptyStateView(controller: TodoController())
}
