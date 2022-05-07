import WidgetKit
import SwiftUI
import Defaults

struct ListData: Codable {
    let id: UUID
    let name: String
    let progress: CGFloat
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> ListEntry {
        ListEntry(date: Date(),
                  context: context,
                  list: [],
                  count: 0)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ListEntry) -> ()) {
        WidgetHelper.reloadList() { error in
            let entry = ListEntry(date: Date(),
                                  context: context,
                                  list: WidgetHelper.list,
                                  count: WidgetHelper.list.count)
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        WidgetHelper.reloadList() { error in
            let entry = ListEntry(date: Date(),
                                  context: context,
                                  list: WidgetHelper.list,
                                  count: WidgetHelper.list.count)
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            
            completion(timeline)
        }
    }
}

struct ListEntry: TimelineEntry {
    let date: Date
    var context: TimelineProviderContext?
    var list: [ListData] = [ListData
    ]()
    // 总数
    var count = 0
}

struct ListWidgetEntryView : View {
    @Environment(\.colorScheme) private var colorScheme
    @Default(.appLockEnabled) var appLockEnabled
    @Default(.hideWidgetEnabled) var hideWidgetEnabled
    var entry: Provider.Entry
    
    var body: some View {
        let isLocked = self.appLockEnabled && self.hideWidgetEnabled
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("ListWidgetEntryViewTitle").foregroundColor(Color("AccentColor"))
                    Spacer()
                    Text("\(entry.count)")
                    
                }.font(.system(size: getTitleFontSize(), weight: .bold, design: .rounded))
                    .padding(.bottom, 8)
                self.content
            }
            .padding(.vertical, 17)
            .padding(.horizontal, 15)
            .background(self.colorScheme == ColorScheme.dark ? Color(UIColor.secondarySystemBackground) : nil)
            .blur(radius: isLocked ? 25 : 0)
            if isLocked {
                self.lockedView()
            }
        }
    }
    
    private var content: AnyView {
        if self.entry.count <= 0 {
            return AnyView(self.emptyDataView())
        } else {
            return AnyView(self.loadedView())
        }
    }
    
    func getTitleFontSize() -> CGFloat {
        switch self.entry.context?.family {
        case .systemSmall:
            fallthrough
        case .systemMedium:
            return 18
        default:
            return 22
        }
    }
}

let CircularProgressSize: CGFloat = 14

extension ListWidgetEntryView {
    func ListCell(item: ListData) -> some View {
        HStack {
            CircularProgress(item.progress)
                .frame(width: CircularProgressSize, height: CircularProgressSize)
                .foregroundColor(.blue)
            Text(item.name)
                .font(getNameFont())
                .bold()
                .lineLimit(1)
            Spacer()
        }
    }
    
    func getNameFont() -> Font {
        switch self.entry.context?.family {
        case .systemSmall:
            return .caption2
        case .systemMedium:
            return .caption
        default:
            return .callout
        }
    }
}

extension ListWidgetEntryView {
    func emptyDataView() -> some View {
        Group {
            Spacer()
            HStack {
                Spacer()
                Text("WidgetNoData").foregroundColor(.secondary)
                Spacer()
            }
            Spacer()
        }
    }
}

extension ListWidgetEntryView {
    func loadedView() -> some View {
        Group {
            let displayCount = getDisplayCount()
            let endindex = entry.list.count >= displayCount ? displayCount : entry.list.count
            let list = entry.list[0..<endindex]
            ForEach(list, id: \.id) { item in
                VStack {
                    let index = list.firstIndex(where: {
                        $0.id == item.id
                    }) ?? 0
                    self.ListCell(item: item).frame(height: getCellHeight())
                    if index < list.count - 1 {
                        Divider()
                    }
                }
            }
            .padding(.top, 4)
            Spacer()
        }
    }
    
    func getDisplayCount() -> Int {
        switch self.entry.context?.family {
        case .systemSmall:
            fallthrough
        case .systemMedium:
            return 4
        default:
            return 9
        }
    }
    
    func getCellHeight() -> CGFloat {
        switch self.entry.context?.family {
        case .systemSmall:
            fallthrough
        case .systemMedium:
            return 8
        default:
            return 16
        }
    }
}

extension ListWidgetEntryView {
    func lockedView() -> some View {
        VStack(spacing: 5) {
            Image(systemName: "lock")
                .font(.title)
                .foregroundColor(Color(UIColor.systemBlue))
            Text("WidgetLocked").font(.caption)
        }
    }
}

@main
struct DailyTodoWidget: Widget {
    let kind: String = "DailyTodoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WidgetDisplayName")
        .description("WidgetDescription")
    }
}



struct DailyTodoWidget_Previews: PreviewProvider {
    static var previews: some View {
        ListWidgetEntryView(entry: ListEntry(date: Date()))
            .previewDevice("iPhone 13")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
