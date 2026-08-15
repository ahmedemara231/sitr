import type { ReactNode } from 'react'
import { CircleIcon } from './ui'

export function DetailSection({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section>
      <h4 className="mb-2 px-1" style={{ fontSize: 13, fontWeight: 700, color: 'var(--color-meta)' }}>
        {title}
      </h4>
      <div
        className="rounded-[12px] bg-surface p-1"
        style={{
          background: 'var(--color-surface)',
          boxShadow: '0 1px 2px rgba(39,39,39,0.04), 0 6px 16px rgba(39,39,39,0.03)',
        }}
      >
        {children}
      </div>
    </section>
  )
}

export function DetailRow({
  icon,
  label,
  value,
  divider = true,
}: {
  icon: ReactNode
  label: string
  value: string | number | null
  divider?: boolean
}) {
  const hasValue = value !== null && value !== undefined && value !== ''
  return (
    <div
      className="flex items-center gap-3 px-2.5 py-3"
      style={divider ? { boxShadow: '0 1px 0 var(--color-hair)' } : undefined}
    >
      <CircleIcon size={34}>{icon}</CircleIcon>
      <div className="flex min-w-0 flex-1 items-center justify-between gap-3">
        <span style={{ fontSize: 12.5, color: 'var(--color-meta)' }}>{label}</span>
        <span
          className="truncate text-left"
          style={{ fontSize: 14.5, fontWeight: 700, color: hasValue ? 'var(--color-ink)' : 'rgba(82,82,82,0.55)' }}
        >
          {hasValue ? value : '—'}
        </span>
      </div>
    </div>
  )
}

/** Two-column compact pair for short related values. */
export function DetailPair({
  items,
}: {
  items: { icon: ReactNode; label: string; value: string | number | null }[]
}) {
  return (
    <div className="grid grid-cols-2" style={{ boxShadow: '0 1px 0 var(--color-hair)' }}>
      {items.map((it, i) => {
        const hasValue = it.value !== null && it.value !== undefined && it.value !== ''
        return (
          <div
            key={it.label}
            className="flex items-center gap-2.5 px-2.5 py-3"
            style={i === 0 ? { boxShadow: '-1px 0 0 var(--color-hair)' } : undefined}
          >
            <CircleIcon size={32}>{it.icon}</CircleIcon>
            <div className="min-w-0">
              <div style={{ fontSize: 11.5, color: 'var(--color-meta)' }}>{it.label}</div>
              <div
                className="truncate"
                style={{ fontSize: 14, fontWeight: 700, color: hasValue ? 'var(--color-ink)' : 'rgba(82,82,82,0.55)' }}
              >
                {hasValue ? it.value : '—'}
              </div>
            </div>
          </div>
        )
      })}
    </div>
  )
}
