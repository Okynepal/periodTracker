import { StaticContent } from '../../../types'
import { Locale } from '../'
import { en } from './en'
import { ne } from './ne'

export const content: Record<Locale, StaticContent> = {
  en,
  ne,
}

export const availableContentLocales = Object.keys(content)
