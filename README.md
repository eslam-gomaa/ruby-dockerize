
ALL the following will be repalced with the final design ...

### Usage

* Create docker volumes

```bash
docker volume create --name drkiq-postgres
docker volume create --name drkiq-redis
```

* Initialize the DB

```bash
docker-compose run drkiq rake db:reset
docker-compose run drkiq rake db:migrate
```

* build the app

```bash
docker-compose up
```


###  Test

```bash
curl http://localhost:8020
```

