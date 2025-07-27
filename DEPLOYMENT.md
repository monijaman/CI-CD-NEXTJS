# Next.js SSR CI/CD Pipeline with AWS

This guide walks you through setting up a complete CI/CD pipeline for your **server-side rendered (SSR)** Next.js application using AWS services.

## 🏗️ Architecture Overview

Since your Next.js app requires SSR, we need a server environment, not static hosting. Here are the recommended deployment options:

### **Option 1: AWS Elastic Beanstalk (Recommended)**

- **Best for**: Quick setup, managed environment
- **Benefits**: Auto-scaling, health monitoring, easy deployment
- **Cost**: Medium (pays for EC2 instances)

### **Option 2: AWS ECS with Fargate**

- **Best for**: Containerized deployments, production workloads
- **Benefits**: Serverless containers, better scaling control
- **Cost**: Medium to High

### **Option 3: AWS Lambda with Serverless Framework**

- **Best for**: Cost optimization, serverless architecture
- **Benefits**: Pay-per-request, automatic scaling
- **Cost**: Low to Medium

### **Option 4: EC2 with Docker**

- **Best for**: Full control, custom configurations
- **Benefits**: Maximum flexibility
- **Cost**: Variable

## 🚀 Option 1: AWS Elastic Beanstalk Deployment (Recommended)

### Prerequisites

- AWS Account with appropriate permissions
- GitHub repository with your Next.js SSR app
- Basic understanding of AWS services

### Step 1: Prepare Your Application

1. **Add Dockerfile** (create at project root):

```dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
```

2. **Add .dockerignore**:

```
node_modules
.next
.git
README.md
Dockerfile
.dockerignore
```

### Step 2: Create Elastic Beanstalk Application

1. Go to AWS Elastic Beanstalk Console
2. Click **Create Application**
3. Application name: `nextjs-ssr-app`
4. Platform: **Docker**
5. Platform version: Latest
6. Sample application: No
7. Click **Create application**

### Step 3: Set Up CodePipeline for Elastic Beanstalk

1. Go to AWS CodePipeline Console
2. Click **Create pipeline**
3. Pipeline name: `nextjs-ssr-pipeline`
4. Service role: Create new
5. Click **Next**

#### Source Stage:

- Source provider: **GitHub (Version 2)**
- Connect to GitHub
- Repository: `CI-CD-NEXTJS`
- Branch: `main`

#### Build Stage:

- Build provider: **AWS CodeBuild**
- Project name: **Create project**

### Step 4: Create CodeBuild Project

1. **Project name**: `nextjs-ssr-build`
2. **Environment**:
   - Environment image: Managed image
   - Operating system: Amazon Linux 2
   - Runtime: Standard
   - Image: `aws/codebuild/amazonlinux2-x86_64-standard:4.0`
3. **Buildspec**: Use buildspec file

#### Deploy Stage:

- Deploy provider: **AWS Elastic Beanstalk**
- Application name: Select your EB application
- Environment name: Select environment

## 🔧 SSR-Specific Configuration

### buildspec.yml for Elastic Beanstalk:

```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 18
      docker: 20
    commands:
      - echo Installing dependencies...

  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - echo Build started on `date`

  build:
    commands:
      - echo Build phase started on `date`
      - echo Building Docker image...
      - docker build -t nextjs-ssr .
      - docker tag nextjs-ssr:latest nextjs-ssr:$CODEBUILD_BUILD_NUMBER

artifacts:
  files:
    - "**/*"
  name: nextjs-ssr-$CODEBUILD_BUILD_NUMBER
```

### Environment Variables (in Elastic Beanstalk):

```
NODE_ENV=production
PORT=3000
```

## 🚀 Option 2: Serverless Deployment with AWS Lambda

For a serverless approach, you can use the Serverless Framework:

### Install Serverless Framework:

```bash
npm install -g serverless
npm install --save-dev serverless-nextjs-plugin
```

### Create serverless.yml:

```yaml
service: nextjs-ssr

provider:
  name: aws
  runtime: nodejs18.x
  region: us-east-1

plugins:
  - serverless-nextjs-plugin

custom:
  nextjs:
    memory: 512
    timeout: 30
```

### Deploy Command:

```bash
serverless deploy
```

## 🌐 Environment Management

### Development vs Production:

- **Development**: Use `npm run dev`
- **Production**: Use `npm run build && npm start`

### Environment Variables:

Add to your deployment environment:

```
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1
```

## 📊 Monitoring and Debugging

### Elastic Beanstalk Monitoring:

- CloudWatch logs automatically configured
- Health dashboard available
- Application metrics included

### Common SSR Issues:

1. **Memory issues**: Increase instance size or memory allocation
2. **Cold starts**: Use AWS Lambda provisioned concurrency
3. **Build failures**: Check Node.js version compatibility
4. **Runtime errors**: Check CloudWatch logs

## 🧪 Testing the Pipeline

1. Make a change to your Next.js SSR app
2. Commit and push to `main` branch
3. Watch the pipeline:
   - **Source**: Pulls latest code
   - **Build**: Creates Docker image or builds app
   - **Deploy**: Deploys to Elastic Beanstalk/Lambda

## 🔄 Advanced Configuration

### Auto Scaling (Elastic Beanstalk):

- Configure min/max instances
- Set CPU/memory thresholds
- Enable health checks

### Custom Domain:

- Use Route 53 for DNS
- Configure SSL/TLS certificates
- Set up CloudFront for CDN

### Database Integration:

- RDS for PostgreSQL/MySQL
- DynamoDB for NoSQL
- Environment-specific configurations

## 🧹 Cleanup

To avoid charges:

1. Delete CodePipeline
2. Delete CodeBuild project
3. Terminate Elastic Beanstalk environment
4. Delete application
5. Remove any associated resources

## 📚 Additional Resources

- [Next.js Deployment Documentation](https://nextjs.org/docs/deployment)
- [AWS Elastic Beanstalk Documentation](https://docs.aws.amazon.com/elasticbeanstalk/)
- [Serverless Next.js Plugin](https://github.com/serverless-nextjs/serverless-next.js)
