build:
	docker build -t test .

run:
	docker run -d test

iso:
	docker build -t asami1234/alpine-mkimg:1.2 -f Dockerfile1 .

push:
	docker push asami1234/alpine-mkimg:1.2