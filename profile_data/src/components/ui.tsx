import type { ReactNode } from 'react'
import { IconStar } from './icons'

/** Elegant monogram avatar — calm, premium, no random stock faces. */
export function Avatar({ name, size = 76 }: { name: string; size?: number }) {
  const letter = name.trim().charAt(0)
  return (
    <div
      className="grid shrink-0 place-items-center overflow-hidden text-brand"
      style={{
        width: size,
        height: size,
        borderRadius: Math.round(size * 0.16),
        background: 'linear-gradient(150deg, #faf3e4 0%, #f3e7ce 100%)',
        boxShadow: 'inset 0 0 0 1px rgba(166,109,9,0.10)',
      }}
    >
      <span style={{ fontSize: size * 0.4, fontWeight: 700, lineHeight: 1 }}>{letter}</span>
    </div>
  )
}

export function PremiumBadge({ compact = false }: { compact?: boolean }) {
  return (
    <span
      className="inline-flex items-center gap-1 rounded-full text-brand"
      style={{
        background: 'var(--color-brand-soft)',
        padding: compact ? '2px 8px 2px 6px' : '3px 10px 3px 8px',
        fontSize: compact ? 10 : 11,
        fontWeight: 700,
        boxShadow: 'inset 0 0 0 1px rgba(166,109,9,0.18)',
      }}
    >
      <IconStar width={compact ? 10 : 12} height={compact ? 10 : 12} />
      عضو مميز
    </span>
  )
}

/** Small circular tinted icon container — consistent size and weight everywhere. */
export function CircleIcon({
  children,
  size = 34,
  tone = 'brand',
}: {
  children: ReactNode
  size?: number
  tone?: 'brand' | 'muted'
}) {
  const isBrand = tone === 'brand'
  return (
    <div
      className="grid shrink-0 place-items-center"
      style={{
        width: size,
        height: size,
        borderRadius: '50%',
        background: isBrand ? 'var(--color-brand-soft)' : 'var(--color-inactive)',
        color: isBrand ? 'var(--color-brand)' : 'var(--color-meta)',
      }}
    >
      {children}
    </div>
  )
}

/** Compact metadata item for the profile card. */
export function MetadataItem({
  icon,
  value,
  suffix,
}: {
  icon: ReactNode
  value: string | number | null
  suffix?: string
}) {
  const hasValue = value !== null && value !== undefined && value !== ''
  return (
    <div className="flex min-w-0 items-center gap-1.5">
      <span className="text-meta/70 shrink-0" style={{ color: 'rgba(82,82,82,0.7)' }}>
        {icon}
      </span>
      {hasValue ? (
        <span className="truncate" style={{ fontSize: 12.5, fontWeight: 500, color: 'var(--color-body)' }}>
          {value}
          {suffix ? <span style={{ color: 'var(--color-meta)', fontWeight: 400 }}> {suffix}</span> : null}
        </span>
      ) : (
        <span style={{ fontSize: 12.5, color: 'rgba(82,82,82,0.55)' }}>—</span>
      )}
    </div>
  )
}
