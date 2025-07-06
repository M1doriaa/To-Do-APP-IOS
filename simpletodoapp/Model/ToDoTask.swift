//
//  ToDoTask.swift
//  simpletodoapp
//
//  Created by Triệu Hải Lâm on 5/7/25.
//

import Foundation

struct ToDoTask: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var createdDate: Date = Date()
    var priority: Priority = .medium
    var category: String = "General"
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Thấp"
        case medium = "Bình Thường"
        case high = "Cao"
        
        var color: String {
            switch self {
            case .low: return "green"
            case .medium: return "orange"
            case .high: return "red"
            }
        }
    }
    
    var formattedDate: String {
        let formattedDate = DateFormatter()
        formattedDate.dateStyle = .short
        formattedDate.timeStyle = .short
        return formattedDate.string(from: createdDate)
    }
    
    var formattedDateOnly: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdDate)
    }
    
    var isOverdue: Bool {
        return !isCompleted && createdDate < Date().addingTimeInterval(-24 * 60 * 60)
    }
    
    var displayTitle: String {
        return title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum TaskFilter: String, CaseIterable {
    case all = "Tất cả"
    case pending = "Chưa hoàn thành"
    case completed = "Đã hoàn thành"
    case overdue = "Hết hạn"
    case highPriority = "Cao Ưu Tiên"
}

enum TaskSort: String, CaseIterable {
    case newest = "Mới nhất"
    case oldest = "Cũ nhất"
    case alphabetical = "A-Z"
    case priority = "Ưu Tiên"
    case completion = "Trạng thái"
}
