//
//  TodoController.swift
//  simpletodoapp
//
//  Created by Triệu Hải Lâm on 5/7/25.
//

import SwiftUI
import Foundation

class TodoController: ObservableObject {
    @Published var task: [ToDoTask] = []
    @Published var currentFilter: TaskFilter = .all
    @Published var currentSort: TaskSort = .newest
    @Published var searchText: String = ""
    
    private let repository: TodoRepository
    
    init(repository: TodoRepository = TodoRepository()) {
        self.repository = repository
        loadTask()
    }
    
    var filteredAndSortedTask: [ToDoTask] {
        var filtered = filterTasks(task, by: currentFilter)
        
        if !searchText.isEmpty {
            filtered = filtered.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return sortTasks(filtered, by: currentSort)
    }
    
    var completedTaskCount: Int {
        task.filter { $0.isCompleted }.count
    }
    
    var pendingTaskCount: Int {
        task.filter { !$0.isCompleted }.count
    }
    
    var overdueTaskCount: Int {
        task.filter { $0.isOverdue && !$0.isCompleted }.count
    }
    
    var highPriorityTaskCount: Int {
        task.filter { $0.priority == .high && !$0.isCompleted }.count
    }
    
    var completionPercentage: Double {
        guard !task.isEmpty else {return 0}
        return Double(completedTaskCount) / Double(task.count) * 100.00.rounded(.down)
    }
    
    func addTask(title: String, priority: ToDoTask.Priority = .medium, category: String = "General") {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  else {
            return
        }
        
        let newTask = ToDoTask(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            isCompleted: false,
            priority: priority,
            category: category
        )
        
        task.insert(newTask, at: 0)
        saveTask()
    }
    
    func toggleTaskCompletion(_ task: ToDoTask) {
        if let index = self.task.firstIndex(where: {$0.id == task.id}) {
            self.task[index].isCompleted.toggle()
            saveTask()
        }
    }
    
    func updateTask(_ task: ToDoTask, title: String? = nil, priority: ToDoTask.Priority? = nil, category: String? = nil) {
        if let index = self.task.firstIndex(where: {$0.id == task.id}) {
            if let title = title {
                self.task[index].title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if let priority = priority {
                self.task[index].priority = priority
            }
            if let category = category {
                self.task[index].category = category
            }
            saveTask()
        }
    }
    
    func deleteTask(_ task: ToDoTask) {
        self.task.removeAll {$0.id == task.id}
        saveTask()
    }
    
    func deleteTask(at offsets: IndexSet) {
        task.remove(atOffsets: offsets)
        saveTask()
    }
    
    func clearAllData() {
        task.removeAll()
        saveTask()
    }
    
    func clearCompletedTask() {
        task.removeAll { $0.isCompleted }
        saveTask()
    }
    
    func setFilter(_ filter: TaskFilter) {
        currentFilter = filter
    }
    
    func setSort(_ sort: TaskSort) {
        currentSort = sort
    }
    
    func setSearchText(_ text: String) {
        searchText = text
    }
    
    private func filterTasks(_ task: [ToDoTask], by filter: TaskFilter) -> [ToDoTask] {
        switch filter {
        case .all:
            return task
        case .pending:
            return task.filter { !$0.isCompleted }
        case .completed:
            return task.filter { $0.isCompleted }
        case .overdue:
            return task.filter { $0.isOverdue}
        case .highPriority:
            return task.filter { $0.priority == .high && !$0.isCompleted }
        }
    }
    
    private func sortTasks(_ task: [ToDoTask], by sort: TaskSort) -> [ToDoTask] {
    switch sort {
        case .newest:
            return task.sorted { $0.createdDate > $1.createdDate }
        case .oldest:
            return task.sorted { $0.createdDate < $1.createdDate }
        case .alphabetical:
            return task.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        case .priority:
            return task.sorted {
                if $0.priority == .high && $1.priority == .high {
                    return $0.createdDate > $1.createdDate
                }
                return priorityOrder($0.priority) < priorityOrder($1.priority)
            }
        case .completion:
            return task.sorted {
                if $0.isCompleted == $1.isCompleted {
                    return $0.createdDate > $1.createdDate
                }
                return !$0.isCompleted && $1.isCompleted
            }
        }
    }
    
    private func priorityOrder(_ priority: ToDoTask.Priority) -> Int {
        switch priority {
        case .high:
            return 0
        case .medium:
            return 1
        case .low:
            return 2
        }
    }
    
    private func saveTask() {
        repository.saveTask(task)
    }
    
    private func loadTask() {
        task = repository.loadTask()
    }

    
}

class TodoRepository {
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "SaveToDoTask"
    
    func saveTask(_ tasks: [ToDoTask]) {
        do {
            let encoded = try JSONEncoder().encode(tasks)
            userDefaults.set(encoded, forKey: tasksKey)
        } catch {
            print("Failed to save task: \(error)")
        }
    }
    
    func loadTask() -> [ToDoTask] {
        guard let data = userDefaults.data(forKey: tasksKey) else {
            return []
        }
        
        do {
            let decoded = try JSONDecoder().decode([ToDoTask].self, from: data)
            return decoded
        } catch {
            print("Failed to load task: \(error)")
            return []
        }
    }
    func clearAllData() {
        userDefaults.removeObject(forKey: tasksKey)
    }
}



