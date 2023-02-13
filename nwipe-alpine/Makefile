build:
	docker build -t nwipe-alpine .

run:
	docker run -d --name nwipe nwipe-alpine

exec:
	docker exec -it nwipe sh

copy:
	docker cp nwipe:/usr/local/bin/nwipe .