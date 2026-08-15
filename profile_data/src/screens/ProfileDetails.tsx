import type { Profile } from '../data/profiles'
import { Avatar, PremiumBadge } from '../components/ui'
import { DetailSection, DetailRow, DetailPair } from '../components/DetailSection'
import {
  IconChevronRight,
  IconPin,
  IconAge,
  IconRings,
  IconHeight,
  IconWeight,
  IconDroplet,
  IconBriefcase,
  IconCap,
  IconUsers,
  IconBaby,
  IconShieldHeart,
  IconSparkles,
  IconCoins,
  IconSmoking,
  IconMoon,
} from '../components/icons'

export default function ProfileDetails({
  profile,
  onBack,
}: {
  profile: Profile
  onBack: () => void
}) {
  return (
    <div className="scroll-area flex-1 overflow-y-auto">
      {/* Identity header */}
      <header
        className="rounded-b-[15px] px-4 pt-3 pb-5"
        style={{ background: 'var(--color-header)' }}
      >
        <div className="flex items-center justify-between">
          <button
            type="button"
            onClick={onBack}
            className="grid h-9 w-9 place-items-center rounded-full"
            style={{ background: 'var(--color-surface)', color: 'var(--color-ink)' }}
            aria-label="رجوع"
          >
            <IconChevronRight width={20} height={20} className="-scale-x-100" />
          </button>
          <h1 style={{ fontSize: 18, fontWeight: 700, color: 'var(--color-ink)' }}>الملف الشخصي</h1>
        </div>

        <div className="mt-4 flex items-center gap-3.5">
          <Avatar name={profile.name} size={80} />
          <div className="min-w-0 flex-1">
            <div className="flex items-center gap-2">
              <h2 className="truncate" style={{ fontSize: 20, fontWeight: 700, color: 'var(--color-ink)' }}>
                {profile.name}
              </h2>
              {profile.premium ? <PremiumBadge compact /> : null}
            </div>
            <div className="mt-1.5 flex flex-wrap items-center gap-x-3 gap-y-1" style={{ color: 'var(--color-meta)' }}>
              <span className="inline-flex items-center gap-1" style={{ fontSize: 12.5, fontWeight: 500 }}>
                <IconAge width={14} height={14} />
                {profile.age ? `${profile.age} سنة` : '—'}
              </span>
              <span className="inline-flex items-center gap-1" style={{ fontSize: 12.5, fontWeight: 500 }}>
                <IconPin width={14} height={14} />
                {profile.city ?? '—'}
              </span>
              <span className="inline-flex items-center gap-1" style={{ fontSize: 12.5, fontWeight: 500 }}>
                <IconRings width={14} height={14} />
                {profile.marital ?? '—'}
              </span>
            </div>
          </div>
        </div>
      </header>

      {/* Sections */}
      <div className="flex flex-col gap-5 px-4 py-5">
        <DetailSection title="المعلومات الأساسية">
          <DetailPair
            items={[
              { icon: <IconAge width={17} height={17} />, label: 'العمر', value: profile.age ? `${profile.age} سنة` : null },
              { icon: <IconHeight width={17} height={17} />, label: 'الطول', value: profile.height ? `${profile.height} سم` : null },
            ]}
          />
          <DetailPair
            items={[
              { icon: <IconWeight width={17} height={17} />, label: 'الوزن', value: profile.weight ? `${profile.weight} كجم` : null },
              { icon: <IconDroplet width={17} height={17} />, label: 'اللون', value: profile.color },
            ]}
          />
          <DetailRow icon={<IconPin width={17} height={17} />} label="المدينة" value={profile.city} divider={false} />
        </DetailSection>

        <DetailSection title="الحالة الاجتماعية والعائلية">
          <DetailRow icon={<IconRings width={17} height={17} />} label="الحالة الاجتماعية" value={profile.marital} />
          <DetailPair
            items={[
              { icon: <IconBaby width={17} height={17} />, label: 'يوجد أطفال', value: profile.children },
              { icon: <IconUsers width={17} height={17} />, label: 'عدد الأبناء', value: profile.childrenCount },
            ]}
          />
          <DetailRow icon={<IconShieldHeart width={17} height={17} />} label="حضانة الأطفال" value={profile.custody} divider={false} />
        </DetailSection>

        <DetailSection title="التعليم والعمل">
          <DetailRow icon={<IconCap width={17} height={17} />} label="المؤهل الدراسي" value={profile.education} />
          <DetailRow icon={<IconBriefcase width={17} height={17} />} label="الوظيفة الحالية" value={profile.job} divider={false} />
        </DetailSection>

        <DetailSection title="تفضيلات الزواج">
          <DetailRow icon={<IconBaby width={17} height={17} />} label="الرغبة بالإنجاب" value={profile.wantsChildren} />
          <DetailRow icon={<IconSparkles width={17} height={17} />} label="نوع حفلة الزواج" value={profile.weddingType} />
          <DetailRow icon={<IconCoins width={17} height={17} />} label="المهر" value={profile.dowry} divider={false} />
        </DetailSection>

        <DetailSection title="معلومات إضافية">
          <DetailPair
            items={[
              { icon: <IconSmoking width={17} height={17} />, label: 'التدخين', value: profile.smoking },
              { icon: <IconMoon width={17} height={17} />, label: 'يصلي', value: profile.prays },
            ]}
          />
        </DetailSection>
      </div>
    </div>
  )
}
