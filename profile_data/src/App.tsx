import { useState } from 'react'
import { profiles } from './data/profiles'
import ProfileList from './screens/ProfileList'
import ProfileDetails from './screens/ProfileDetails'
import BottomNav from './components/BottomNav'

export default function App() {
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const selected = profiles.find((p) => p.id === selectedId) ?? null

  return (
    <div
      dir="rtl"
      lang="ar"
      className="grid min-h-full place-items-center p-4 sm:p-8"
    >
      {/* 375 × 812 reference mobile frame */}
      <div
        className="relative flex w-full max-w-[375px] flex-col overflow-hidden rounded-[36px]"
        style={{
          height: 'min(812px, calc(100vh - 32px))',
          background: 'var(--color-canvas)',
          boxShadow: '0 30px 70px rgba(39,39,39,0.22), 0 0 0 1px rgba(39,39,39,0.04)',
        }}
      >
        {selected ? (
          <ProfileDetails profile={selected} onBack={() => setSelectedId(null)} />
        ) : (
          <ProfileList onOpen={setSelectedId} />
        )}

        <BottomNav active="home" />
      </div>
    </div>
  )
}
