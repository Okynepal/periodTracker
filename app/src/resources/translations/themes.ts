import { Locale } from '.'
import Cloud from '../../components/icons/Cloud'
import { CloudOutline } from '../../components/icons/CloudOutline'
import { Star } from '../../components/icons/Star'
import { StarOutline } from '../../components/icons/StarOutline'
import { CircleOutline } from '../../components/icons/CircleOutline'
import { Circle } from '../../components/icons/Circle'
import { Appearance } from '../../components/IconButton'
import { SvgIconProps } from '../../components/icons/types'

export type ThemeName = 'city' | 'hills' | 'stupa' | 'village'

export type AvatarName = 'nima' | 'suman' | 'kumari' | 'sanam'

export const defaultAvatar: AvatarName = 'nima'
export const avatarNames: AvatarName[] = ['nima', 'suman', 'kumari', 'sanam']

export const defaultTheme: ThemeName = 'hills'
export const themeNames: ThemeName[] = ['city', 'hills', 'stupa', 'village']

export const themeTranslations: Record<Locale, Record<AvatarName | ThemeName, string>> = {
  en: {
    nima: 'Nima',
    suman: 'Suman',
    kumari: 'Kumari',
    sanam: 'Sanam',
    city: 'City',
    hills: 'Hills',
    stupa: 'Stupa',
    village: 'Village',
  },
  ne: {
    nima: 'निमा',
    suman: 'सुमन',
    kumari: 'कुमारी',
    sanam: 'सनम',
    city: 'शहर',
    hills: 'पहाडहरू',
    stupa: 'स्तूप',
    village: 'गाउँ',
  },
}

export const IconForTheme: Record<ThemeName, Record<Appearance, React.FC<SvgIconProps>>> = {
  city: {
    fill: Star,
    outline: StarOutline,
  },
  hills: {
    fill: Cloud,
    outline: CloudOutline,
  },
  stupa: {
    fill: Circle,
    outline: CircleOutline,
  },
  village: {
    fill: Cloud,
    outline: CloudOutline,
  },
}

/* 
  Instead of having Icon buttons (eg clouds) the main screen wheel can be a continuous ring,
  Themes included in this list will use this ring style
*/
export const wheelRingThemes: ThemeName[] = []
