workspace "ПлатиДом" "Автоплатеж с лимитом суммы" {
    !impliedRelationships false

    model {
        client = person "Клиент" "Авторизованный пользователь мобильного банка."
        accrualSource = softwareSystem "ГИС ЖКХ" "Внешний источник начислений ЖКУ. Учебное допущение A-01." "External"
        cardProcessing = softwareSystem "Процессинг карт" "Принимает команды оплаты и сообщает состояние операции. Учебное допущение A-12." "External"

        platidom = softwareSystem "ПлатиДом" "Раздел мобильного банка для регулярных начислений." {
            mobile = container "Мобильное приложение банка" "Настраивает автоплатёж и показывает клиенту его историю." "iOS / Android" "MobileDevicePortrait"
            api = container "API ПлатиДома" "Управляет правилами, запускает и отслеживает оплату, выдаёт историю." "Java / Spring Boot"
            db = container "База данных ПлатиДома" "Хранит привязки, снимки начислений, правила, попытки оплаты и причины пропуска." "PostgreSQL" "Database"
        }

        client -> mobile "Выбирает привязку и источник оплаты, подтверждает лимит, отключает правило и смотрит историю" "UI"
        mobile -> api "Передаёт настройки и согласие, отключает правило и читает свои правила и историю" "HTTPS / JSON"
        api -> accrualSource "Запрашивает ID, сумму, валюту и состояние начислений по поставщику и счёту" "API ГИС ЖКХ · контракт уточнить"
        api -> db "Читает привязки и снимки, читает и записывает правила, попытки, ключи и исходы" "SQL / JDBC"
        api -> cardProcessing "Передаёт команду оплаты с ключом запроса, суммой, валютой и ссылкой на источник оплаты" "API процессинга · контракт записи уточнить" "PaymentCommand"
        api -> cardProcessing "Проверяет источник и средства, запрашивает статус по ключу запроса или ID операции" "API процессинга · контракт чтения уточнить" "ProcessingQueries"
    }

    views {
        container platidom "AutopayLimit" {
            include client mobile api db accrualSource cardProcessing
            title "C4 · Уровень 2 · ПлатиДом — Автоплатеж с лимитом суммы"
            description "Контейнеры и внешние зависимости фичи SCRUM-2166."
            autoLayout tb 480 350
        }

        styles {
            element "Person" {
                shape Person
                background #183153
                color #ffffff
            }
            element "Container" {
                background #1d5681
                color #ffffff
            }
            element "MobileDevicePortrait" {
                shape MobileDevicePortrait
            }
            element "Database" {
                shape Cylinder
            }
            element "External" {
                background #526276
                color #ffffff
            }
            relationship "PaymentCommand" {
                style solid
                position 40
            }
            relationship "ProcessingQueries" {
                style dashed
                position 70
            }
        }
    }
}
