# ECS Training

##### The repository contains example of containerized aplication deployment using `AWS ECS`

### Sample covers
- Deployment with `EC2` launch type
- Deployment with `FARGATE` launch type

### Sample does not cover
- `Blue/green` deployment technique
- Full `CloudFormation` automation

## Pre-deployment requirements
Create `ECR` repository:
`$ aws ecr create-repository --repository-name <your_repo>`

Setup environment variables:
- `AWS_ECR_PRODUCTION` - ECR repository URL
- `AWS_ECS_CLUSTER_REGION` - AWS region
- `AWS_EC2_KEYPAIR` - the keypair will be associated with instance (EC2 launch type)
- `APP_HOSTNAME` - the hostname will be used in NGINX configuration (EC2 launch type)

Build application image:
`$ docker-compose build flask`

Push Image to ECR repository:
`$ make ecr-push`

## ECS EC2 launch type
- Create `CloudWatch` logs group 
`$ aws logs create-log-group --log-group-name ECSTrainingEC2`
- Create `CloudFormation` stack via `$ make ecs-ec2-cluster`
- Create ECS Service `$ make ecs-ec2-service`
- Deploy application via `$ make ecs-ec2-deploy`

## ECS Fargate launch type
- Create `CloudWatch` logs group 
`$ aws logs create-log-group --log-group-name ECSTrainingFargate`
- Create `CloudFormation` stack via `$ make ecs-fg-cluster`. Command output should contain identifiers of created VPC and subnets
- Get default SG id `$ aws ec2 describe-security-groups --filter Name=vpc-id,Values=<vpc_id>`
- Update `deploy/fargate/ecs-params.yml` according to your identifiers
- Open `8000` port in default VPC SG via `$ aws ec2 authorize-security-group-ingress --group-id <sg-id> --protocol tcp --port 8000 --cidr 0.0.0.0/0`
- Create ECS Service `$ make ecs-fg-service`
- Deploy application via `$ make ecs-fg-deploy`
