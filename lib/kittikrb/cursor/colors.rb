module KittikRb
  module Cursor
    module Colors

      # The colors number 256 is only supported by vte (GNOME Terminal, XFCE4
      # Terminal, Nautilus Terminal, Terminator, ...)

      COLORS = {
        black: 0,
        maroon: 1,
        green: 2,
        olive: 3,
        navy_blue: 4,
        purple: 5,
        teal: 6,
        silver: 7,
        grey: 8,
        red: 9,
        lime: 10,
        yellow: 11,
        blue: 12,
        magenta: 13,
        aqua: 14,
        white: 15,
        grey_0: 16,
        _navy_blue: 17,
        dark_blue: 18,
        blue_3: 19,
        _blue_3: 20,
        blue_1: 21,
        dark_green: 22,
        deep_sky_blue_4: 23,
        _deep_sky_blue_4: 24,
        __deep_sky_blue_4: 25,
        dodger_blue_3: 26,
        dodger_blue_2: 27,
        green_4: 28,
        spring_green_4: 29,
        turquoise_4: 30,
        deep_sky_blue_3: 31,
        _deep_sky_blue_3: 32,
        dodger_blue_1: 33,
        green_3: 34,
        spring_green_3: 35,
        dark_cyan: 36,
        light_sea_green: 37,
        deep_sky_blue2: 38,
        deep_sky_blue1: 39,
        _green_3: 40,
        _spring_green_3: 41,
        spring_green_2: 42,
        cyan_3: 43,
        dark_turquoise: 44,
        turquoise_2: 45,
        green_1: 46,
        _spring_green_2: 47,
        spring_green_1: 48,
        medium_spring_green: 49,
        cyan_2: 50,
        cyan_1: 51,
        dark_red: 52,
        deep_pink_4: 53,
        purple_4: 54,
        _purple_4: 55,
        purple_3: 56,
        blue_violet: 57,
        orange_4: 58,
        grey_37: 59,
        medium_purple_4: 60,
        slate_blue_3: 61,
        _slate_blue_3: 62,
        royal_blue_1: 63,
        chartreuse_4: 64,
        dark_sea_green4: 65,
        pale_turquoise_4: 66,
        steel_blue: 67,
        steel_blue_3: 68,
        cornflower_blue: 69,
        chartreuse_3: 70,
        dark_sea_green_4: 71,
        cadet_blue: 72,
        _cadet_blue: 73,
        sky_blue_3: 74,
        steel_blue_1: 75,
        _chartreuse_3: 76,
        pale_green_3: 77,
        sea_green_3: 78,
        aquamarine_3: 79,
        medium_turquoise: 80,
        _steel_blue_1: 81,
        chartreuse_2: 82,
        sea_green_2: 83,
        sea_green_1: 84,
        _sea_green_1: 85,
        aquamarine_1: 86,
        dark_slate_gray_2: 87,
        _dark_red: 88,
        _deep_pink_4: 89,
        dark_magenta: 90,
        _dark_magenta: 91,
        dark_violet: 92,
        _purple: 93,
        orange4: 94,
        light_pink_4: 95,
        plum_4: 96,
        medium_purple_3: 97,
        _medium_purple_3: 98,
        slate_blue_1: 99,
        yellow_4: 100,
        wheat_4: 101,
        grey_53: 102,
        light_slate_grey: 103,
        medium_purple: 104,
        light_slate_blue: 105,
        _yellow_4: 106,
        dark_olive_green_3: 107,
        dark_sea_green: 108,
        light_sky_blue_3: 109,
        _light_sky_blue_3: 110,
        sky_blue_2: 111,
        _chartreuse_2: 112,
        _dark_olive_green_3: 113,
        _pale_green_3: 114,
        dark_sea_green_3: 115,
        dark_slate_gray_3: 116,
        sky_blue_1: 117,
        chartreuse_1: 118,
        light_green: 119,
        _light_green: 120,
        pale_green_1: 121,
        _aquamarine_1: 122,
        dark_slate_gray_1: 123,
        red_3: 124,
        __deep_pink_4: 125,
        medium_violet_red: 126,
        magenta_3: 127,
        _dark_violet: 128,
        __purple: 129,
        dark_orange_3: 130,
        indian_red: 131,
        hot_pink_3: 132,
        medium_orchid_3: 133,
        medium_orchid: 134,
        medium_purple_2: 135,
        dark_goldenrod: 136,
        light_salmon_3: 137,
        rosy_brown: 138,
        grey_63: 139,
        _medium_purple_2: 140,
        medium_purple_1: 141,
        gold_3: 142,
        dark_khaki: 143,
        navajo_white_3: 144,
        grey_69: 145,
        light_steel_blue_3: 146,
        light_steel_blue: 147,
        yellow_3: 148,
        __dark_olive_green_3: 149,
        _dark_sea_green_3: 150,
        dark_sea_green_2: 151,
        light_cyan_3: 152,
        light_sky_blue_1: 153,
        green_yellow: 154,
        dark_olive_green_2: 155,
        _pale_green_1: 156,
        _dark_sea_green_2: 157,
        dark_sea_green_1: 158,
        pale_turquoise_1: 159,
        _red_3: 160,
        deep_pink_3: 161,
        _deep_pink_3: 162,
        _magenta_3: 163,
        __magenta_3: 164,
        magenta_2: 165,
        _dark_orange_3: 166,
        _indian_red: 167,
        _hot_pink_3: 168,
        hot_pink_2: 169,
        orchid: 170,
        medium_orchid_1: 171,
        orange_3: 172,
        _light_salmon_3: 173,
        light_pink_3: 174,
        pink_3: 175,
        plum_3: 176,
        violet: 177,
        _gold_3: 178,
        light_goldenrod_3: 179,
        tan: 180,
        misty_rose_3: 181,
        thistle_3: 182,
        plum_2: 183,
        _yellow_3: 184,
        khaki_3: 185,
        light_goldenrod_2: 186,
        light_yellow_3: 187,
        grey_84: 188,
        light_steel_blue_1: 189,
        yellow_2: 190,
        dark_olive_green_1: 191,
        _dark_olive_green_1: 192,
        _dark_sea_green_1: 193,
        honey_dew_2: 194,
        light_cyan_1: 195,
        red_1: 196,
        deep_pink_2: 197,
        deep_pink_1: 198,
        _deep_pink_1: 199,
        _magenta_2: 200,
        magenta_1: 201,
        orange_red_1: 202,
        indian_red_1: 203,
        _indian_red_1: 204,
        hot_pink: 205,
        _hot_pink: 206,
        _medium_orchid_1: 207,
        dark_orange: 208,
        salmon_1: 209,
        light_coral: 210,
        pale_violet_red_1: 211,
        orchid_2: 212,
        orchid_1: 213,
        orange_1: 214,
        sandy_brown: 215,
        light_salmon_1: 216,
        light_pink_1: 217,
        pink_1: 218,
        plum_1: 219,
        gold_1: 220,
        light_golden_rod_2: 221,
        _light_golden_rod_2: 222,
        navajo_white_1: 223,
        misty_rose_1: 224,
        thistle_1: 225,
        yellow_1: 226,
        light_goldenrod_1: 227,
        khaki_1: 228,
        wheat_1: 229,
        corn_silk_1: 230,
        grey_100: 231,
        grey_3: 232,
        grey_7: 233,
        grey_11: 234,
        grey_15: 235,
        grey_19: 236,
        grey_23: 237,
        grey_27: 238,
        grey_30: 239,
        grey_35: 240,
        grey_39: 241,
        grey_42: 242,
        grey_46: 243,
        grey_50: 244,
        grey_54: 245,
        grey_58: 246,
        grey_62: 247,
        grey_66: 248,
        grey_70: 249,
        grey_74: 250,
        grey_78: 251,
        grey_82: 252,
        grey_85: 253,
        grey_89: 254,
        grey_93: 255
      }
    end
  end
end
