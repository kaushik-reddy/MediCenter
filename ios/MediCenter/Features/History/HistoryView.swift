import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "History", subtitle: "Your medication history and activity.")
            ScrollView {
                VStack(spacing: 12) {
                    SummaryCard()
                    SearchRow()
                    ForEach(HistoryData.groups) { group in
                        GroupCard(group: group)
                    }
                    InsightsBanner()
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 120)
            }
        }
        .background(Theme.bg)
    }
}

private struct SummaryCard: View {
    let s = HistoryData.summary
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Text(s.period).font(.system(size: 13, weight: .semibold))
                    Image(systemName: "chevron.down").font(.system(size: 11, weight: .semibold))
                }
                .foregroundStyle(Theme.brand500)
                Text("\(s.percent)%").font(.system(size: 34, weight: .heavy)).foregroundStyle(Theme.brand500).padding(.top, 2)
                Text("Taken on time").font(.system(size: 13, weight: .medium)).foregroundStyle(Theme.text)
                ProgressBar(percent: s.percent).frame(height: 8).padding(.top, 8)
                Text(s.doses).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted).padding(.top, 6)
            }
            HStack(spacing: 8) {
                miniStat(Theme.greenSoft, Theme.green, "checkmark", s.taken, "Taken")
                miniStat(Theme.amberSoft, Theme.amber, "clock", s.late, "Late")
                miniStat(Theme.redSoft, Theme.red, "xmark", s.missed, "Missed")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.brandSoft)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func miniStat(_ bg: Color, _ fg: Color, _ icon: String, _ n: Int, _ label: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(fg)
                .frame(width: 36, height: 36).background(bg).clipShape(RoundedRectangle(cornerRadius: 10))
            Text("\(n)").font(.system(size: 17, weight: .heavy)).foregroundStyle(fg)
            Text(label).font(.system(size: 10.5)).foregroundStyle(Theme.textMuted)
        }
        .frame(width: 50)
    }
}

private struct ProgressBar: View {
    let percent: Int
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.surface.opacity(0.7))
                Capsule().fill(Theme.brand500).frame(width: geo.size.width * CGFloat(percent) / 100)
            }
        }
    }
}

private struct SearchRow: View {
    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").font(.system(size: 15)).foregroundStyle(Theme.textFaint)
                Text("Search medication").font(.system(size: 13.5)).foregroundStyle(Theme.textFaint)
                Spacer()
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Theme.border, lineWidth: 1))

            chip("calendar", "Date Range", Theme.border)
            chip("slider.horizontal.3", "Filter", Theme.brand500.opacity(0.4))
        }
    }
    private func chip(_ icon: String, _ label: String, _ border: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 13))
            Text(label).font(.system(size: 12.5, weight: .semibold))
        }
        .foregroundStyle(Theme.brand500)
        .padding(.horizontal, 12).padding(.vertical, 12)
        .background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(border, lineWidth: 1))
    }
}

private struct GroupCard: View {
    let group: HistoryGroup
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(group.label).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.brand500)
                Text("•").foregroundStyle(Theme.textFaint)
                Text(group.date).font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.textMuted)
            }
            .padding(.leading, 4)

            VStack(spacing: 0) {
                ForEach(Array(group.rows.enumerated()), id: \.element.id) { idx, row in
                    rowView(row, last: idx == group.rows.count - 1)
                }
            }
            .padding(12)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
        }
    }

    private func rowView(_ row: HistoryRow, last: Bool) -> some View {
        let circle = row.status == .onTime ? Theme.green : row.status == .late ? Theme.amber : Theme.red
        let timeColor = circle
        let pillBg = row.status == .onTime ? Theme.greenSoft : row.status == .late ? Theme.amberSoft : Theme.redSoft
        let icon = row.status == .missed ? "xmark" : row.status == .late ? "clock" : "checkmark"
        return HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 15, weight: .heavy)).foregroundStyle(.white)
                .frame(width: 36, height: 36).background(circle).clipShape(Circle())
            Text(row.time).font(.system(size: 13, weight: .bold)).foregroundStyle(timeColor).frame(width: 62, alignment: .leading)
            VStack(alignment: .leading, spacing: 2) {
                Text(row.name).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text).lineLimit(1)
                Text(row.detail).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted).lineLimit(1)
            }
            Spacer(minLength: 4)
            Text(row.badge).font(.system(size: 11, weight: .semibold)).foregroundStyle(circle)
                .padding(.horizontal, 10).padding(.vertical, 5).background(pillBg).clipShape(Capsule())
        }
        .padding(.vertical, 10)
        .overlay(last ? nil : Rectangle().frame(height: 1).foregroundStyle(Theme.border), alignment: .bottom)
    }
}

private struct InsightsBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "list.clipboard.fill").font(.system(size: 26)).foregroundStyle(Theme.brand500)
                .frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: 2) {
                Text("See patterns, stay consistent").font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.brand500)
                Text("Track your history to build better habits and improve your health.")
                    .font(.system(size: 12)).foregroundStyle(Theme.textMuted).fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 4)
            HStack(spacing: 6) {
                Image(systemName: "chart.bar").font(.system(size: 13))
                Text("View Insights").font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(Theme.brand500)
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
        }
        .padding(14)
        .background(Theme.brandSoft)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
