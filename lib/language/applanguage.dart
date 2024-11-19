/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import '/main.dart';

const localizedValues = <String, Map<String, Map<String, String>>>{
  'en': {
    'month': {
      'January': "January",
      'February': "February",
      'March': "March",
      'April': "April",
      'May': "May",
      'June': "June",
      'July': "July",
      'August': "August",
      'September': "September",
      'October': "October",
      'November': "November",
      'December': "December",
    },
    'day': {
      'Monday': "Monday",
      'Tuesday': 'Tuesday',
      'Wednesday': 'Wednesday',
      'Thursday': 'Thursday',
      'Friday': 'Friday',
      'Saturday': 'Saturday',
      'Sunday': 'Sunday',
    },
    'home': {
      'bar1': 'notes',
      'bar2': 'daily',
      'bar3': 'monthly',
      'bar4': 'yearly',
      'charts': "Charts",
      'help': "Need Help?",
      'Settings': "Settings",
      'income': "Income (Credit)",
      'expense': "Expense (Debit)",
      'total-income': "Total Income (Credit)",
      'total-expense': "Total Expense (Debit)",
      'balance': "Balance",
      'no-notes': "No Notes Found.",
    },
    'settings': {
      'title': 'Settings',
      'language': "Language",
      'currency': 'Currency',
      'carry-forward': 'Carry Forward',
      'carry-forward-subtitle':
          "Carry Forward balance from one month to another.\nFor example, today's income - 1000, expense - 400, balance 600 is taken forward as tomorrow's opening balance..",
      'date': "Date Format",
      'account': "Profile and Accounts",
      'google-drive-settings': "Google Drive Setting",
      'google-account': "Google Account",
      'backup': 'Back Up',
      'Last-Backup': "Last Backup",
      'Last-Backup-subtitle':
          'Back up your data to Google Drive. You can restore them when you reindstall the app and signin with Google Account.\nWe Strongly recommend that you take backup regularly from the app (as backup to Google drive is not automatic). Doing so would keep your data safe even if your device is lost/damaged',
      'save-excel': "Save as Excel",
      'category': "Custom and Defalut Categories",
      'category-subtitle':
          "Edit / Delete  / Hide category, watch a video to add your own category",
      'theme-title': "Theme",
      'theme-subtitle-orginal': "Orginal",
      'app-lock': "App Lock",
      'app-lock-subtitle':
          'Helps you protect your data from being viewed by others accidentally. Fingerprint must be registered in device.',
      'app-version': 'App Version',
      'app-version-subtitle':
          'Click here to check update from playstore if any',
      'logout': 'Logout',
      'premium': 'Go Premium',
    },
    'pdf': {
      'report': 'Report',
      'alltime': 'All Time',
      'custom-date': 'Custom Date Range',
      'all': 'All',
      'income': "Income (Credit)",
      'expense': "Expense (Debit)",
      'note': "Notes",
    },
    'save-excel': {
      'title': "Save as Excel",
      "export": "Export Data",
      "all": "All Time",
      "Year": "Yearly",
      "month": "Monthly",
      "custom": "Custom Date Range",
      "download": "Download",
    },
    'category': {
      "title": "Custom and Default Categories",
      'income': "Income (Credit)",
      'expense': "Expense (Debit)",
      "income-bonus": "Bonus",
      "income-interest": "interest income",
      "income-investment": "Inverstment",
      "income-reimubursement": "Reimbursement",
      "income-rental": "Rental income",
      "income-returned": "Returned Purchase",
      "income-salary": "Salary",
      "expense-atm": "ATM",
      "expense-ait": "Air tickets",
      "expense-auto": "Auto And Transport",
      "expense-beauty": "Beauty",
      "expense-bike": "Bike",
      "expense-Bills": "Bills and Utilities",
      "expense-books": "Books",
      "expense-Bus": "Bus Fare",
      "expense-cc": "CC bill payment",
      "expense-cable": "Cable",
      "expense-cake": "Cake",
      "expense-car": "Car",
      "expense-car-loan": "Car loan",
      "expense-cigarette": "Cigarette",
      "expense-clothing": "Clothing",
      "expense-coffee": "Coffee",
      "expense-dining": "Dining",
      "expense-drinks": "Drinks",
      "expense-emi": "EMI",
      "expense-education": "Education",
      "expense-education-loan": "Education Loan",
      "expense-electricity": "Electricity",
      "expense-electronics": "Electronics",
      "expense-entertainment": "Entertainment",
      "expense-festivals": "Festivals",
      "expense-finance": "Finance",
      "expense-fitness": "Fitness",
      "expense-flowers": "Flowers",
      "expense-food": "Food and Dining",
      "expense-fruits": "Fruits",
      "expense-games": "Games",
      "expense-gas": "Gas",
      "expense-gifts": "Gifts and Donations",
      "expense-groceries": "Groceries",
      "expense-health": "Health",
      "expense-home": "Home Loan",
      "expense-hotel": "Hotel",
      "expense-household": "Household",
      "expense-ice": "Ice Cream",
      "expense-internet": "Internet",
      "expense-kids": "kids",
      "expense-laundry": "Laundry",
      "expense-maid": "Maid/Driver",
      "expense-maintenance": "Maintenance",
      "expense-medicines": "Medicines",
      "expense-milk": "Milk",
      "expense-misc": "Misc",
      "expense-mobile": "Mobile",
      "expense-personal": "Personal Care",
      "expense-personal-loan": "Personal Loan",
      "expense-pet": "Pet Care",
      "expense-Pizza": "Pizza",
      "expense-printing": "Printing and Scanning",
      "expense-rent": "Rent",
      "expense-salon": "Salon",
      "expense-savings": "Savings",
      "expense-shopping": "Shopping",
      "expense-stationery": "Stationery",
      "expense-taxes": "Taxes",
      "expense-Taxi": "Taxi",
      "expense-toll": "Toll",
      "expense-toys": "Toys",
      "expense-train": "Train",
      "expense-travel": "Vegetables",
      "expense-vacation": "Vacation",
      "expense-vegetables": "Vegetables",
      "expense-water": "Water",
      "expense-work": "Work",
    },
    "profile": {
      "title": "Profile and Accounts",
    },
  },
  'ta': {
    'month': {
      'January': "ஜனவரி",
      'February': "பிப்ரவரி",
      'March': "மார்ச்",
      'April': "ஏப்ரல்",
      'May': "மே",
      'June': "ஜூன்",
      'July': "ஜூலை",
      'August': "ஆகஸ்ட்",
      'September': "செப்டம்பர்",
      'October': "அக்டோபர்",
      'November': "நவம்பர்",
      'December': "டிசம்பர்",
    },
    'day': {
      'Monday': "திங்கட்கிழமை",
      'Tuesday': 'செவ்வாய்',
      'Wednesday': 'புதன்',
      'Thursday': 'வியாழன்',
      'Friday': 'வெள்ளி',
      'Saturday': 'சனிக்கிழமை',
      'Sunday': 'ஞாயிற்றுக்கிழமை',
    },
    'home': {
      'bar1': 'குறிப்புகள்',
      'bar2': 'தினசரி',
      'bar3': 'மாதாந்திர',
      'bar4': 'வருடாந்திர',
      'charts': "வரைபடங்கள்",
      'help': "உதவி வேண்டுமா?",
      'Settings': "அமைப்புகள்",
      'income': "வரவு",
      'expense': "செலவு",
      'total-income': "மொத்த வரவு",
      'total-expense': "மொத்த செலவு",
      'balance': "மீதி",
      'no-notes': "குறிப்புகள் எதுவும் கிடைக்கவில்லை",
    },
    'settings': {
      'title': 'அமைப்புகள்',
      'language': 'பயன்பாட்டு மொழி',
      'currency': 'செலாவணி',
      'carry-forward': 'Carry Forward',
      'carry-forward-subtitle':
          'ஒரு மாதத்திலிருந்து மற்றொரு மாதத்திற்கு முன்னோக்கி சமநிலையை எடுத்துச் செல்லுங்கள்.\nஉதாரணமாக, இன்றைய வருமானம் - 1000, செலவு - 400, இருப்பு 600, நாளைய தொடக்க இருப்புத் தொகையாக எடுத்துக் கொள்ளப்படுகிறது.',
      'date': "தேதி வடிவம்",
      'account': "சுயவிவரம் மற்றும் கணக்குகள்",
      'google-drive-settings': "Google இயக்கக அமைப்பு",
      'google-account': "Google கணக்கு",
      'backup': 'பேக்கப்',
      'Last-Backup': "கடைசி காப்புப்பிரதி",
      'Last-Backup-subtitle':
          "உங்கள் தரவை Google இயக்ககத்தில் காப்புப் பிரதி எடுக்கவும். நீங்கள் ஆப்ஸை மீண்டும் நிறுவி, Google கணக்கில் உள்நுழையும் போது, ​​அவற்றை மீட்டெடுக்கலாம்.\nஆப்ஸிலிருந்து (Google இயக்ககத்திற்கான காப்புப் பிரதி தானாக இல்லாததால்) தொடர்ந்து காப்புப் பிரதி எடுக்குமாறு நாங்கள் கடுமையாகப் பரிந்துரைக்கிறோம். அவ்வாறு செய்வது உங்கள் சாதனம் தொலைந்தாலும்/சேதமடைந்தாலும் உங்கள் தரவைப் பாதுகாப்பாக வைத்திருக்கும்",
      'save-excel': "Excel ஆக சேமிக்கவும்",
      'save-excel-subtitle': "தரவை எக்செல் ஷீட்டாக சேமிக்கவும்",
      'category': "விருப்ப மற்றும் Defalut வகைகள்",
      'category-subtitle':
          "வகையைத் திருத்த / நீக்கு / மறை, உங்கள் சொந்த வகையைச் சேர்க்க வீடியோவைப் பார்க்கவும்",
      'theme-title': "Theme",
      'theme-subtitle-orginal': "Orginal",
      'app-lock': "App Lock",
      'app-lock-subtitle':
          'உங்கள் தரவை மற்றவர்கள் தற்செயலாக பார்க்காமல் பாதுகாக்க உதவுகிறது. கைரேகை சாதனத்தில் பதிவு செய்யப்பட வேண்டும்.',
      'app-version': 'App Version',
      'app-version-subtitle':
          'பிளேஸ்டோரிலிருந்து புதுப்பிப்புகள் ஏதேனும் இருந்தால் சரிபார்க்க இங்கே கிளிக் செய்யவும்',
      'logout': 'வெளியேறுதல்',
      'premium': 'பிரீமியம் செல்லுங்கள்',
    },
    'pdf': {
      'report': 'அறிக்கை',
      'alltime': 'எல்லா நேரமும்',
      'custom-date': 'விரும்பிய தேதி தேர்ந்தெடுங்கள்',
      'all': 'அனைத்தும்',
      'income': "வரவு",
      'expense': "செலவு",
      'note': "குறிப்புகள்",
    },
    'save-excel': {
      'title': "Excel ஆக சேமிக்கவும்",
      "export": "தரவு ஏற்றுமதி",
      "all": "எல்லா நேரமும்",
      "Year": "ஆண்டுதோறும்",
      "month": "மாதாந்திர",
      "custom": "தனிப்பயன் தேதி வரம்பு",
      "download": "பதிவிறக்க",
    },
    'category': {
      "title": "தனிப்பயன் மற்றும் இயல்புநிலை வகைகள்",
      'income': "வரவு",
      'expense': "செலவு",
      "income-bonus": "போனஸ்",
      "income-interest": "வட்டி",
      "income-investment": "முதலீடு",
      "income-reimubursement": "கொடுக்கப்படுவதுடன்",
      "income-rental": "வாடகை வருமானம்",
      "income-returned": "திரும்பிய கொள்முதல்",
      "income-salary": "சம்பளம்",
      "expense-atm": "ஏடிஎம்",
      "expense-ait": "விமான டிக்கெட்டுகள்",
      "expense-auto": "ஆட்டோ மற்றும் போக்குவரத்து",
      "expense-beauty": "அழகு",
      "expense-bike": "பைக்",
      "expense-Bills": "பில்கள் மற்றும் பயன்பாடுகள்",
      "expense-books": "புத்தகங்கள்",
      "expense-Bus": "பேரூந்து கட்டணம்",
      "expense-cc": "CC பில் செலுத்துதல்",
      "expense-cable": "கேபிள்",
      "expense-cake": "கேக்",
      "expense-car": "கார்",
      "expense-car-loan": "கார் கடன்",
      "expense-cigarette": "சிகரெட்",
      "expense-clothing": "ஆடை",
      "expense-coffee": "காபி",
      "expense-dining": "சாப்பாடு",
      "expense-drinks": "பானங்கள்",
      "expense-emi": "EMI",
      "expense-education": "கல்வி",
      "expense-education-loan": "கல்வி கடன்",
      "expense-electricity": "மின்சாரம்",
      "expense-electronics": "மின்னணுவியல்",
      "expense-entertainment": "பொழுதுபோக்கு",
      "expense-festivals": "திருவிழாக்கள்",
      "expense-finance": "நிதி",
      "expense-fitness": "உடற்தகுதி",
      "expense-flowers": "மலர்கள்",
      "expense-food": "உணவு",
      "expense-fruits": "பழங்கள்",
      "expense-games": "விளையாட்டுகள்",
      "expense-gas": "வாயு",
      "expense-gifts": "பரிசுகள் மற்றும் நன்கொடைகள்",
      "expense-groceries": "மளிகை",
      "expense-health": "ஆரோக்கியம்",
      "expense-home": "வீட்டு கடன்",
      "expense-hotel": "ஹோட்டல்",
      "expense-household": "குடும்பம்",
      "expense-ice": "பனிக்கூழ்",
      "expense-internet": "இணையதளம்",
      "expense-kids": "குழந்தைகள்",
      "expense-laundry": "சலவை",
      "expense-maid": "பணிப்பெண்/ஓட்டுனர்",
      "expense-maintenance": "பராமரிப்பு",
      "expense-medicines": "மருந்துகள்",
      "expense-milk": "பால்",
      "expense-misc": "மற்றவை",
      "expense-mobile": "கைபேசி",
      "expense-personal": "தனிப்பட்ட பாதுகாப்பு",
      "expense-personal-loan": "தனிப்பட்ட கடன்",
      "expense-pet": "செல்லப்பிராணி பராமரிப்பு",
      "expense-Pizza": "பீஸ்ஸா",
      "expense-printing": "அச்சிடுதல் மற்றும் ஸ்கேன் செய்தல்",
      "expense-rent": "வாடகை",
      "expense-salon": "வரவேற்புரை",
      "expense-savings": "சேமிப்பு",
      "expense-shopping": "கடையில் பொருட்கள் வாங்குதல்",
      "expense-stationery": "காகிதம் முதலிய எழுது பொருள்கள்",
      "expense-taxes": "வரிகள்",
      "expense-Taxi": "டாக்ஸி",
      "expense-toll": "டோல்",
      "expense-toys": "பொம்மைகள்",
      "expense-train": "தொடர்வண்டி",
      "expense-travel": "காய்கறிகள்",
      "expense-vacation": "விடுமுறை",
      "expense-vegetables": "காய்கறிகள்",
      "expense-water": "தண்ணீர்",
      "expense-work": "வேலை",
    },
    "profile": {
      "title": "சுயவிவரம் மற்றும் கணக்குகள்",
    },
  },
  'hi': {
    'month': {
      'January': "जनवरी",
      'February': "फ़रवरी",
      'March': "मार्च",
      'April': "अप्रैल",
      'May': "मई",
      'June': "जून",
      'July': "जुलाई",
      'August': "अगस्त",
      'September': "सितम्बर",
      'October': "अक्टूबर",
      'November': "नवंबर",
      'December': "दिसंबर",
    },
    'day': {
      'Monday': "सोमवार",
      'Tuesday': 'मंगलवार',
      'Wednesday': 'बुधवार',
      'Thursday': 'गुरुवार',
      'Friday': 'शुक्रवार',
      'Saturday': 'शनिवार',
      'Sunday': 'रविवार',
    },
    'home': {
      'bar1': 'टिप्पणियाँ',
      'bar2': 'दैनिक',
      'bar3': 'महीने के',
      'bar4': 'वार्षिक',
      'charts': "चार्ट",
      'help': "मदद की ज़रूरत है?",
      'Settings': "सेटिंग्स",
      'income': "आय (क्रेडिट)",
      'expense': "व्यय (डेबिट)",
      'total-income': "कुल आय (क्रेडिट)",
      'total-expense': "कुल व्यय (डेबिट)",
      'balance': "संतुलन",
      'no-notes': "कोई नोट्स नहीं मिला.",
    },
    'settings': {
      'title': 'सेटिंग्स',
      'language': "भाषा",
      'currency': 'मुद्रा',
      'carry-forward': 'आगे बढ़ाएँ',
      'carry-forward-subtitle':
          "शेष राशि को एक महीने से दूसरे महीने तक ले जाएं।\nउदाहरण के लिए, आज की आय - 1000, व्यय - 400, शेष 600 को कल के शुरुआती शेष के रूप में आगे बढ़ाया जाता है।",
      'date': "तारिख का प्रारूप",
      'account': "प्रोफ़ाइल और खाते",
      'google-drive-settings': "गूगल ड्राइव सेटिंग",
      'google-account': "गूगल खाता",
      'backup': 'बैक अप',
      'Last-Backup': "अंतिम बैकअप",
      'Last-Backup-subtitle':
          'Google ड्राइव पर अपने डेटा का बैकअप लें। जब आप ऐप को दोबारा इंस्टॉल करते हैं और Google खाते से साइन इन करते हैं तो आप उन्हें पुनर्स्थापित कर सकते हैं।\nहम दृढ़ता से अनुशंसा करते हैं कि आप ऐप से नियमित रूप से बैकअप लें (क्योंकि Google ड्राइव पर बैकअप स्वचालित नहीं है)। ऐसा करने से आपका डेटा सुरक्षित रहेगा, भले ही आपका उपकरण खो जाए/क्षतिग्रस्त हो जाए',
      'save-excel': "एक्सेल के रूप में सहेजें",
      'category': "कस्टम और डिफॉल्ट श्रेणियाँ",
      'category-subtitle':
          "श्रेणी संपादित करें/हटाएं/छिपाएं, अपनी श्रेणी जोड़ने के लिए एक वीडियो देखें",
      'theme-title': "विषय",
      'theme-subtitle-orginal': "मूल",
      'app-lock': "ऐप लॉक",
      'app-lock-subtitle':
          'आपके डेटा को गलती से दूसरों द्वारा देखे जाने से बचाने में आपकी सहायता करता है। फ़िंगरप्रिंट डिवाइस में पंजीकृत होना चाहिए.',
      'app-version': 'एप्लिकेशन वेरीज़न',
      'app-version-subtitle':
          'यदि कोई अपडेट है तो प्लेस्टोर से अपडेट देखने के लिए यहां क्लिक करें',
      'logout': 'लॉग आउट',
      'premium': 'प्रीमियम के लिए जाएँ',
    },
    'pdf': {
      'report': 'प्रतिवेदन',
      'alltime': 'पूरे समय',
      'custom-date': 'कस्टम दिनांक सीमा',
      'all': 'सभी',
      'income': "आय (क्रेडिट)",
      'expense': "व्यय (डेबिट)",
      'note': "टिप्पणियाँ",
    },
    'save-excel': {
      'title': "एक्सेल के रूप में सहेजें",
      "export": "डेटा निर्यात करें",
      "all": "पूरे समय",
      "Year": "सालाना",
      "month": "महीने के",
      "custom": "कस्टम दिनांक सीमा",
      "download": "डाउनलोड करना",
    },
    'category': {
      "title": "कस्टम और डिफ़ॉल्ट श्रेणियाँ",
      'income': "आय (क्रेडिट)",
      'expense': "व्यय (डेबिट)",
      "income-bonus": "बोनस",
      "income-interest": "ब्याज आय",
      "income-investment": "निवेश",
      "income-reimubursement": "अदायगी",
      "income-rental": "किराये की आय",
      "income-returned": "वापस की गई खरीदारी",
      "income-salary": "वेतन",
      "expense-atm": "एटीएम",
      "expense-ait": "हवाई टिकट",
      "expense-auto": "ऑटो और परिवहन",
      "expense-beauty": "सुंदरता",
      "expense-bike": "बाइक",
      "expense-Bills": "बिल और उपयोगिताएँ",
      "expense-books": "किताबें",
      "expense-Bus": "बस का किराया  ",
      "expense-cc": "सीसी बिल भुगतान",
      "expense-cable": "केबल",
      "expense-cake": "केक",
      "expense-car": "कार",
      "expense-car-loan": "कार ऋण",
      "expense-cigarette": "सिगरेट",
      "expense-clothing": "वस्त्र",
      "expense-coffee": "कॉफी",
      "expense-dining": "भोजन",
      "expense-drinks": "पेय",
      "expense-emi": "ईएमआई",
      "expense-education": "शिक्षा",
      "expense-education-loan": "शिक्षा ऋण",
      "expense-electricity": "बिजली",
      "expense-electronics": "इलेक्ट्रानिक्स",
      "expense-entertainment": "मनोरंजन",
      "expense-festivals": "समारोह",
      "expense-finance": "वित्त",
      "expense-fitness": "स्वास्थ्य",
      "expense-flowers": "फूल",
      "expense-food": "भोजन एवं खान-पान",
      "expense-fruits": "फल",
      "expense-games": "खेल",
      "expense-gas": "गैस",
      "expense-gifts": "उपहार और दान",
      "expense-groceries": "किराने का सामान",
      "expense-health": "स्वास्थ्य",
      "expense-home": "गृह ऋण",
      "expense-hotel": "होटल",
      "expense-household": "परिवार",
      "expense-ice": "आइसक्रीम",
      "expense-internet": "इंटरनेट",
      "expense-kids": "बच्चे",
      "expense-laundry": "धोने लायक कपड़े",
      "expense-maid": "नौकरानी/ड्राइवर",
      "expense-maintenance": "रखरखाव",
      "expense-medicines": "दवाइयाँ",
      "expense-milk": "दूध",
      "expense-misc": "विविध",
      "expense-mobile": "गतिमान",
      "expense-personal": "व्यक्तिगत देखभाल",
      "expense-personal-loan": "व्यक्तिगत कर्ज़",
      "expense-pet": "पालतू जानवरों की देखभाल",
      "expense-Pizza": "पिज़्ज़ा",
      "expense-printing": "मुद्रण और स्कैनिंग",
      "expense-rent": "किराया",
      "expense-salon": "सैलून",
      "expense-savings": "बचत",
      "expense-shopping": "खरीदारी",
      "expense-stationery": "लेखन सामग्री",
      "expense-taxes": "करों",
      "expense-Taxi": "टैक्सी",
      "expense-toll": "टोल",
      "expense-toys": "खिलौने",
      "expense-train": "रेलगाड़ी",
      "expense-travel": "सब्ज़ियाँ",
      "expense-vacation": "छुट्टी",
      "expense-vegetables": "सब्ज़ियाँ",
      "expense-water": "पानी",
      "expense-work": "काम",
    },
    "profile": {
      "title": "प्रोफ़ाइल और खाते",
    },
  },
};

displayMonth(String month) {
  month = month.toLowerCase();
  if (month.length == 3) {
    switch (month) {
      case 'jan':
        return localizedValues[language]!["month"]!["January"];
      case 'feb':
        return localizedValues[language]!["month"]!["February"];
      case 'mar':
        return localizedValues[language]!["month"]!["March"];
      case 'apr':
        return localizedValues[language]!["month"]!["April"];
      case 'may':
        return localizedValues[language]!["month"]!["May"];
      case 'jun':
        return localizedValues[language]!["month"]!["June"];
      case 'jul':
        return localizedValues[language]!["month"]!["July"];
      case 'aug':
        return localizedValues[language]!["month"]!["August"];
      case 'sep':
        return localizedValues[language]!["month"]!["September"];
      case 'oct':
        return localizedValues[language]!["month"]!["October"];
      case 'nov':
        return localizedValues[language]!["month"]!["November"];
      case 'dec':
        return localizedValues[language]!["month"]!["December"];
      default:
        return "";
    }
  } else {
    switch (month) {
      case 'january':
        return localizedValues[language]!["month"]!["January"];
      case 'february':
        return localizedValues[language]!["month"]!["February"];
      case 'march':
        return localizedValues[language]!["month"]!["March"];
      case 'april':
        return localizedValues[language]!["month"]!["April"];
      case 'may':
        return localizedValues[language]!["month"]!["May"];
      case 'june':
        return localizedValues[language]!["month"]!["June"];
      case 'july':
        return localizedValues[language]!["month"]!["July"];
      case 'august':
        return localizedValues[language]!["month"]!["August"];
      case 'september':
        return localizedValues[language]!["month"]!["September"];
      case 'october':
        return localizedValues[language]!["month"]!["October"];
      case 'november':
        return localizedValues[language]!["month"]!["November"];
      case 'december':
        return localizedValues[language]!["month"]!["December"];
      default:
        return "";
    }
  }
}

displayDate(String day) {
  day = day.toLowerCase();
  switch (day) {
    case 'monday':
      return localizedValues[language]!["day"]!["Monday"];
    case 'tuesday':
      return localizedValues[language]!["day"]!["Tuesday"];
    case 'wednesday':
      return localizedValues[language]!["day"]!["Wednesday"];
    case 'thursday':
      return localizedValues[language]!["day"]!["Thursday"];
    case 'friday':
      return localizedValues[language]!["day"]!["Friday"];
    case 'saturday':
      return localizedValues[language]!["day"]!["Saturday"];
    case 'sunday':
      return localizedValues[language]!["day"]!["Sunday"];
    default:
      return "";
  }
}
