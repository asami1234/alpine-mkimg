build:
	docker build -t test .

run:
	docker run --name test -d test

iso:
	docker build -t asami1234/alpine-mkimg:1.2 -f Dockerfile-iso .

push:
	docker push asami1234/alpine-mkimg:1.2