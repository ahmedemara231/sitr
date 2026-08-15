import type { Profile } from '../data/profiles'
import { Avatar, MetadataItem, PremiumBadge } from './ui'
import { IconAge, IconHeight, IconWeight, IconRings, IconPin } from './icons'

export default function ProfileCard({
  profile,
  onOpen,
}: {
  profile: Profile
  onOpen: (id: string) => void
}) {
  return (
    <button
      type="button"
      onClick={() => onOpen(profile.id)}
      className="group w-full rounded-[12px] bg-surface px-3.5 pt-3.5 pb-3 text-right transition-shadow duration-200"
      style={{
        background: 'var(--color-surface)',
        boxShadow: '0 1px 2px rgba(39,39,39,0.04), 0 6px 16px rgba(39,39,39,0.035)',
      }}
    >
      {/* Top section: image anchored right, identity fills the rest */}
      <div className="flex items-start gap-3">
        <Avatar name={profile.name} size={72} />
        <div className="min-w-0 flex-1 pt-0.5">
          <div className="flex items-center justify-between gap-2">
            <h3 className="truncate" style={{ fontSize: 18, fontWeight: 700, color: 'var(--color-ink)' }}>
              {profile.name}
            </h3>
            {profile.premium ? <PremiumBadge compact /> : null}
          </div>
          <div className="mt-1 flex items-center gap-1.5" style={{ color: 'var(--color-meta)' }}>
            <IconPin width={14} height={14} />
            <span className="truncate" style={{ fontSize: 12.5, fontWeight: 500 }}>
              {profile.city ?? '—'}
            </span>
          </div>
        </div>
      </div>

      {/* Metadata section */}
      <div className="mt-3 border-t pt-3" style={{ borderColor: 'var(--color-hair)' }}>
        <div className="grid grid-cols-3 gap-2">
          <MetadataItem icon={<IconAge width={15} height={15} />} value={profile.age} suffix="سنة" />
          <MetadataItem icon={<IconHeight width={15} height={15} />} value={profile.height} suffix="سم" />
          <MetadataItem icon={<IconWeight width={15} height={15} />} value={profile.weight} suffix="كجم" />
        </div>
        <div className="mt-2">
          <MetadataItem icon={<IconRings width={15} height={15} />} value={profile.marital} />
        </div>
      </div>
    </button>
  )
}
