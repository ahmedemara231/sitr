import { IconHome, IconBell, IconMessage, IconPackage, IconGrid } from './icons'

const items = [
  { id: 'home', label: 'الرئيسية', Icon: IconHome },
  { id: 'alerts', label: 'الاشعارات', Icon: IconBell },
  { id: 'messages', label: 'الرسائل', Icon: IconMessage },
  { id: 'packages', label: 'الباقات', Icon: IconPackage },
  { id: 'more', label: 'المزيد', Icon: IconGrid },
]

export default function BottomNav({ active = 'home' }: { active?: string }) {
  return (
    <nav
      className="relative flex items-stretch justify-between bg-surface px-2 pt-2 pb-5"
      style={{
        background: 'var(--color-surface)',
        boxShadow: '0 -1px 0 var(--color-hair), 0 -8px 20px rgba(39,39,39,0.04)',
      }}
    >
      {items.map(({ id, label, Icon }) => {
        const isActive = id === active
        return (
          <button
            key={id}
            type="button"
            className="relative flex flex-1 flex-col items-center gap-1 py-1"
            style={{ color: isActive ? 'var(--color-brand)' : 'var(--color-meta)' }}
          >
            {isActive ? (
              <span
                className="absolute -top-2 h-1 w-6 rounded-full"
                style={{ background: 'var(--color-brand)' }}
              />
            ) : null}
            <Icon width={22} height={22} strokeWidth={isActive ? 2 : 1.75} />
            <span style={{ fontSize: 10.5, fontWeight: isActive ? 700 : 500 }}>{label}</span>
          </button>
        )
      })}
    </nav>
  )
}
