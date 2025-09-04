import { AppAssets } from '../../core/types'

export const assets: AppAssets = {
  avatars: {
    nima: {
      default: require('./images/static/Nima.png'),
      stationary_colour: require('./images/static/Nima.png'),
      bubbles: require('./images/static/Nima.png'),
      theme: require('./images/static/Nima.png'),
    },
    suman: {
      default: require('./images/static/Suman.png'),
      stationary_colour: require('./images/static/Suman.png'),
      bubbles: require('./images/static/Suman.png'),
      theme: require('./images/static/Suman.png'),
    },
    kumari: {
      default: require('./images/static/Kumari.png'),
      stationary_colour: require('./images/static/Kumari.png'),
      bubbles: require('./images/static/Kumari.png'),
      theme: require('./images/static/Kumari.png'),
    },
    sanam: {
      default: require('./images/static/Sanam.png'),
      stationary_colour: require('./images/static/Sanam.png'),
      bubbles: require('./images/static/Sanam.png'),
      theme: require('./images/static/Sanam.png'),
    },
  },
  backgrounds: {
    city: {
      onPeriod: require('./images/backgrounds/city-p.png'),
      default: require('./images/backgrounds/city-default.png'),
      icon: require('./images/static/themes/icn_theme_city.png'),
    },
    hills: {
      onPeriod: require('./images/backgrounds/hills-p.png'),
      default: require('./images/backgrounds/hills-default.png'),
      icon: require('./images/static/themes/icn_theme_hills.png'),
    },
    stupa: {
      onPeriod: require('./images/backgrounds/stupa-p.png'),
      default: require('./images/backgrounds/stupa-default.png'),
      icon: require('./images/static/themes/icn_theme_stupa.png'),
    },
    village: {
      onPeriod: require('./images/backgrounds/village-p.png'),
      default: require('./images/backgrounds/village-default.png'),
      icon: require('./images/static/themes/icn_theme_village.png'),
    },
  },
  static: {
    launch_icon: require('./images/static/circle.png'),
    spin_load_face: require('./images/static/circle.png'),
    spin_load_circle: require('./images/static/icn_oky_spin-2.png'),
  },
  general: {
    aboutBanner: {
      en: require('./images/general/about-banner.jpg'),
    },
  },
  lottie: {
    avatars: {
      nima: require('./lottie/Nima.json'),
      suman: require('./lottie/Suman.json'),
      kumari: require('./lottie/Kumari.json'),
      sanam: require('./lottie/Haku_Patashi.json'),
    },
  },
}
