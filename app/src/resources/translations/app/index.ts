import { AppTranslations } from '../../../types'
import { Locale } from '../'

import { en } from './en'
import { ne } from './ne'

export const appTranslations: Record<Locale, AppTranslations> = {
  en,
  ne,
}

export const availableAppLocales = Object.keys(appTranslations) as Locale[]
