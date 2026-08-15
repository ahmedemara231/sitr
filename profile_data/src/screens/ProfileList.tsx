import { profiles } from '../data/profiles'
import ProfileCard from '../components/ProfileCard'

export default function ProfileList({ onOpen }: { onOpen: (id: string) => void }) {
  return (
    <>
      <header
        className="px-4 pt-3 pb-4"
        style={{ background: 'var(--color-header)' }}
      >
        <div className="flex items-center justify-between">
          <h1 style={{ fontSize: 18, fontWeight: 700, color: 'var(--color-ink)' }}>نتائج البحث</h1>
          <span style={{ fontSize: 12.5, color: 'var(--color-meta)' }}>{profiles.length} نتيجة</span>
        </div>
      </header>

      <div className="scroll-area flex-1 overflow-y-auto px-4 py-4">
        <div className="flex flex-col gap-3">
          {profiles.map((p) => (
            <ProfileCard key={p.id} profile={p} onOpen={onOpen} />
          ))}
        </div>
      </div>
    </>
  )
}
