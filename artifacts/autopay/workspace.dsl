workspace "ПлатиДом — автоплатеж" "SCRUM-2166. Технологии и внешние контракты — учебные допущения." {
 !identifiers hierarchical
 model {
 client = person "Клиент" "Управляет собственным автоплатежом"
 gis = softwareSystem "ГИС ЖКХ" "Источник начислений; A-01"
 bank = softwareSystem "Банковская система" "Доступные карты и средства; учебное допущение"
 processing = softwareSystem "Процессинг карт" "Оплата, распознавание повторов и состояние операции; A-09, A-12"
 platidom = softwareSystem "ПлатиДом" "Регулярные начисления и автоплатеж" {
 mobile = container "Мобильное приложение банка" "Настройка, согласие, отключение, история и причины пропуска" "Kotlin / Swift (предложение)"
 api = container "Серверное приложение ПлатиДома" "Доступ, правила, обработка получения начислений, проверки оплаты и уточнение результата" "Java / Spring Boot (предложение)"
 db = container "Хранилище ПлатиДома" "Привязки, правила, согласия, начисления, попытки и защита от дублей" "PostgreSQL (предложение)" {
 tags "Database"
 }
 }
 client -> platidom.mobile "Настраивает, подтверждает и просматривает" "UI"
 platidom.mobile -> platidom.api "Управляет правилами; получает собственную историю" "HTTPS / JSON (предложение)"
 platidom.api -> platidom.db "Атомарно сохраняет правила, попытки, ключи и результаты" "PostgreSQL protocol / TLS (предложение)"
 platidom.api -> gis "Получает начисления; повторно проверяет перед оплатой" "HTTPS (допущение контракта)"
 platidom.api -> bank "Проверяет доступность карты и средств" "HTTPS / JSON (допущение контракта)"
 platidom.api -> processing "Отправляет оплату с устойчивым ключом; проверяет исходную операцию" "HTTPS / JSON (допущение контракта)"
 }
 views {
 container platidom "Autopay" {
 include *
 autoLayout lr
 }
 styles {
 element "Person" {
 shape Person
 }
 element "Container" {
 background #1168bd
 color #ffffff
 }
 element "Database" {
 shape Cylinder
 }
 }
 }
}