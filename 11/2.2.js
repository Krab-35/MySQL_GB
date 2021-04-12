// поиск имени по электронному адресу
SET a.petrov@mail.ru aleksandr
GET a.petrov@mail.ru

// поиск электронного имени по имени

SET aleksandr a.petrov@mail.ru
GET aleksandr

// так же поиско пожно произвести при помощи команды KEYS

KEYS a.petrov*
// или
KEY aleks*