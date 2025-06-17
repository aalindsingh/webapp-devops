run-local:
	cd app && docker build -t flask-docker-app . && docker run -p 5000:5000 flask-docker-app

clean:
	docker ps -aq | xargs -r docker stop | xargs -r docker rm -f 
	docker rmi -f flask-docker-app

AWS_REGION=us-east-1
ACCOUNT_ID=571600835023
REPO_NAME=flask-webapp
TAG=latest

ecr-login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

ecr-push: ecr-login
	docker tag flask-docker-app:latest $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(REPO_NAME):$(TAG)
	docker push $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(REPO_NAME):$(TAG)
