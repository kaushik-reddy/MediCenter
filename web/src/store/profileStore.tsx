import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react'

export interface Profile {
  name: string
  email: string
  phone: string
  /** Avatar image as a (resized) data URL, or null when unset. */
  avatar: string | null
}

const STORAGE_KEY = 'medicenter.profile'
const EMPTY: Profile = { name: '', email: '', phone: '', avatar: null }

interface ProfileStoreValue {
  profile: Profile
  setProfile: (patch: Partial<Profile>) => void
  setAvatar: (dataUrl: string | null) => void
}

const ProfileStore = createContext<ProfileStoreValue | undefined>(undefined)

function load(): Profile {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? { ...EMPTY, ...(JSON.parse(raw) as Partial<Profile>) } : EMPTY
  } catch {
    return EMPTY
  }
}

export function ProfileProvider({ children }: { children: ReactNode }) {
  const [profile, setProfileState] = useState<Profile>(load)

  useEffect(() => {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(profile))
    } catch {
      /* ignore quota / private-mode errors */
    }
  }, [profile])

  const setProfile = useCallback((patch: Partial<Profile>) => {
    setProfileState((prev) => ({ ...prev, ...patch }))
  }, [])

  const setAvatar = useCallback((dataUrl: string | null) => {
    setProfileState((prev) => ({ ...prev, avatar: dataUrl }))
  }, [])

  const value = useMemo<ProfileStoreValue>(
    () => ({ profile, setProfile, setAvatar }),
    [profile, setProfile, setAvatar],
  )

  return <ProfileStore.Provider value={value}>{children}</ProfileStore.Provider>
}

export function useProfile() {
  const ctx = useContext(ProfileStore)
  if (!ctx) throw new Error('useProfile must be used within ProfileProvider')
  return ctx
}
