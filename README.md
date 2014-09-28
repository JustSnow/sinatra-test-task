sinatra-test-task
=================

Для запуска необходимо:
- `bundle`
- создать `config/database.yml`, привер в `config/database.sample.yml`
- `rake db:setup`
- `shotgun`
- `http://127.0.0.1:9393/`

Для импорта бд нужно:
- убедиться что база создана. если нет, то `rake db:create`
- `pg_restore -h localhost -U user_name -d test_404_development path/to/dump_file`
- дамп готовой бд с 1000000 студентов лежит `config/test_404_development_dump.sql`
