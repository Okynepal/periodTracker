import { Locale } from '.'
interface CalendarTranslations {
  monthNames: string[]
  monthNamesShort: string[]
  dayNames: string[]
  dayNamesShort: string[]
}

export const calendarTranslations: Record<Locale, CalendarTranslations> = {
  en: {
    monthNames: [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
    monthNamesShort: [
      'Jan',
      'Feb',
      'Ma',
      'Ap',
      'Ma',
      'Ju',
      'Jul',
      'Au',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ],
    dayNames: [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ],
    dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'],
  },
  ne: {
    monthNames: [
      'जनवरी', 'फेब्रुअरी', 'मार्च', 'अप्रिल', 'मे', 'जुन',
      'जुलाई', 'अगस्त', 'सेप्टेम्बर', 'अक्टोबर', 'नोभेम्बर', 'डिसेम्बर'
    ],
    monthNamesShort: [
      'जन', 'फेब', 'मार्च', 'अप्र', 'मे', 'जुन',
      'जुल', 'अग', 'सेप', 'अक्ट', 'नोभ', 'डिस'
    ],
    dayNames: [
      'आइतबार', 'सोमबार', 'मङ्गलबार', 'बुधबार', 'बिहिबार', 'शुक्रबार', 'शनिबार'
    ],
    dayNamesShort: ['आइत', 'सोम', 'मङ्गल', 'बुध', 'बिहि', 'शुक्र', 'शनि']
  }
}

export const availableCalendarLocales = Object.keys(calendarTranslations)
