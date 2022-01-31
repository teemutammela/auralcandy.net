# frozen_string_literal: true

module Sinatra
  module Podcast
    module Legacy
      def self.registered(app)
        # Episode landing page redirection
        app.get '/episode/:id/?' do |id|
          # Legacy episode ID => Contentful entry ID
          episode_entry = {
            192 => '6XvYgqUxMcowAoGyOSwiKQ',
            191 => '4ZH9PTiH1m4aomE68aAQAU',
            190 => '3N1QXdk2MMiGAS64suoGWU',
            189 => '2PJH4dOPwAq0ssYIaASOqs',
            188 => 'rXhtskqvAsgGOAskquuAo',
            187 => '5odZppQXTyuueKiIaCue4g',
            186 => '4IJaHiLx3yag2uckeYGiaU',
            185 => '2saoWwdWbWa8ygE6OQekue',
            184 => 'XZqkl8WgASyqKyEQ4oYIo',
            183 => '54jgCHtnRecUeOow2Es6I2',
            182 => '45uzPBBLqwqEWKkKaUYGuM',
            181 => '3HeEIh4tzqSW40kA4oaQ68',
            180 => '37u64k5GSAK8yECwkIS4gI',
            179 => '4L50KjNMQoIW8A8II4YYEk',
            178 => '24SBID8QUcQ6MegKcom6IW',
            177 => 'fapDl5WhB6QQuGOGogoeW',
            176 => '5CIaNoGVk4koWACe0kcK2I',
            175 => '3X6ACxz4EggGSuaO00eWkY',
            174 => '1tsCnV4CcEOiSuwyGyaCQu',
            173 => '3wUPfAWlnOmoCSu6Ykm2As',
            172 => '4k8Z4GcEUokQ86u8wwwkyC',
            171 => '3ldoKzmq1OM0MGQM4M2cQI',
            170 => '6enA1LWvWEyc0QG0MCC2uY',
            169 => '6l8rckhvkk6oEI6eeg4ioO',
            168 => '16oeQDertkcGqEugug0siO',
            167 => '1g8HBz93oIwYOkewuwWEmK',
            166 => '4kFPe2jLRYEw4ge8YWYGMu',
            165 => '30AScSyViEGYy88YuQUiEg',
            164 => '2BRCJSO5Ow0i4aseceguwu',
            163 => '3VNUHcX1XO8OAqqKmyEoMU',
            162 => '35RWNdL75SWSySEcOE6U4o',
            161 => '7Jbt9oHh7isyiAkaCMu8I0',
            160 => '3LStt9mrJmescwKwSYUOa0',
            159 => '3LStt9mrJmescwKwSYUOa0',
            158 => '3LStt9mrJmescwKwSYUOa0',
            157 => '1Ps70lWJbC4SaicYk2cIQC',
            156 => '6fLNfYlBOEsY00QEkUQEUO',
            155 => '14aBuNKIPW6sUgQua8sUuY',
            154 => '14aBuNKIPW6sUgQua8sUuY',
            153 => '14aBuNKIPW6sUgQua8sUuY',
            152 => '14aBuNKIPW6sUgQua8sUuY',
            151 => '6ZBXcKB4oE8MEEUuYYsgWi',
            150 => '2CEAWseg728GU0m4si4402',
            149 => '2JaPp29XDimMAqUAm2yWg0',
            148 => '4jkQHsGXywQaYaku8ECcey',
            147 => '7CnrQHWSU8wm8Qqswuakk',
            146 => '5f91pgmJV6SacUs0k4ykWS',
            145 => '1rwF9VckGwmMaCWkuSUi66',
            144 => '2KpTARtXgAMwWCmA6si2ec',
            143 => '2eflXjqfF6u0Q4CYQmmiy6',
            142 => '2Nuj3ONiKQE6QSeCakcIQe',
            141 => '4HEmVyD1AcwykuoSIMM8mk',
            138 => '1SCNu4xFmEIUaeiIE0Uygw',
            137 => '2Yq8KR0gxqeauq4kqewsem',
            136 => '7qEZd9FEjYMqqgGwo0acKs',
            135 => '2K937vaLEsgc4CUaq6gqcA',
            134 => 'episode_98',
            133 => 'episode_97',
            132 => 'episode_96',
            131 => 'episode_95',
            130 => 'episode_94',
            129 => 'episode_93',
            128 => 'episode_92',
            127 => 'episode_91',
            126 => 'episode_90',
            125 => 'episode_89',
            124 => 'episode_88',
            123 => 'episode_87',
            122 => 'episode_86',
            121 => 'episode_85',
            120 => 'episode_84',
            119 => 'episode_83',
            118 => 'episode_82',
            117 => 'episode_81',
            116 => 'episode_80',
            115 => 'episode_79',
            114 => 'episode_78',
            113 => 'episode_77',
            112 => 'episode_76',
            111 => 'episode_75',
            110 => 'episode_74',
            109 => 'episode_73',
            108 => 'episode_72',
            107 => 'episode_71',
            106 => 'episode_70',
            105 => 'episode_69',
            104 => 'episode_68',
            103 => 'episode_67',
            102 => 'episode_66',
            101 => 'episode_65',
            100 => 'episode_64',
            99 => 'episode_63',
            82 => 'episode_62',
            21 => 'episode_61',
            81 => 'episode_60',
            80 => 'episode_59',
            79 => 'episode_58',
            78 => 'episode_57',
            77 => 'episode_56',
            76 => 'episode_55',
            75 => 'episode_54',
            74 => 'episode_53',
            73 => 'episode_52',
            19 => 'episode_51',
            72 => 'episode_50',
            71 => 'episode_49',
            70 => 'episode_48',
            69 => 'episode_47',
            68 => 'episode_46',
            67 => 'episode_45',
            18 => 'episode_44',
            66 => 'episode_43',
            65 => 'episode_42',
            64 => 'episode_41',
            63 => 'episode_40',
            62 => 'episode_39',
            61 => 'episode_38',
            60 => 'episode_37',
            59 => 'episode_36',
            58 => 'episode_35',
            57 => 'episode_34',
            56 => 'episode_33',
            55 => 'episode_32',
            54 => 'episode_31',
            53 => 'episode_30',
            52 => 'episode_29',
            51 => 'episode_28',
            50 => 'episode_27',
            49 => 'episode_26',
            48 => 'episode_25',
            47 => 'episode_24',
            46 => 'episode_23',
            45 => 'episode_22',
            43 => 'episode_21',
            42 => 'episode_20',
            41 => 'episode_19',
            40 => 'episode_18',
            39 => 'episode_17',
            38 => 'episode_16',
            37 => 'episode_15',
            36 => 'episode_14',
            35 => 'episode_13',
            34 => 'episode_12',
            33 => 'episode_11',
            32 => 'episode_10',
            31 => 'episode_9',
            30 => 'episode_8',
            28 => 'episode_7',
            27 => 'episode_6',
            26 => 'episode_5',
            25 => 'episode_4',
            24 => 'episode_3',
            22 => 'episode_2',
            20 => 'episode_1'
          }

          entry_id = episode_entry[parse_id(id)]

          # Halt or redirect to episode URL
          if entry_id.nil?
            halt 404
          else
            episode = get_episode_by_id(entry_id)
            redirect to(episode.url), 301
          end
        end

        # Audio file redirection
        app.get '/audio/*.mp3' do |file|
          # Legacy episode file URL => Contentful entry ID
          file_entry = {
            'mk-ultra_mesmic-9th_anniversary_radio_show' => '6XvYgqUxMcowAoGyOSwiKQ',
            'mesmic-shadow_project_vol16' => '4ZH9PTiH1m4aomE68aAQAU',
            'mk-ultra-after_hours' => '3N1QXdk2MMiGAS64suoGWU',
            'mk-ultra-calling' => '2PJH4dOPwAq0ssYIaASOqs',
            'mesmic-circuit_breaker' => 'rXhtskqvAsgGOAskquuAo',
            'mk-ultra-infinity' => '5odZppQXTyuueKiIaCue4g',
            'mesmic-blind_justice' => '4IJaHiLx3yag2uckeYGiaU',
            'mk-ultra-pina_colada' => '2saoWwdWbWa8ygE6OQekue',
            'mk-ultra_mesmic-xmas_radio_show_2016' => 'XZqkl8WgASyqKyEQ4oYIo',
            'mk-ultra-long_walks_in_october' => '54jgCHtnRecUeOow2Es6I2',
            'mk-ultra_mesmic-8th_anniversary_radio_show' => '45uzPBBLqwqEWKkKaUYGuM',
            'mesmic-shadow_project_vol15' => '3HeEIh4tzqSW40kA4oaQ68',
            'mk-ultra-mamacita' => '37u64k5GSAK8yECwkIS4gI',
            'mesmic-tone_therapy' => '4L50KjNMQoIW8A8II4YYEk',
            'mk-ultra-shadow_project_vol14' => '24SBID8QUcQ6MegKcom6IW',
            'mesmic-ghost_of_disco_past' => 'fapDl5WhB6QQuGOGogoeW',
            'mk-ultra-cuba_libre' => '5CIaNoGVk4koWACe0kcK2I',
            'mesmic-shadow_project_vol13' => '3X6ACxz4EggGSuaO00eWkY',
            'mk-ultra-lights_in_darkness' => '1tsCnV4CcEOiSuwyGyaCQu',
            'mesmic-galactic_beast' => '3wUPfAWlnOmoCSu6Ykm2As',
            'mk-ultra-smoke_mirrors' => '4k8Z4GcEUokQ86u8wwwkyC',
            'mesmic-gift_of_life' => '3ldoKzmq1OM0MGQM4M2cQI',
            'mk-ultra_mesmic-7th_anniversary_radio_show' => '6enA1LWvWEyc0QG0MCC2uY',
            'mk-ultra-weightless_part2' => '6l8rckhvkk6oEI6eeg4ioO',
            'mk-ultra-weightless_part1' => '16oeQDertkcGqEugug0siO',
            'anthony_tone-shadow_project_vol12' => '1g8HBz93oIwYOkewuwWEmK',
            'mk-ultra-mojito' => '4kFPe2jLRYEw4ge8YWYGMu',
            'mesmic-flight_247' => '30AScSyViEGYy88YuQUiEg',
            'mk-ultra-reconstructed' => '2BRCJSO5Ow0i4aseceguwu',
            'mesmic-shadow_project_vol11' => '3VNUHcX1XO8OAqqKmyEoMU',
            'mk-ultra-jackin_groovin' => '35RWNdL75SWSySEcOE6U4o',
            'mesmic-absolute_power' => '7Jbt9oHh7isyiAkaCMu8I0',
            'mk-ultra_mesmic-xmas_radio_show_part3' => '3LStt9mrJmescwKwSYUOa0',
            'mk-ultra_mesmic-xmas_radio_show_part2' => '3LStt9mrJmescwKwSYUOa0',
            'mk-ultra_mesmic-xmas_radio_show_part1' => '3LStt9mrJmescwKwSYUOa0',
            'mesmic-apes_of_the_planet' => '1Ps70lWJbC4SaicYk2cIQC',
            'mk-ultra-the_deepest_abyss' => '6fLNfYlBOEsY00QEkUQEUO',
            'mk-ultra_mesmic-6th_anniversary_radio_show_part4' => '14aBuNKIPW6sUgQua8sUuY',
            'mk-ultra_mesmic-6th_anniversary_radio_show_part3' => '14aBuNKIPW6sUgQua8sUuY',
            'mk-ultra_mesmic-6th_anniversary_radio_show_part2' => '14aBuNKIPW6sUgQua8sUuY',
            'mk-ultra_mesmic-6th_anniversary_radio_show_part1' => '14aBuNKIPW6sUgQua8sUuY',
            'mesmic-black_hole' => '6ZBXcKB4oE8MEEUuYYsgWi',
            'mk-ultra-shadow_project_vol10' => '2CEAWseg728GU0m4si4402',
            'mesmic-rain_or_shine' => '2JaPp29XDimMAqUAm2yWg0',
            'mk-ultra-emerging_ibiza_2014_dj_competiton_mix' => '4jkQHsGXywQaYaku8ECcey',
            'mk-ultra-2_much_disco_4_ya' => '7CnrQHWSU8wm8Qqswuakk',
            'mesmic-the_funk_formula' => '5f91pgmJV6SacUs0k4ykWS',
            'mk-ultra-colors_of_noise' => '1rwF9VckGwmMaCWkuSUi66',
            'mesmic-concrete_jungle' => '2KpTARtXgAMwWCmA6si2ec',
            'mk-ultra-armchair_astronaut' => '2eflXjqfF6u0Q4CYQmmiy6',
            'mesmic-future_history' => '2Nuj3ONiKQE6QSeCakcIQe',
            'mk-ultra-shadow_project_vol09' => '4HEmVyD1AcwykuoSIMM8mk',
            'mesmic-structural_integrity' => '1SCNu4xFmEIUaeiIE0Uygw',
            'mk-ultra-halloween_hustle' => '2Yq8KR0gxqeauq4kqewsem',
            'MK-Ultra B2B Mesmic - 5th Anniversary 100th Episode' => '7qEZd9FEjYMqqgGwo0acKs',
            'Mesmic - Personality Reboot' => '2K937vaLEsgc4CUaq6gqcA',
            'MK-Ultra - Not Ready For Bed Yet' => 'episode_98',
            'MK-Ultra - Riot Gear' => 'episode_97',
            'Mesmic - Destination Anywhere' => 'episode_96',
            'MK-Ultra - Sounds Of The Streets' => 'episode_95',
            'Mesmic - Laid Back Vibes' => 'episode_94',
            'Mesmic - Shadow Project Vol08' => 'episode_93',
            'MK-Ultra - Traveling Inwards' => 'episode_92',
            'Mesmic - Rhythm Train' => 'episode_91',
            'MK-Ultra - Fist Pump Nation' => 'episode_90',
            'Mesmic - Thermal Tunes' => 'episode_89',
            'MK-Ultra - World Full Of Wonders' => 'episode_88',
            'Mesmic - This Is Not Ibiza' => 'episode_87',
            'MK-Ultra - Healing Process' => 'episode_86',
            'MK-Ultra - Ruff Hugga' => 'episode_85',
            'Mesmic - Chance 2 Dance' => 'episode_84',
            'MK-Ultra - Shadow Project Vol07' => 'episode_83',
            'Mesmic - Winter Solstice' => 'episode_82',
            'MK-Ultra - Beautiful Machines' => 'episode_81',
            'Mesmic feat. Kimber - Six Feet Deep' => 'episode_80',
            'MK-Ultra - Cheesco' => 'episode_79',
            'Mesmic - Shadow Project Vol06' => 'episode_78',
            'MK-Ultra - Heart Of Tiger' => 'episode_77',
            'Mesmic - Moving Out' => 'episode_76',
            'MK-Ultra - Shadow Project Vol05' => 'episode_75',
            'Mesmic - Munkee Rayg' => 'episode_74',
            'MK-Ultra - Peace Love And House Music' => 'episode_73',
            'Mesmic - Mist' => 'episode_72',
            'MK-Ultra - Francis Grasso Legacy' => 'episode_71',
            'Mesmic - Kaos Trax' => 'episode_70',
            'MK-Ultra - Zero Point' => 'episode_69',
            'MK-Ultra - Shadow Project Vol04' => 'episode_68',
            'Mesmic - Soul Sista' => 'episode_67',
            'MK-Ultra - Ghostworks' => 'episode_66',
            'Mesmic - Pastime At Last' => 'episode_65',
            'MK-Ultra - Feel Good Generation' => 'episode_64',
            'Mesmic - 2012 Party Starter' => 'episode_63',
            'MK-Ultra - Cruise Control' => 'episode_62',
            'Mesmic - Shadow Project Vol03' => 'episode_61',
            'MK-Ultra - Window To My Soul Part 2' => 'episode_60',
            'Mesmic - Serenity' => 'episode_59',
            'MK-Ultra - Window To My Soul Part 1' => 'episode_58',
            'Mesmic - BD-303' => 'episode_57',
            'MK-Ultra feat. Kimber - Eclipse' => 'episode_56',
            'Mesmic - Slow Motion' => 'episode_55',
            'MK-Ultra - UNI4EVA' => 'episode_54',
            'Mesmic - Happy Hour' => 'episode_53',
            'MK-Ultra feat. Mesmic - The Big Fifty' => 'episode_52',
            'MK-Ultra - Shadow Project Vol02' => 'episode_51',
            'MK-Ultra - Apple Pie From Scratch' => 'episode_50',
            'Mesmic - Rush' => 'episode_49',
            'MK-Ultra - Full Body Prosthesis' => 'episode_48',
            'Mesmic - Gaia Vibe' => 'episode_47',
            'MK-Ultra - Reality Soundtrack' => 'episode_46',
            'Mesmic - Far Side Of The World' => 'episode_45',
            'MK-Ultra and Mesmic - Shadow Project Vol01' => 'episode_44',
            'MK-Ultra - Pinata' => 'episode_43',
            'Mesmic - House Rules' => 'episode_42',
            'MK-Ultra - Escapism' => 'episode_41',
            'Mesmic - Spitfire' => 'episode_40',
            'MK-Ultra - Truth Is Not Treason' => 'episode_39',
            'Mesmic - Jamais Vu' => 'episode_38',
            'MK-Ultra - Disco Freak' => 'episode_37',
            'Mesmic - Cybernetix' => 'episode_36',
            'MK-Ultra - Metamorphosis' => 'episode_35',
            'Mesmic - Summer Son' => 'episode_34',
            'MK-Ultra - Karma Treasury' => 'episode_33',
            'MK-Ultra - Embrace Of Dusk' => 'episode_32',
            'Mesmic - Retro Redux' => 'episode_31',
            'MK-Ultra - Emotion Switch' => 'episode_30',
            'Mesmic - Still Dancing' => 'episode_29',
            'MK-Ultra - Urban Warfare' => 'episode_28',
            'Mesmic - Easter Equalizer' => 'episode_27',
            'MK-Ultra - Hunters Moon' => 'episode_26',
            'Mesmic - Mysterium Fidei' => 'episode_25',
            'MK-Ultra - Space Vixen' => 'episode_24',
            'MK-Ultra - Xmas Xtravaganza' => 'episode_23',
            'Mesmic - Around The World In 128 BPM' => 'episode_22',
            'Mesmic - Journey' => 'episode_21',
            'MK-Ultra - El Hombre Blanco De Norte' => 'episode_20',
            'MK-Ultra - Zen And The Art Of House Music' => 'episode_19',
            'Mesmic - Dark Autumn Skies' => 'episode_18',
            'MK-Ultra - 10 Kinds Of People' => 'episode_17',
            'Mesmic - The Big Wheel' => 'episode_16',
            'MK-Ultra - Shades Of Blue' => 'episode_15',
            'MK-Ultra - Root Of All Evil' => 'episode_14',
            'Mesmic - Salt Mine Groove' => 'episode_13',
            'MK-Ultra - Beyond' => 'episode_12',
            'MK-Ultra - High Voltage' => 'episode_11',
            'Mesmic - Lost In The Windy City' => 'episode_10',
            'MK-Ultra - 6 Month Anniversary Special' => 'episode_9',
            'MK-Ultra - Beginnings And Endings' => 'episode_8',
            'MK-Ultra feat. Double L - My Unconditional Lover' => 'episode_7',
            'Mesmic - In The Deep' => 'episode_6',
            'MK-Ultra - Just Another Face In The Crowd' => 'episode_5',
            'MK-Ultra B2B Mesmic - ADE2008 Exclusive Promo Mix' => 'episode_4',
            'MK-Ultra - Sunset At 40.000 Feet' => 'episode_3',
            'Mesmic - Give It To Me Funky' => 'episode_2',
            'Mesmic - Mellow Yellow' => 'episode_1'
          }

          entry_id = file_entry[file]

          # Halt or redirect to episode URL
          if entry_id.nil?
            halt 404
          else
            episode = get_episode_by_id(entry_id)
            redirect to(episode.audio_url), 301
          end
        end
      end
    end
  end
end
