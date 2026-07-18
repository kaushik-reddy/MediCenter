import { useState } from 'react'
import {
  Settings as Gear,
  Bell,
  Pill,
  Activity,
  Phone,
  Palette,
  Globe,
  Ruler,
  CloudUpload,
  ShieldCheck,
  HelpCircle,
  Headphones,
  Info,
  ChevronRight,
  FlaskConical,
  Trash2,
} from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { useTheme } from '../../theme/ThemeProvider'
import { useNavigate } from 'react-router-dom'
import { TopBar } from '../../components/shell/TopBar'
import { SettingsGroup, SettingsRow, SettingsSectionLabel } from '../../components/ui/SettingsRow'
import { Modal, ModalActions } from '../../components/ui/Modal'
import { NotificationChannelsModal, InfoModal } from '../flows/FlowModals'
import { CheckCircle2 } from 'lucide-react'
import { useMeds } from '../../store/medStore'
import { useNotifications } from '../../store/notificationStore'

export function SettingsPage() {
  const { openDrawer, openModal } = useShell()
  const { resolved, toggle } = useTheme()
  const navigate = useNavigate()
  const { loadSampleData, clearAll } = useMeds()
  const { loadSample: loadSampleNotifications, clear: clearNotifications } = useNotifications()

  const loadSample = () => {
    loadSampleData()
    loadSampleNotifications()
    openModal(
      <InfoModal
        title="Sample data loaded"
        message="Loaded 12 medications, 30 days of history and 20 notifications for stress testing."
        icon={<FlaskConical size={22} />}
      />,
    )
  }

  const clearData = () => {
    clearAll()
    clearNotifications()
    openModal(
      <InfoModal
        title="All data cleared"
        message="Medications, history and notifications have been reset to empty."
        icon={<Trash2 size={22} />}
      />,
    )
  }

  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Settings" subtitle="Customize your experience" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-4 px-4 pt-1">
        {/* Hero */}
        <div className="flex items-center gap-3 rounded-[20px] bg-brand-gradient p-4 text-white">
          <span className="grid h-12 w-12 place-items-center rounded-2xl bg-white/20"><Gear size={24} /></span>
          <div>
            <p className="text-[16px] font-bold">Make it yours</p>
            <p className="text-[12.5px] text-white/80">Personalize MediCenter to fit your routine</p>
          </div>
        </div>

        <div>
          <SettingsSectionLabel>Preferences</SettingsSectionLabel>
          <SettingsGroup>
            <SettingsRow icon={Bell} title="Reminder & Notification" subtitle="Timing, channels, quiet hours" onClick={() => openModal(<NotificationChannelsModal />)} />
            <SettingsRow icon={Pill} title="Medications" subtitle="Default dose, refill & stock alerts" onClick={() => navigate('/medications')} />
            <SettingsRow icon={Activity} title="Health Insights" subtitle="Metrics and tracking preferences" onClick={() => navigate('/insights')} />
            <SettingsRow icon={Phone} title="Emergency Contacts" subtitle="Manage your emergency contacts" onClick={() => navigate('/contacts')} last />
          </SettingsGroup>
        </div>

        <div>
          <SettingsSectionLabel>App Settings</SettingsSectionLabel>
          <SettingsGroup>
            <SettingsRow
              icon={Palette}
              title="Appearance"
              subtitle="Theme, color and display"
              onClick={toggle}
              trailing={<Pill2 label={resolved === 'dark' ? 'Dark' : 'Light'} />}
            />
            <SettingsRow icon={Globe} title="Language" subtitle="Choose your language" onClick={() => openModal(<LanguageModal />)} trailing={<Pill2 label="English" />} />
            <SettingsRow icon={Ruler} title="Units" subtitle="Weight, height, temperature" onClick={() => openModal(<UnitsModal />)} last />
          </SettingsGroup>
        </div>

        <div>
          <SettingsSectionLabel>Account &amp; Data</SettingsSectionLabel>
          <SettingsGroup>
            <SettingsRow icon={CloudUpload} title="Backup & Restore" subtitle="Keep your data safe" onClick={() => openModal(<InfoModal title="Backup & Restore" message="Back up your data locally or restore from a previous backup." />)} />
            <SettingsRow icon={ShieldCheck} title="Privacy & Security" subtitle="App lock, encryption and more" onClick={() => openModal(<InfoModal title="Privacy & Security" message="Enable app lock and encryption to protect your health data." />)} last />
          </SettingsGroup>
        </div>

        <div>
          <SettingsSectionLabel>Developer</SettingsSectionLabel>
          <SettingsGroup>
            <SettingsRow icon={FlaskConical} title="Load Sample Data" subtitle="30 days of meds, history & notifications" onClick={loadSample} />
            <SettingsRow icon={Trash2} title="Clear All Data" subtitle="Reset the app back to empty" onClick={clearData} last />
          </SettingsGroup>
        </div>

        <div>
          <SettingsSectionLabel>Support</SettingsSectionLabel>
          <SettingsGroup>
            <SettingsRow icon={HelpCircle} title="Help & FAQs" subtitle="Get help and find answers" onClick={() => openModal(<InfoModal title="Help & FAQs" message="Find answers to common questions and learn how to use MediCenter." />)} />
            <SettingsRow icon={Headphones} title="Contact Support" subtitle="We're here to help you" onClick={() => openModal(<InfoModal title="Contact Support" message="Reach our support team at support@medicenter.app anytime." />)} />
            <SettingsRow icon={Info} title="About MediCenter" subtitle="Version 1.2.0" onClick={() => openModal(<InfoModal title="About MediCenter" message="MediCenter v1.2.0 — your personal medication companion." />)} last />
          </SettingsGroup>
        </div>
      </div>
    </div>
  )
}

function Pill2({ label }: { label: string }) {
  return (
    <span className="flex items-center gap-1 rounded-lg bg-brand-soft px-2.5 py-1.5 text-[12px] font-semibold text-brand-500">
      {label}
      <ChevronRight size={13} />
    </span>
  )
}

function LanguageModal() {
  const [lang, setLang] = useState('English')
  const langs = ['English', 'हिंदी', 'తెలుగు', 'தமிழ்', 'বাংলা', 'मराठी', 'ಕನ್ನಡ']
  return (
    <Modal icon={<Globe size={22} />} title="Language" subtitle="Choose your preferred language">
      <div className="mb-2 space-y-1.5">
        {langs.map((l) => (
          <button key={l} onClick={() => setLang(l)} className={`flex w-full items-center justify-between rounded-xl px-3.5 py-3 text-[14px] font-semibold ${lang === l ? 'bg-brand-soft text-brand-500' : 'bg-surface-2 text-text'}`}>
            {l}
            {lang === l && <CheckCircle2 size={17} />}
          </button>
        ))}
      </div>
      <ModalActions primaryLabel="Save Language" />
    </Modal>
  )
}

function UnitsModal() {
  const [w, setW] = useState('kg')
  const [t, setT] = useState('°C')
  return (
    <Modal icon={<Ruler size={22} />} title="Units" subtitle="Choose measurement units">
      <UnitRow label="Weight" options={['kg', 'lb']} value={w} onChange={setW} />
      <UnitRow label="Temperature" options={['°C', '°F']} value={t} onChange={setT} />
      <ModalActions primaryLabel="Save Units" />
    </Modal>
  )
}
function UnitRow({ label, options, value, onChange }: { label: string; options: string[]; value: string; onChange: (v: string) => void }) {
  return (
    <div className="mb-3">
      <p className="mb-1.5 text-[12.5px] font-semibold text-text-muted">{label}</p>
      <div className="flex gap-2">
        {options.map((o) => (
          <button key={o} onClick={() => onChange(o)} className={`flex-1 rounded-xl py-2.5 text-[13px] font-bold ${value === o ? 'bg-brand-soft text-brand-500 ring-1 ring-brand-500' : 'bg-surface-2 text-text-muted'}`}>{o}</button>
        ))}
      </div>
    </div>
  )
}
