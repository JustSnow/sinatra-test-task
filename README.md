sinatra-test-task
=================

Для запуска необходимо:
- `bundle`
- создать `config/database.yml`, пример в `config/database.sample.yml`
- `rake db:setup`
- `shotgun`
- `http://127.0.0.1:9393/`

Для импорта бд нужно:
- убедиться что база создана. если нет, то `rake db:create`
- `pg_restore -h localhost -U user_name -d test_404_development path/to/dump_file`
- можно скачать готовый дамп [Dropbox Dump]

Запросы
---

Главная страница с фильтрами, заполнены все варианты фильтра

```sh
Student Load (868.0ms)
  SELECT  "students".* FROM "students"
  WHERE "students"."student_group_id" = 2
  AND ("students"."average_ball" BETWEEN '1' AND '3')
  AND (name ILIKE '%Daphney%') AND "students"."number_of_semester" = 2
  AND (student_ip ILIKE '%187.138.67%') AND ("students"."characteristic" IS NOT NULL)
  ORDER BY "students"."id" DESC LIMIT 50 OFFSET 0
```

Top 10
```sh
Student Load (2.2ms)
  SELECT  "students".* FROM "students"
  ORDER BY "students"."average_ball" DESC LIMIT 10
```

Однокурсники со средним баллом от .. до .., и именем %name%
```sh
Student Load (578.9ms)
  SELECT  "students".* FROM "students"
  WHERE "students"."student_group_id" = 2
  AND ("students"."average_ball" BETWEEN '1' AND '5')
  AND (name ILIKE '%Daphney%')
  ORDER BY "students"."id" DESC LIMIT 50 OFFSET 0
```

Всех людей, c IP которых произошло более одной регистрации, и при этом хотя бы
у одного из них должна быть написана характеристика научного руководителя
```sh
Student Load (740.9ms)
  SELECT  "students".* FROM "students"
  WHERE (student_ip ILIKE '%187.138.67.129%')
  AND ("students"."characteristic" IS NOT NULL)
  ORDER BY "students"."id" DESC LIMIT 50 OFFSET 0
```

[Dropbox Dump]:https://www.dropbox.com/s/wej7yoi0gitxcog/test_404_development.tar.gz?dl=0
