workspace "ПлатиДом" "SCRUM-2163. Поиск и привязка начислений по лицевому счёту." {
    !impliedRelationships false

    model {
        client = person "Клиент" "Авторизованный пользователь мобильного банка."
        gis = softwareSystem "ГИС ЖКХ" "Внешний источник сведений о начислениях ЖКУ по допущению A-01." {
            tags "External"
        }
        platidom = softwareSystem "ПлатиДом" "Позволяет искать начисления ЖКУ и просматривать их по сохранённым привязкам." {
            mobile = container "Мобильное приложение банка" "Ввод реквизитов, просмотр начислений и явное подтверждение привязки." "Android / iOS (предложение)" {
                tags "Mobile"
            }
            api = container "Серверное приложение ПлатиДома" "Проверяет доступ и реквизиты, ищет начисления, сохраняет привязки и обновляет снимки." "Java / Spring Boot (предложение)"
            db = container "Хранилище ПлатиДома" "Хранит привязки владельцев и последние успешные снимки с временем обновления." "PostgreSQL (предложение)" {
                tags "Database"
            }
        }

        client -> mobile "Ищет начисления, подтверждает привязку и просматривает свои счета" "UI"
        mobile -> api "Ищет начисления, сохраняет привязку и обновляет данные по ней" "HTTPS / JSON (предложение)"
        api -> gis "Запрашивает начисления по поставщику и лицевому счёту" "HTTPS (контракт уточнить)"
        api -> db "Читает и сохраняет привязки и снимки начислений" "PostgreSQL / TLS (предложение)"
    }

    views {
        container platidom "SearchAndLink" {
            include client mobile api gis db
            title "ПлатиДом | C4 L2 | Поиск и привязка начислений"
            autoLayout tb
        }

        styles {
            element "Person" {
                shape Person
                background #123457
                color #ffffff
            }
            element "Container" {
                background #195e93
                color #ffffff
            }
            element "Mobile" {
                shape MobileDevicePortrait
            }
            element "Database" {
                shape Cylinder
            }
            element "External" {
                background #4c5968
                color #ffffff
            }
        }
    }
}

