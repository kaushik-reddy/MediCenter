import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import { ThemeProvider } from './theme/ThemeProvider'
import { MedProvider } from './store/medStore'
import { NotificationProvider } from './store/notificationStore'
import { ProfileProvider } from './store/profileStore'
import { AppShell } from './components/shell/AppShell'
import { PlaceholderPage } from './routes/PlaceholderPage'
import { HomePage } from './features/home/HomePage'
import { MedicationsPage } from './features/medications/MedicationsPage'
import { MedicineDetailPage } from './features/medications/MedicineDetailPage'
import { CalendarPage } from './features/calendar/CalendarPage'
import { HistoryPage } from './features/history/HistoryPage'
import { ProfilePage } from './features/profile/ProfilePage'
import { RemindersPage } from './features/reminders/RemindersPage'
import { NotificationsPage } from './features/notifications/NotificationsPage'
import { InventoryPage } from './features/inventory/InventoryPage'
import { AnalyticsPage } from './features/analytics/AnalyticsPage'
import { HealthInsightsPage } from './features/insights/HealthInsightsPage'
import { HealthReportsPage } from './features/reports/HealthReportsPage'
import { DoctorVisitsPage } from './features/visits/DoctorVisitsPage'
import { InteractionCheckerPage } from './features/interactions/InteractionCheckerPage'
import { CaregiverPage } from './features/caregiver/CaregiverPage'
import { EmergencyContactsPage } from './features/contacts/EmergencyContactsPage'
import { TravelModePage } from './features/travel/TravelModePage'
import { SettingsPage } from './features/settings/SettingsPage'

const router = createBrowserRouter([
  {
    element: <AppShell />,
    children: [
      // Core bottom-nav tabs
      { path: '/', element: <HomePage /> },
      { path: '/medications', element: <MedicationsPage /> },
      { path: '/medications/:id', element: <MedicineDetailPage /> },
      { path: '/calendar', element: <CalendarPage /> },
      { path: '/history', element: <HistoryPage /> },
      { path: '/add', element: <PlaceholderPage title="Add Medication" /> },

      // Drawer pages
      { path: '/profile', element: <ProfilePage /> },
      { path: '/reminders', element: <RemindersPage /> },
      { path: '/notifications', element: <NotificationsPage /> },
      { path: '/inventory', element: <InventoryPage /> },
      { path: '/analytics', element: <AnalyticsPage /> },
      { path: '/insights', element: <HealthInsightsPage /> },
      { path: '/reports', element: <HealthReportsPage /> },
      { path: '/visits', element: <DoctorVisitsPage /> },
      { path: '/interactions', element: <InteractionCheckerPage /> },
      { path: '/caregiver', element: <CaregiverPage /> },
      { path: '/contacts', element: <EmergencyContactsPage /> },
      { path: '/travel', element: <TravelModePage /> },
      { path: '/settings', element: <SettingsPage /> },

      { path: '*', element: <PlaceholderPage title="Not Found" subtitle="404" /> },
    ],
  },
])

export default function App() {
  return (
    <ThemeProvider>
      <ProfileProvider>
        <MedProvider>
          <NotificationProvider>
            <RouterProvider router={router} />
          </NotificationProvider>
        </MedProvider>
      </ProfileProvider>
    </ThemeProvider>
  )
}
