
pipeline {
    agent any

    // When triggering this pipeline, choose one action:
    //   apply   → Build, push, and deploy the app
    //   destroy → Tear down all AWS resources
    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'apply = deploy the app | destroy = remove everything'
        )
    }

    // Shared Variables
    environment {
        AWS_REGION     = 'us-east-1'
        AWS_ACCOUNT_ID = '503499294473'
        ECR_REPO       = 'my-app'
        IMAGE_TAG      = "${BUILD_NUMBER}"   // Unique per build (e.g. "42")

        // Full ECR image address, e.g.: 503499294473.dkr.ecr.us-east-1.amazonaws.com/my-app
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
    }

    stages {

        // Stage 1: Get the Source Code
        stage('Checkout code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/kingsleychino/simple-webapp-nodejs.git'
            }
        }

        // Stage 2: Deploy (only when ACTION = apply)
        stage('Deploy application') {
            when {
                expression { params.ACTION == 'apply' }
            }
            stages {

                // Step 2a – Build a Docker image from the /app folder
                stage('Build Docker image') {
                    steps {
                        dir('app') {
                            sh "docker build -t ${ECR_REPO}:${IMAGE_TAG} ."
                        }
                    }
                }

                // Step 2b – Push the image to Amazon ECR (private registry)
                stage('Push image to AWS ECR') {
                    steps {
                        withCredentials([
                            string(credentialsId: 'aws-access-key-id',     variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            sh """
                                # Authenticate Docker with ECR
                                aws ecr get-login-password --region ${AWS_REGION} \
                                  | docker login --username AWS --password-stdin \
                                    ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

                                # Tag the image with the full ECR path, then push it
                                docker tag  ${ECR_REPO}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
                                docker push ${ECR_URI}:${IMAGE_TAG}
                            """
                        }
                    }
                }

                // Step 2c – Create/update AWS infrastructure with Terraform
                stage('Deploy infrastructure via Terraform') {
                    steps {
                        dir('app/terraform/website') {
                            sh 'pwd'        // show current directory
                            sh 'ls -la'     // list everything in the folder
                            sh 'terraform init'
                            sh "terraform plan -var='container_image=${ECR_URI}:${IMAGE_TAG}'"
                            sh "terraform apply -auto-approve -var='container_image=${ECR_URI}:${IMAGE_TAG}'"
                        }
                    }
                }

            }
        }

        // Stage 3: Destroy (only when ACTION = destroy)
        stage('Tear down infrastructure') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id',     variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('app/terraform/website') {
                        sh 'terraform init'
                        sh "terraform destroy -auto-approve -var='container_image=none'"
                    }
                }
            }
        }

    }

    // Post-run Notifications
    post {
        always  { cleanWs() }   // Always clean the workspace, even on failure
        success { echo "'${params.ACTION}' finished successfully." }
        failure { echo "'${params.ACTION}' failed — check the logs above." }
    }
}