# telegram_audio_to_text
Тестовое задание конвертировать Audio в текст в Telegram боте\
Ограничения принимаемого файл:\
-Файл не более 10 мб
-Синхронные запросы одинм потоком

---

**.example.env** пример переменных, которые используются в боте\
ENV переменные прокидываются через файл **.env**

# Установка гемов
```
make install
```

# Запуск redis, Sidekiq и Telegram бота
```
make run
```

# Остановить redis, Sidekiq и Telegram бота
```
make stop
```

# Открыть консоль с инициализированными объектами и гемами
```
make console
```

---

![alt text](telegram_answers.png)
