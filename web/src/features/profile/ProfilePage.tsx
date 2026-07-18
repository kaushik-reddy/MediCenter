import { useRef, useState } from 'react'
import {
  Pencil,
  CalendarDays,
  CheckCircle2,
  Star,
  Heart,
  User,
  Lock,
  Mail,
  Smartphone,
  Clock,
  Pill,
  Palette,
  Globe,
  Sun,
  HelpCircle,
  Headphones,
  Star as StarIcon,
  Info,
  LogOut,
  ChevronRight,
  ShieldCheck,
} from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { useTheme } from '../../theme/ThemeProvider'
import { useMeds } from '../../store/medStore'
import { useProfile } from '../../store/profileStore'
import { fileToAvatarDataUrl } from '../../lib/image'
import { SettingsGroup, SettingsRow, SettingsSectionLabel } from '../../components/ui/SettingsRow'
import { Toggle } from '../../components/ui/Toggle'
import { Modal, Field, ModalActions } from '../../components/ui/Modal'
import { InfoModal, LogoutModal } from '../flows/FlowModals'

export function ProfilePage() {
  const { openDrawer, openModal } = useShell()
  const { resolved, toggle } = useTheme()
  const [emailNotif, setEmailNotif] = useState(true)
  const [pushNotif, setPushNotif] = useState(true)

  return (
    <div className="flex min-h-full flex-col">
      <TopBar
        title="Profile"
        subtitle="Manage your account and preferences."
        onMenu={openDrawer}
        notificationCount={0}
      />

      <div className="space-y-4 px-4 pt-1">
        <ProfileCard onEdit={() => openModal(<EditProfileModal />)} />

        {/* Account */}
        <div>
          <SettingsSectionLabel>Account</SettingsSectionLabel>
          <SettingsGroup>
            <SettingsRow icon={User} title="Personal Information" subtitle="Update your personal details" onClick={() => openModal(<EditProfileModal />)} />
            <SettingsRow icon={Lock} title="Login & Security" subtitle="Change password and security settings" onClick={() => openModal(<EditProfileModal />)} />
            <SettingsRow
              icon={Mail}
              title="Email Notifications"
              subtitle="Manage email reminders and updates"
              trailing={<Toggle on={emailNotif} onChange={setEmailNotif} />}
            />
            <SettingsRow
              icon={Smartphone}
              title="Push Notifications"
              subtitle="Manage push notification preferences"
              trailing={<Toggle on={pushNotif} onChange={setPushNotif} />}
              last
            />
          </SettingsGroup>
        </div>

        {/* Preferences */}
        <div>
          <SettingsSectionLabel>Preferences</SettingsSectionLabel>
          <SettingsGroup>
            <SettingsRow icon={Clock} title="Reminder Settings" subtitle="Default times, snooze and more" onClick={() => openModal(<InfoModal title="Reminder Settings" message="Set default reminder times, snooze duration and alert style." />)} />
            <SettingsRow icon={Pill} title="Medication Preferences" subtitle="Units, dosage format and other preferences" onClick={() => openModal(<InfoModal title="Medication Preferences" message="Choose your units, dosage format and display preferences." />)} />
            <SettingsRow
              icon={Palette}
              title="App Appearance"
              subtitle="Theme, color and display settings"
              onClick={toggle}
              trailing={<Pill2 icon={<Sun size={13} />} label={resolved === 'dark' ? 'Dark' : 'Light'} />}
            />
            <SettingsRow
              icon={Globe}
              title="Language"
              subtitle="Choose your preferred language"
              onClick={() => openModal(<LanguageModal />)}
              trailing={<Pill2 label="English" />}
              last
            />
          </SettingsGroup>
        </div>

        {/* Support & More */}
        <div>
          <SettingsSectionLabel>Support &amp; More</SettingsSectionLabel>
          <SettingsGroup>
            <SettingsRow icon={HelpCircle} title="Help & FAQs" subtitle="Get help and find answers" onClick={() => openModal(<InfoModal title="Help & FAQs" message="Find answers to common questions and learn how to use MediCenter." />)} />
            <SettingsRow icon={Headphones} title="Contact Support" subtitle="We're here to help you" onClick={() => openModal(<InfoModal title="Contact Support" message="Reach our support team at support@medicenter.app anytime." />)} />
            <SettingsRow icon={StarIcon} title="Rate Us" subtitle="If you enjoy using the app, please rate us" onClick={() => openModal(<InfoModal title="Rate MediCenter" message="Enjoying the app? Leave us a rating on the store!" />)} />
            <SettingsRow icon={Info} title="About App" subtitle="Version 1.2.0" onClick={() => openModal(<InfoModal title="About MediCenter" message="MediCenter v1.2.0 — your personal medication companion." />)} last />
          </SettingsGroup>
        </div>

        {/* Log out */}
        <button onClick={() => openModal(<LogoutModal />)} className="flex w-full items-center justify-center gap-2 rounded-[18px] bg-red-soft py-3.5 text-[15px] font-bold text-red-500 active:scale-[0.99]">
          <LogOut size={18} />
          Log Out
        </button>

        {/* Privacy banner */}
        <div className="mb-1 flex items-center gap-3 rounded-[18px] bg-brand-soft px-3.5 py-3.5">
          <PrivacyShield />
          <div className="min-w-0 flex-1">
            <p className="text-[13.5px] font-bold text-brand-500">Your health, our priority</p>
            <p className="text-[12px] text-text-muted">Your data is private and secure with us.</p>
          </div>
          <button onClick={() => openModal(<InfoModal title="Privacy Policy" message="Your data is stored locally and never shared without your consent." icon={<ShieldCheck size={22} />} />)} className="flex shrink-0 items-center gap-1.5 rounded-xl border border-brand-500/40 px-2.5 py-2 text-[12px] font-semibold text-brand-500 active:scale-95">
            <ShieldCheck size={14} />
            Privacy Policy
          </button>
        </div>
      </div>
    </div>
  )
}

function AvatarUpload({ variant }: { variant: 'card' | 'modal' }) {
  const { profile, setAvatar } = useProfile()
  const inputRef = useRef<HTMLInputElement>(null)

  const pick = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    e.currentTarget.value = ''
    if (!file) return
    try {
      setAvatar(await fileToAvatarDataUrl(file))
    } catch {
      /* ignore unreadable images */
    }
  }

  const box = variant === 'card' ? 'h-16 w-16 border-[3px]' : 'h-20 w-20 border-4'
  const iconSize = variant === 'card' ? 28 : 32
  const border = variant === 'card' ? 'border-white dark:border-white/10' : 'border-surface'
  const badge = variant === 'card' ? 'h-6 w-6 ring-brand-soft' : 'h-7 w-7 ring-surface'

  return (
    <div className="relative shrink-0">
      {profile.avatar ? (
        <img
          src={profile.avatar}
          alt="Profile"
          className={`${box} ${border} rounded-full object-cover shadow`}
        />
      ) : (
        <span className={`${box} ${border} grid place-items-center rounded-full bg-surface text-text-faint shadow`}>
          <User size={iconSize} />
        </span>
      )}
      <button
        type="button"
        onClick={() => inputRef.current?.click()}
        aria-label="Change profile picture"
        className={`${badge} absolute -bottom-1 -right-1 grid place-items-center rounded-full bg-brand-500 text-white ring-2 active:scale-95`}
      >
        <Camera />
      </button>
      <input ref={inputRef} type="file" accept="image/*" className="hidden" onChange={pick} />
    </div>
  )
}

function ProfileCard({ onEdit }: { onEdit: () => void }) {
  const { meds } = useMeds()
  const { profile } = useProfile()
  return (
    <div className="rounded-[20px] bg-brand-soft p-4">
      <div className="flex items-start gap-3">
        <AvatarUpload variant="card" />
        <div className="min-w-0 flex-1">
          <h2 className="truncate text-[18px] font-bold text-text">{profile.name || 'Your Name'}</h2>
          <p className="truncate text-[12.5px] text-text-muted">
            {profile.email || 'Tap edit to add your details'}
          </p>
          {profile.phone && (
            <p className="truncate text-[12.5px] text-text-muted">{profile.phone}</p>
          )}
        </div>
        <button
          onClick={onEdit}
          className="flex shrink-0 items-center gap-1.5 rounded-xl border border-brand-500/40 bg-surface/60 px-2.5 py-2 text-[12px] font-semibold text-brand-500 active:scale-95"
        >
          <Pencil size={13} />
          Edit Profile
        </button>
      </div>

      <div className="mt-4 flex items-stretch justify-between border-t border-white/50 pt-3 dark:border-white/10">
        <Stat icon={<CalendarDays size={15} />} fg="text-brand-500" value="0" label="Days Streak" />
        <Divider />
        <Stat icon={<CheckCircle2 size={15} />} fg="text-green-500" value="0%" label="On Time" />
        <Divider />
        <Stat icon={<Star size={15} />} fg="text-amber-500" value="0" label="Doses Taken" />
        <Divider />
        <Stat icon={<Heart size={15} />} fg="text-red-500" value={String(meds.length)} label="Medicines" />
      </div>
    </div>
  )
}

function Stat({ icon, fg, value, label }: { icon: React.ReactNode; fg: string; value: string; label: string }) {
  return (
    <div className="flex flex-1 flex-col items-center">
      <div className="flex items-center gap-1">
        <span className={fg}>{icon}</span>
        <span className={`text-[17px] font-extrabold ${fg}`}>{value}</span>
      </div>
      <span className="mt-0.5 text-center text-[10.5px] text-text-muted">{label}</span>
    </div>
  )
}

function Divider() {
  return <span className="mx-1 w-px self-stretch bg-white/50 dark:bg-white/10" />
}

function Pill2({ icon, label }: { icon?: React.ReactNode; label: string }) {
  return (
    <span className="flex items-center gap-1 rounded-lg bg-brand-soft px-2.5 py-1.5 text-[12px] font-semibold text-brand-500">
      {icon}
      {label}
      <ChevronRight size={13} />
    </span>
  )
}

function Camera() {
  return (
    <svg viewBox="0 0 24 24" className="h-3.5 w-3.5" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
      <circle cx="12" cy="13" r="4" />
    </svg>
  )
}

function PrivacyShield() {
  return (
    <div className="relative grid h-11 w-11 shrink-0 place-items-center">
      <svg viewBox="0 0 44 44" className="h-11 w-11">
        <defs>
          <linearGradient id="ps" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0" stopColor="#8b5cf6" />
            <stop offset="1" stopColor="#6d4fe0" />
          </linearGradient>
        </defs>
        <path d="M22 4 l14 5 v10 c0 11 -8 17 -14 20 c-6 -3 -14 -9 -14 -20 V9 Z" fill="url(#ps)" />
        <g fill="#fff">
          <rect x="18" y="18" width="8" height="12" rx="2" />
          <path d="M18 18 v-3 a4 4 0 0 1 8 0 v3" fill="none" stroke="#fff" strokeWidth="2.4" />
        </g>
        <circle cx="34" cy="30" r="7" fill="#22c55e" stroke="#fff" strokeWidth="2" />
        <path d="M31 30 l2 2 4 -4" stroke="#fff" strokeWidth="2" fill="none" strokeLinecap="round" />
      </svg>
    </div>
  )
}

function LanguageModal() {
  const [lang, setLang] = useState('English')
  const langs = ['English', 'हिंदी', 'తెలుగు', 'தமிழ்', 'বাংলা', 'मराठी', 'ಕನ್ನಡ']
  return (
    <Modal icon={<Globe size={22} />} title="Language" subtitle="Choose your preferred language">
      <div className="mb-2 space-y-1.5">
        {langs.map((l) => (
          <button
            key={l}
            onClick={() => setLang(l)}
            className={`flex w-full items-center justify-between rounded-xl px-3.5 py-3 text-[14px] font-semibold ${
              lang === l ? 'bg-brand-soft text-brand-500' : 'bg-surface-2 text-text'
            }`}
          >
            {l}
            {lang === l && <CheckCircle2 size={17} />}
          </button>
        ))}
      </div>
      <ModalActions primaryLabel="Save Language" />
    </Modal>
  )
}

function EditProfileModal() {
  const { profile, setProfile } = useProfile()
  const { closeModal } = useShell()
  const [name, setName] = useState(profile.name)
  const [email, setEmail] = useState(profile.email)
  const [phone, setPhone] = useState(profile.phone)
  return (
    <Modal
      icon={<Pencil size={22} />}
      title="Edit Profile"
      subtitle="Update your personal information"
    >
      <div className="mb-4 flex justify-center">
        <AvatarUpload variant="modal" />
      </div>
      <Field label="Full Name" value={name} onChange={setName} placeholder="Enter your name" />
      <Field label="Email" value={email} onChange={setEmail} type="email" placeholder="you@example.com" />
      <Field label="Phone Number" value={phone} onChange={setPhone} placeholder="Add phone number" />
      <ModalActions
        primaryLabel="Save Changes"
        onPrimary={() => {
          setProfile({ name: name.trim(), email: email.trim(), phone: phone.trim() })
          closeModal()
        }}
      />
    </Modal>
  )
}
