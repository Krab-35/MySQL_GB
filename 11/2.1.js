// создаем коллекцию ip-адресов

SADD visit_ip_address '192.168.1.1' '192.168.1.2' '192.168.1.3' '192.168.1.4' '192.168.1.5'

// подсчет колличества записей в коллекции

SCARD visit_ip_address