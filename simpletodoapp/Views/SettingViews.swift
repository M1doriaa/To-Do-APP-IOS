//
//  SettingViews.swift
//  simpletodoapp
//
//  Created by Triệu Hải Lâm on 6/7/25.
//

import SwiftUI

struct SettingViews: View {
    @ObservedObject var controller: TodoController
    @Environment(\.presentationMode) var presentationMode
    @State private var showingClearAlert = false
    @State private var showingDeleteCompletedAlert = false
    var body: some View {
        NavigationView {
            Form {
                Section("Thống kê") {
                    StatRow(title: "Tổng số task", value: "\(controller.task.count)")
                    StatRow(title: "Đã hoàn thành", value: "\(controller.completedTaskCount)")
                    StatRow(title: "Chưa hoàn thành", value: "\(controller.pendingTaskCount)")
                    StatRow(title: "Quá hạn", value: "\(controller.overdueTaskCount)")
                    StatRow(title: "Tỷ lệ hoàn thành", value: String(format: "%.1f", controller.completionPercentage))
                }
                
                Section("Hành Động nhanh") {
                    Button(action: {
                        showingDeleteCompletedAlert = true
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(.green)
                            Text("Xoá task đã hoàn thành")
                        }
                    }
                    .disabled(controller.completedTaskCount == 0)
                    
                    Button(action: {
                        showingClearAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Xoá tất cả task")
                        }
                    }
                    .disabled(controller.task.isEmpty)
                }
                
                Section("Quản lý dữ liệu") {
                    VStack(alignment: .leading, spacing: 8 ) {
                        Text("Dữ liệu được lưu tự động")
                            .font(.body)
                        Text("Ứng dụng sẽ được tự động lưu các thay đổi vào bộ nhớ thiết bị")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Thông tin ứng dụng") {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("To To App")
                            .font(.headline)
                        Text("version 1.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Được xây dựng với SwiftUI")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(Text("Cài đặt"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
        }
        .alert("Xoá tất cả task", isPresented: $showingClearAlert) {
            Button("Huỷ", role: .cancel) {}
            Button("Xoá", role: .destructive) {
                controller.clearAllData()
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Bạn có chắc chắn muốn xoá tất cả các task?")
        }
        .alert("Xoá các task đã hoàn thành", isPresented: $showingDeleteCompletedAlert) {
            Button("Huỷ", role: .cancel) {}
            Button("Xoá", role: .destructive) {
                controller.clearCompletedTask()
            }
        } message: {
            Text("Bạn có chắc chăn muốn xoá các task đã hoàn thành")
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    SettingViews(controller: TodoController())
}
