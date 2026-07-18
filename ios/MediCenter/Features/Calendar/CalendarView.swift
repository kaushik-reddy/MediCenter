import SwiftUI

struct CalendarView: View {
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Calendar", subtitle: "Track your medication history by date")
            ScrollView {
                VStack(spacing: 12) {
                    MonthCard()
                    DaySummaryCard()
                    QuickStatsCard()
                    Banner()
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 120)
            }
        }
        .background(Theme.bg)
    }
}

private func dotColor(_ c: DotColor) -> Color {
    switch c { case .green: return Theme.green; case .amber: return Theme.amber; case .red: return Theme.red }
}

private struct MonthCard: View {
    let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    var body: some View {
        SectionCard {
            VStack(spacing: 8) {
                HStack {
                    circleBtn("chevron.left")
                    Spacer()
                    HStack(spacing: 8) {
                        Text(CalendarData.monthLabel).font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                        circleBtn("chevron.right")
                    }
                    Spacer()
                    Text("Today")
                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.brand500)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Theme.brand500.opacity(0.4), lineWidth: 1))
                }

                LazyVGrid(columns: cols, spacing: 4) {
                    ForEach(CalendarData.weekdays, id: \.self) { d in
                        Text(d).font(.system(size: 11, weight: .medium)).foregroundStyle(Theme.textMuted)
                    }
                }
                .padding(.bottom, 6)
                .overlay(Rectangle().frame(height: 1).foregroundStyle(Theme.border), alignment: .bottom)

                LazyVGrid(columns: cols, spacing: 6) {
                    ForEach(CalendarData.days) { cell in
                        VStack(spacing: 2) {
                            if cell.today {
                                Text("\(cell.day)").font(.system(size: 13, weight: .bold)).foregroundStyle(.white)
                                    .frame(width: 30, height: 30).background(Theme.brand500).clipShape(Circle())
                            } else {
                                Text("\(cell.day)").font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(cell.inMonth ? Theme.text : Theme.textFaint)
                                    .frame(width: 30, height: 30)
                            }
                            HStack(spacing: 2) {
                                ForEach(cell.dots.indices, id: \.self) { j in
                                    Circle().fill(dotColor(cell.dots[j])).frame(width: 5, height: 5)
                                }
                            }
                            .frame(height: 5)
                        }
                    }
                }
                .padding(.top, 6)

                HStack {
                    legend(Theme.green, "Taken"); Spacer()
                    legend(Theme.amber, "Late"); Spacer()
                    legend(Theme.red, "Missed"); Spacer()
                    legend(Theme.textFaint, "No Data")
                }
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
                .padding(.top, 4)
            }
        }
    }

    private func circleBtn(_ icon: String) -> some View {
        Image(systemName: icon).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
            .frame(width: 30, height: 30).background(Theme.surface2).clipShape(Circle())
    }
    private func legend(_ c: Color, _ t: String) -> some View {
        HStack(spacing: 5) {
            Circle().fill(c).frame(width: 8, height: 8)
            Text(t).font(.system(size: 11, weight: .medium)).foregroundStyle(Theme.textMuted)
        }
    }
}

private struct DaySummaryCard: View {
    var body: some View {
        SectionCard {
            VStack(spacing: 12) {
                HStack {
                    Text(CalendarData.selectedDayLabel).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                    Spacer()
                    HStack(spacing: 6) {
                        Image(systemName: "chart.bar").font(.system(size: 12))
                        Text("Summary").font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(Theme.brand500)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Theme.brand500.opacity(0.4), lineWidth: 1))
                }

                HStack(spacing: 8) {
                    statTile(Theme.greenSoft, Theme.green, "checkmark.circle.fill", CalendarData.selectedStats.taken, "Taken")
                    statTile(Theme.amberSoft, Theme.amber, "clock.fill", CalendarData.selectedStats.late, "Late")
                    statTile(Theme.redSoft, Theme.red, "xmark.circle.fill", CalendarData.selectedStats.missed, "Missed")
                }

                VStack(spacing: 0) {
                    ForEach(Array(CalendarData.selectedMeds.enumerated()), id: \.element.id) { idx, med in
                        medRow(med, last: idx == CalendarData.selectedMeds.count - 1)
                    }
                }
            }
        }
    }

    private func statTile(_ bg: Color, _ fg: Color, _ icon: String, _ n: Int, _ label: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 16)).foregroundStyle(fg)
            VStack(alignment: .leading, spacing: 0) {
                Text("\(n)").font(.system(size: 18, weight: .heavy)).foregroundStyle(fg)
                Text(label).font(.system(size: 11)).foregroundStyle(Theme.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(bg).clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func medRow(_ med: DayMed, last: Bool) -> some View {
        let whenIcon = med.when == .morning ? "sunrise.fill" : med.when == .noon ? "sun.max.fill" : "moon.fill"
        let whenBg = med.when == .morning ? Theme.greenSoft : med.when == .noon ? Theme.amberSoft : Theme.brandSoft
        let whenFg = med.when == .morning ? Theme.green : med.when == .noon ? Theme.amber : Theme.brand500
        let timeColor = med.status == .late ? Theme.amber : Theme.text
        return HStack(spacing: 12) {
            Image(systemName: whenIcon).font(.system(size: 15)).foregroundStyle(whenFg)
                .frame(width: 36, height: 36).background(whenBg).clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(med.name).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text).lineLimit(1)
                Text(med.detail).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted).lineLimit(1)
            }
            Spacer(minLength: 4)
            Text(med.time).font(.system(size: 13, weight: .bold)).foregroundStyle(timeColor)
            Image(systemName: "chevron.right").font(.system(size: 13)).foregroundStyle(Theme.textFaint)
        }
        .padding(.vertical, 10)
        .overlay(last ? nil : Rectangle().frame(height: 1).foregroundStyle(Theme.border), alignment: .bottom)
    }
}

private struct QuickStatsCard: View {
    let cols = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
    var body: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Quick Stats  (\(CalendarData.quick.month))")
                    .font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                LazyVGrid(columns: cols, spacing: 10) {
                    tile(Theme.brandSoft, Theme.brand500, "calendar", "\(CalendarData.quick.takenDays)", "Taken Days")
                    tile(Theme.amberSoft, Theme.amber, "clock", "\(CalendarData.quick.lateDays)", "Late Days")
                    tile(Theme.redSoft, Theme.red, "xmark", "\(CalendarData.quick.missedDays)", "Missed Days")
                    tile(Theme.blueSoft, Theme.blue, "chart.line.uptrend.xyaxis", "\(CalendarData.quick.adherence)%", "Adherence")
                }
            }
        }
    }
    private func tile(_ bg: Color, _ fg: Color, _ icon: String, _ n: String, _ label: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 16)).foregroundStyle(fg)
                .frame(width: 36, height: 36).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(n).font(.system(size: 17, weight: .heavy)).foregroundStyle(fg)
                Text(label).font(.system(size: 11)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12).padding(.vertical, 12)
        .background(bg).clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct Banner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar").font(.system(size: 18)).foregroundStyle(Theme.brand500)
                .frame(width: 36, height: 36).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 1) {
                Text("Stay consistent!").font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.brand500)
                Text("Great job! You're building a healthy streak.").font(.system(size: 12)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.system(size: 15)).foregroundStyle(Theme.brand500)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.brandSoft)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
