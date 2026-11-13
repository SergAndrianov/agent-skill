workspace "ПлатиДом" "SCRUM-2163: поиск и привязка начислений" {
 !identifiers hierarchical
 model {
 client = person "Клиент" "Пользователь мобильного банка"
 gis = softwareSystem "ГИС ЖКХ" "Внешний источник начислений ЖКУ; A-01"
 platidom = softwareSystem "ПлатиДом" "Поиск и привязка лицевых счетов" {
 mobile = container "Мобильное приложение банка" "Ввод, результаты, подтверждение привязки и ошибки" "Мобильное приложение; стек не определен"
 api = container "Серверное приложение ПлатиДома" "Контроль доступа, валидация, поиск, сохранение без дублей и обновление" "Серверное приложение; стек не определен"
 db = container "Хранилище ПлатиДома" "Привязки с владельцем, начисления и время успешного обновления" "База данных; СУБД не определена" {
 tags "Database"
 }
 }
 client -> platidom.mobile "Ищет, подтверждает привязку, просматривает свои счета"
 platidom.mobile -> platidom.api "Запрашивает поиск, сохранение, обновление; получает результаты и ошибки"
 platidom.api -> gis "Запрашивает начисления по поставщику и счету; обрабатывает ответ или ошибку"
 platidom.api -> platidom.db "Читает привязки; сохраняет уникальные привязки и снимки с временем"
 }
 views {
 container platidom "SearchAndLink" {
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
