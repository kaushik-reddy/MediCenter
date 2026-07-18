import SwiftUI

struct TodayScheduleCard: View {
    let items: [ScheduleItem]
    var onViewAll: () -> Void = {}

    var body: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(
                    systemImage: "calendar",
                    title: "Today's Schedule",
                    actionLabel: "View all",
                    action: onViewAll
                )

                ZStack(alignment: .topLeading) {
                    // dotted connector rail
                    Rectangle()
                        .fill(Theme.border)
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                        .padding(.vertical, 30)
                        .padding(.leading, 18)

                    VStack(spacing: 10) {
                        ForEach(items) { item in
                            ScheduleRow(item: item)
                        }
                    }
                }
            }
        }
    }
}

private struct ScheduleRow: View {
    let item: ScheduleItem

    var body: some View {
        HStack(spacing: 8) {
            statusCircle
            Text(item.time)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(timeColor)
                .frame(width: 56, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 13.5, weight: .bold))
                    .foregroundStyle(Theme.text)
                    .lineLimit(1)
                Text(item.detail)
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.textMuted)
                    .lineLimit(1)
            }
            Spacer(minLength: 4)

            statusPill
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Theme.border, lineWidth: 1)
        )
    }

    private var statusCircle: some View {
        ZStack {
            switch item.status {
            case .taken:
                Circle().fill(Theme.green)
                Image(systemName: "checkmark").font(.system(size: 15, weight: .heavy)).foregroundStyle(.white)
            case .upcoming:
                Circle().fill(Theme.brand500)
                Image(systemName: "clock").font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
            case .late:
                Circle().fill(Theme.amber)
                Image(systemName: "clock").font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
            case .missed:
                Circle().fill(Theme.red)
                Image(systemName: "xmark").font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
            case .pending:
                Circle().fill(Theme.surface).overlay(Circle().strokeBorder(Theme.borderStrong, lineWidth: 2))
            }
        }
        .frame(width: 32, height: 32)
    }

    private var statusPill: some View {
        HStack(spacing: 4) {
            if item.status == .taken {
                Image(systemName: "checkmark").font(.system(size: 10, weight: .heavy))
            }
            Text(pillLabel)
                .font(.system(size: 10.5, weight: .semibold))
        }
        .foregroundStyle(pillColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(pillBg)
        .clipShape(Capsule())
    }

    private var timeColor: Color {
        switch item.status {
        case .taken: return Theme.green
        case .upcoming: return Theme.brand500
        case .late: return Theme.amber
        case .missed: return Theme.red
        case .pending: return Theme.text
        }
    }
    private var pillLabel: String {
        switch item.status {
        case .taken: return "Taken"
        case .upcoming: return "Upcoming"
        case .late: return "Late"
        case .missed: return "Missed"
        case .pending: return "Pending"
        }
    }
    private var pillColor: Color {
        switch item.status {
        case .taken: return Theme.green
        case .upcoming: return Theme.brand500
        case .late: return Theme.amber
        case .missed: return Theme.red
        case .pending: return Theme.textMuted
        }
    }
    private var pillBg: Color {
        switch item.status {
        case .taken: return Theme.greenSoft
        case .upcoming: return Theme.brandSoft
        case .late: return Theme.amberSoft
        case .missed: return Theme.redSoft
        case .pending: return Theme.surface2
        }
    }
}
