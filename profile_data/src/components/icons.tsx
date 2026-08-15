import type { SVGProps } from 'react'

type IconProps = SVGProps<SVGSVGElement>

const base = (props: IconProps) => ({
  width: 20,
  height: 20,
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  strokeWidth: 1.75,
  strokeLinecap: 'round' as const,
  strokeLinejoin: 'round' as const,
  ...props,
})

export const IconPin = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M12 21s-6.5-5.4-6.5-10A6.5 6.5 0 0 1 12 4.5 6.5 6.5 0 0 1 18.5 11c0 4.6-6.5 10-6.5 10Z" />
    <circle cx="12" cy="11" r="2.3" />
  </svg>
)

export const IconAge = (p: IconProps) => (
  <svg {...base(p)}>
    <circle cx="12" cy="12" r="8.2" />
    <path d="M12 7.5V12l3 1.8" />
  </svg>
)

export const IconHeight = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M12 3v18" />
    <path d="M8.5 5.5 12 3l3.5 2.5M8.5 18.5 12 21l3.5-2.5" />
    <path d="M12 8.5h2.5M12 12h3.2M12 15.5h2.5" />
  </svg>
)

export const IconWeight = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M6.5 8.5h11l2 11.5H4.5l2-11.5Z" />
    <circle cx="12" cy="6" r="2.2" />
  </svg>
)

export const IconRings = (p: IconProps) => (
  <svg {...base(p)}>
    <circle cx="9" cy="14" r="4.2" />
    <circle cx="15" cy="14" r="4.2" />
    <path d="M9 5.5 10.5 8h-3L9 5.5ZM15 5.5 16.5 8h-3L15 5.5Z" />
  </svg>
)

export const IconDroplet = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M12 3.5c3 3.6 5 6.2 5 8.9a5 5 0 0 1-10 0c0-2.7 2-5.3 5-8.9Z" />
  </svg>
)

export const IconBriefcase = (p: IconProps) => (
  <svg {...base(p)}>
    <rect x="3.5" y="7.5" width="17" height="12" rx="2.2" />
    <path d="M9 7.5V6a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v1.5M3.5 12.5h17" />
  </svg>
)

export const IconCap = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M12 4 22 9l-10 5L2 9l10-5Z" />
    <path d="M6 11v4.5c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5V11" />
  </svg>
)

export const IconUsers = (p: IconProps) => (
  <svg {...base(p)}>
    <circle cx="9" cy="9" r="3" />
    <path d="M3.5 19c0-3 2.5-5 5.5-5s5.5 2 5.5 5" />
    <path d="M16 6.3a3 3 0 0 1 0 5.4M17 14c2.5.3 4 2.3 4 5" />
  </svg>
)

export const IconBaby = (p: IconProps) => (
  <svg {...base(p)}>
    <circle cx="12" cy="8" r="4" />
    <path d="M9.5 8h.01M14.5 8h.01M10.5 10.5a2.2 2.2 0 0 0 3 0" />
    <path d="M5 20c1.3-2.7 4-4.5 7-4.5s5.7 1.8 7 4.5" />
  </svg>
)

export const IconShieldHeart = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M12 3.5 19 6v6c0 4.3-3 7-7 8.5C8 19 5 16.3 5 12V6l7-2.5Z" />
    <path d="M12 14.5c-1.7-1.1-3-2.1-3-3.4a1.6 1.6 0 0 1 3-.7 1.6 1.6 0 0 1 3 .7c0 1.3-1.3 2.3-3 3.4Z" />
  </svg>
)

export const IconSparkles = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M12 4.5c.6 2.9 1.6 3.9 4.5 4.5-2.9.6-3.9 1.6-4.5 4.5-.6-2.9-1.6-3.9-4.5-4.5 2.9-.6 3.9-1.6 4.5-4.5Z" />
    <path d="M18 14.5c.3 1.4.8 1.9 2.2 2.2-1.4.3-1.9.8-2.2 2.2-.3-1.4-.8-1.9-2.2-2.2 1.4-.3 1.9-.8 2.2-2.2Z" />
  </svg>
)

export const IconCoins = (p: IconProps) => (
  <svg {...base(p)}>
    <ellipse cx="9" cy="7" rx="5" ry="2.6" />
    <path d="M4 7v4c0 1.4 2.2 2.6 5 2.6s5-1.2 5-2.6V7" />
    <path d="M10 15c.7 1.1 2.6 1.9 5 1.9s4.3-.8 5-1.9V11c0-1.4-2.2-2.6-5-2.6" />
  </svg>
)

export const IconSmoking = (p: IconProps) => (
  <svg {...base(p)}>
    <rect x="3" y="13.5" width="13" height="4" rx="1" />
    <path d="M18.5 13.5v4M21 13.5v4M13 4c2 .7 2 2.3 2 3.5M17 6c2 .7 2 2.3 2 3.5" />
  </svg>
)

export const IconMoon = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M20 14.5A7.5 7.5 0 0 1 9.5 4a7.5 7.5 0 1 0 10.5 10.5Z" />
  </svg>
)

export const IconStar = (p: IconProps) => (
  <svg {...base({ fill: 'currentColor', stroke: 'none', ...p })}>
    <path d="M12 3.5 14 8.6l5.5.4-4.2 3.6 1.3 5.4L12 15.6 7.4 18l1.3-5.4L4.5 9l5.5-.4L12 3.5Z" />
  </svg>
)

export const IconChevronRight = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M15 6l-6 6 6 6" />
  </svg>
)

export const IconHome = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M4 11 12 4l8 7" />
    <path d="M6 10v9h12v-9" />
  </svg>
)

export const IconBell = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M6.5 10a5.5 5.5 0 0 1 11 0c0 4 1.5 5.5 1.5 5.5H5S6.5 14 6.5 10Z" />
    <path d="M10 18.5a2 2 0 0 0 4 0" />
  </svg>
)

export const IconMessage = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v7a2.5 2.5 0 0 1-2.5 2.5H9l-4 3.5v-3.5H6.5A2.5 2.5 0 0 1 4 13.5Z" />
  </svg>
)

export const IconPackage = (p: IconProps) => (
  <svg {...base(p)}>
    <path d="M12 3.5 20 7v10l-8 3.5L4 17V7l8-3.5Z" />
    <path d="M4 7l8 3.5M20 7l-8 3.5M12 20.5V10.5" />
  </svg>
)

export const IconGrid = (p: IconProps) => (
  <svg {...base(p)}>
    <rect x="4" y="4" width="6.5" height="6.5" rx="1.5" />
    <rect x="13.5" y="4" width="6.5" height="6.5" rx="1.5" />
    <rect x="4" y="13.5" width="6.5" height="6.5" rx="1.5" />
    <rect x="13.5" y="13.5" width="6.5" height="6.5" rx="1.5" />
  </svg>
)
