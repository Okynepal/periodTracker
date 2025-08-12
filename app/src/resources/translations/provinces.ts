
    import { Locale } from '.'

    type Province = {
      code: string
      uid: number
    } & {
      [K in Locale]: string
    }
    
    export const provinces: Province[] =  [{"code":"NP","uid":3111,"en":"Bagmati","fr":"Bagmati","ru":"Bagmati","pt":"Bagmati","es":"Bagmati"},{"code":"NP","uid":3115,"en":"Karnali","fr":"Karnali","ru":"Karnali","pt":"Karnali","es":"Karnali"},{"code":"NP","uid":3116,"en":"Gandaki","fr":"Gandaki","ru":"Gandaki","pt":"Gandaki","es":"Gandaki"},{"code":"NP","uid":3117,"en":"Koshi","fr":"Koshi","ru":"Koshi","pt":"Koshi","es":"Koshi"},{"code":"NP","uid":3118,"en":"Madesh","fr":"Madesh","ru":"Madesh","pt":"Madesh","es":"Madesh"},{"code":"NP","uid":3119,"en":"Lumbini","fr":"Lumbini","ru":"Lumbini","pt":"Lumbini","es":"Lumbini"},{"code":"NP","uid":3121,"en":"Sudurpaschim","fr":"Sudurpaschim","ru":"Sudurpaschim","pt":"Sudurpaschim","es":"Sudurpaschim"},{}]
    