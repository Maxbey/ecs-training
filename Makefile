ECS_COMPOSE = compose -f deploy/compose.yml --ecs-params deploy/ecs-params.yml \
	--region ${AWS_ECS_CLUSTER_REGION} --cluster AWSTrainingCluster --verbose

localserver:
	docker-compose up --build -d

ecs-ec2-cluster:
	ecs-cli up --verbose --launch-type EC2 --keypair ${AWS_EC2_KEYPAIR} \
	--instance-type t2.micro --region ${AWS_ECS_CLUSTER_REGION} --cluster AWSTrainingCluster \
	--extra-user-data ./deploy/cloud-config --instance-role aws-elasticbeanstalk-ec2-role

ecs-fg-cluster:
	ecs-cli up --launch-type FARGATE --verbose --region ${AWS_ECS_CLUSTER_REGION} \
	--cluster AWSTrainingCluster --extra-user-data ./deploy/cloud-config

ecs-create-service:
	ecs-cli $(ECS_COMPOSE) service create

ecs-deploy:
	ecs-cli $(ECS_COMPOSE) service stop
	ecs-cli $(ECS_COMPOSE) service start

ecr-push:
	docker tag flaskapp:latest ${AWS_ECR_PRODUCTION}
	ecs-cli push --region ${AWS_ECS_CLUSTER_REGION} ${AWS_ECR_PRODUCTION}
