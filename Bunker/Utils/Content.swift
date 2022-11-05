////
////  Content.swift
////  Bunker
////
////  Created by Danila Kokin on 26.10.2022.
////
//
//import Foundation
//
//public extension String {
//    enum File {
//        static let Instruction = FileString.instruction
//        static let Catastrophe = FileString.catastrophe
//        static let Condition = FileString.condition
//        static let Threat = FileString.threat
//        static let Shelter = FileString.shelther
//        static let Biology = FileString.biology
//        static let Profession = FileString.profession
//        static let Fact = FileString.fact
//        static let Health = FileString.health
//        static let Hobby = FileString.hobby
//        static let Luggage = FileString.luggage
//    }
//
//    enum WelcomeScreen {
//        static let Create = WelcomeString.create
//        static let Join = WelcomeString.join
//        static let Rules = WelcomeString.rules
//    }
//
//    enum Settings {
//    }
//
//    enum CreateGame {
//        //        static let name =
//        //        static let pack =
//        //        static let packs =
//        //        static let random =
//        //        static let create =
//        //        static let complexity =
//    }
//
//    enum ConnectToGame {
//        //        static let join
//        //        static let error
//        //        static let ok
//        //        static let name
//        //        static let next
//    }
//
//    enum WaitingRoom {
//        //        static let room
//        //        static let number
//        //        static let share
//        //        static let start
//        //        static let error
//        //        static let ok
//    }
//
//    enum Game {
//        //        static let condition
//        //        static let shelter
//        //        static let apocalypse
//        //        static let leave
//        //        static let exit
//        //        static let message
//        //        static let cancel
//        //        static let exit
//    }
//
//    //MARK: - Filenames
//    struct FileString {
//        static var instruction: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "instruction_ru"
//            case .eng:
//                return "instruction_en"
//            case .zhi:
//                return "instruction_en"
//            }
//        }
//
//        static var catastrophe: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "catastrophe_ru"
//            case .eng:
//                return "catastrophe_en"
//            case .zhi:
//                return "catastrophe_en"
//            }
//        }
//
//        static var condition: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "condition_ru"
//            case .eng:
//                return "condition_en"
//            case .zhi:
//                return "condition_en"
//            }
//        }
//
//        static var threat: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "threat_ru"
//            case .eng:
//                return "threat_en"
//            case .zhi:
//                return "threat_en"
//            }
//        }
//
//        static var shelther: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "shelther_ru"
//            case .eng:
//                return "shelther_en"
//            case .zhi:
//                return "shelther_en"
//            }
//        }
//
//        static var biology: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "biology_ru"
//            case .eng:
//                return "biology_en"
//            case .zhi:
//                return "biology_en"
//            }
//        }
//
//        static var profession: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "profession_ru"
//            case .eng:
//                return "profession_en"
//            case .zhi:
//                return "profession_en"
//            }
//        }
//
//        static var fact: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "fact_ru"
//            case .eng:
//                return "fact_en"
//            case .zhi:
//                return "fact_en"
//            }
//        }
//
//        static var health: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "health_ru"
//            case .eng:
//                return "health_en"
//            case .zhi:
//                return "health_en"
//            }
//        }
//
//        static var hobby: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "hobby_ru"
//            case .eng:
//                return "hobby_en"
//            case .zhi:
//                return "hobby_en"
//            }
//        }
//
//        static var luggage: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "luggage_ru"
//            case .eng:
//                return "luggage_en"
//            case .zhi:
//                return "luggage_en"
//            }
//        }
//    }
//
//    //MARK: - Welcome
//    struct WelcomeString {
//        static var create: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "Создать"
//            case .eng:
//                return "Create"
//            case .zhi:
//                return ""
//            }
//        }
//
//        static var join: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "Присоединиться"
//            case .eng:
//                return "Join"
//            case .zhi:
//                return ""
//            }
//        }
//
//        static var rules: String {
//            switch UserSettings.shared.language {
//            case .ru:
//                return "Правила"
//            case .eng:
//                return "Rules"
//            case .zhi:
//                return ""
//            }
//        }
//    }
//}
