workspace "ПлатиДом" "Архитектурный пример SCRUM-2166. Граница и технологии предложены для учебной модели." {
    !impliedRelationships false
    model {
        client = person "Клиент" "Владелец привязки и правила"
        mobile = softwareSystem "Мобильный банк" "Общее приложение банка с экраном ПлатиДома"
        gis = softwareSystem "ГИС ЖКХ" "Источник сведений о начислениях ЖКУ"
        bank = softwareSystem "Система карт банка" "Предоставляет карты клиента и доступные средства"
        processing = softwareSystem "Процессинг карт" "Исполняет платеж и сообщает состояние операции"
        platidom = softwareSystem "ПлатиДом" "Автоплатеж по сохраненной привязке" {
            api = container "Серверное приложение ПлатиДома" "Применяет правила владельца. Обрабатывает начисления и уточняет исход платежа в фоне." "Java / Spring Boot"
            db = container "Хранилище ПлатиДома" "Хранит правила, согласия, задания и записи попыток с ключами операций." "PostgreSQL" {
                tags "Database"
            }
        }
        client -> mobile "Подтверждает правило, видит историю" "UI"
        mobile -> api "Изменяет правило и запрашивает историю владельца" "HTTPS / JSON"
        api -> db "Читает привязку и правило, фиксирует задание, ключ и результат попытки" "PostgreSQL / TLS"
        api -> gis "Запрашивает начисления, сверяет актуальную сумму перед оплатой" "HTTPS"
        api -> bank "Запрашивает карты владельца и доступные средства" "HTTPS / JSON"
        api -> processing "Поручает списание с ключом операции" "HTTPS / JSON"
        api -> processing "Запрашивает статус исходной операции по сохраненному ключу" "HTTPS / JSON"
    }
    views {
        container platidom "Autopay" {
            include client mobile api db gis bank processing
            title "ПлатиДом | C4 L2 | Автоплатеж с лимитом"
            autoLayout lr
        }
        styles {
            element "Container" {
                background #17629a
                color #ffffff
            }
            element "Person" {
                shape Person
            }
            element "Database" {
                shape Cylinder
            }
        }
    }
}
