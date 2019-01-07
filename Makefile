EC2_COMPOSE = compose -f deploy/ec2/docker-compose.yml --ecs-params deploy/ec2/ecs-params.yml \
	--region ${AWS_ECS_CLUSTER_REGION} --cluster AWSTrainingCluster --verbose

FARGATE_COMPOSE = compose -f deploy/fargate/docker-compose.yml --ecs-params deploy/fargate/ecs-params.yml \
	--region ${AWS_ECS_CLUSTER_REGION} --cluster AWSTrainingCluster --verbose

localserver:
	docker-compose up --build -d

ecs-ec2-cluster:
	ecs-cli up --verbose --launch-type EC2 --keypair ${AWS_EC2_KEYPAIR} \
	--instance-type t2.micro --region ${AWS_ECS_CLUSTER_REGION} --cluster AWSTrainingCluster \
	--extra-user-data ./deploy/ec2/cloud-config --instance-role aws-elasticbeanstalk-ec2-role

ecs-fg-cluster:
	ecs-cli up --launch-type FARGATE --verbose --region ${AWS_ECS_CLUSTER_REGION} \
	--cluster AWSTrainingCluster

ecs-ec2-service:
	ecs-cli $(EC2_COMPOSE) service create

ecs-fg-service:
	ecs-cli $(FARGATE_COMPOSE) service create --launch-type FARGATE

ecs-ec2-deploy:
	ecs-cli $(EC2_COMPOSE) service stop
	ecs-cli $(EC2_COMPOSE) service start

ecs-fg-deploy:
	ecs-cli $(FARGATE_COMPOSE) service stop
	ecs-cli $(FARGATE_COMPOSE) service start

ecr-push:
	docker tag flaskapp:latest ${AWS_ECR_PRODUCTION}
	ecs-cli push --region ${AWS_ECS_CLUSTER_REGION} ${AWS_ECR_PRODUCTION}
