# 📝 Simple Todo App

A beautiful and intuitive todo application built with SwiftUI and following the MVC (Model-View-Controller) architecture pattern.

## ✨ Features

### Core Functionality
- ✅ **Create Tasks** - Add new tasks with titles, priorities, and categories
- ✅ **Edit Tasks** - Modify existing task details
- ✅ **Delete Tasks** - Remove individual tasks or bulk delete
- ✅ **Complete Tasks** - Mark tasks as done with smooth animations
- ✅ **Task Categories** - Organize tasks by custom categories

### Advanced Features
- 🔍 **Search & Filter** - Find tasks quickly with search and filtering options
- 📊 **Statistics** - View completion rates and task analytics
- 🎨 **Priority System** - High, Medium, Low priority levels with visual indicators
- ⏰ **Overdue Detection** - Automatic detection of overdue tasks
- 💾 **Data Persistence** - Tasks saved automatically using UserDefaults
- 🔄 **Multiple Sort Options** - Sort by date, priority, completion status, or alphabetically

### User Experience
- 🎯 **Intuitive UI** - Clean and modern SwiftUI interface
- 📱 **Swipe Actions** - Quick actions with left/right swipes
- 🌟 **Smooth Animations** - Delightful micro-interactions
- 📈 **Progress Tracking** - Visual completion percentage
- 🎨 **Priority Badges** - Color-coded priority indicators

## 🏗️ Architecture

This project follows the **MVC (Model-View-Controller)** pattern:

```
simpletodoapp/
├── Model/
│   └── ToDoTask.swift           # Task data model & enums
├── Controller/
│   └── TodoController.swift     # Business logic & data management
├── Views/
│   ├── ContentView.swift        # Main app container
│   ├── TaskListView.swift       # Task list & row components
│   ├── TaskFormView.swift       # Add/Edit task forms
│   └── SettingViews.swift       # Settings & statistics
└── Assets.xcassets/             # App icons & colors
```

### Key Components

#### Model Layer
- **`ToDoTask`** - Core task data structure with properties:
  - Title, completion status, creation date
  - Priority levels (High, Medium, Low)
  - Categories and overdue detection
- **`TaskFilter`** - Filtering options (All, Pending, Completed, Overdue, High Priority)
- **`TaskSort`** - Sorting options (Newest, Oldest, Alphabetical, Priority, Completion)

#### Controller Layer
- **`TodoController`** - Manages all business logic:
  - Task CRUD operations
  - Search and filtering logic
  - Statistics calculations
  - Data persistence with UserDefaults

#### View Layer
- **`ContentView`** - Main navigation and layout
- **`TaskListViewMain`** - Displays filtered/sorted task list
- **`TaskRowView`** - Individual task row with actions
- **`TaskFormView`** - Add new tasks with validation
- **`EditTaskView`** - Edit existing task details
- **`SettingViews`** - App statistics and bulk actions

## 🚀 Getting Started

### Prerequisites
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/simpletodoapp.git
   cd simpletodoapp
   ```

2. **Open in Xcode**
   ```bash
   open simpletodoapp.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 📱 Usage

### Adding Tasks
1. Tap the "+" button in the navigation bar
2. Enter task title (required)
3. Select priority level and category
4. Tap "Add Task" to save

### Managing Tasks
- **Complete**: Tap the circle icon or swipe right
- **Edit**: Tap the pencil icon or tap on task row
- **Delete**: Swipe left or use delete action

### Filtering & Sorting
- Use the filter picker to show specific task types
- Choose sort options from the sort menu
- Search tasks by title or category

### Statistics
- Access settings to view task statistics
- See completion rates and task counts
- Bulk delete completed or all tasks

## 🎨 UI Components

### Custom Views
- **`PriorityBadge`** - Colored priority indicators
- **`CategoryBadge`** - Task category labels
- **`EmptyStateView`** - Contextual empty states
- **`StatRow`** - Statistics display rows

### Animations
- Smooth task completion toggles
- Swipe action feedback
- Delete animations with spring effects

## 💾 Data Management

### Persistence
- Tasks automatically saved to UserDefaults
- JSON encoding/decoding for complex data
- Automatic loading on app launch

### Data Flow
```
User Action → Controller → Model Update → View Refresh
```

## 🔧 Configuration

### Customization Options
- Default task categories
- Priority color schemes
- Animation durations
- Date formatting preferences

## 📊 Statistics Features

- **Total Tasks** - Overall task count
- **Completion Rate** - Percentage of completed tasks
- **Category Breakdown** - Tasks by category
- **Overdue Detection** - Automatic overdue flagging

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

**Triệu Hải Lâm**
- GitHub: [@your-username](https://github.com/your-username)
- Email: your.email@example.com

## 🙏 Acknowledgments

- SwiftUI framework for the beautiful UI components
- Apple's Human Interface Guidelines for design inspiration
- The iOS development community for best practices

---

⭐ **Star this repo if you found it helpful!**
