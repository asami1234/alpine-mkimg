build:
	docker build -t alpine-iso .

run:
	docker run -d --name iso alpine-iso

exec:
	docker exec -it iso sh
	
iso:
	docker build -t asami1234/alpine-mkimg:1.2 -f Dockerfile-iso .

push:
	docker push asami1234/alpine-mkimg:1.2