pipeline {
    agent any
    
    // Let user choose what to do
    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'What do you want to do? apply = Deploy app, destroy = Remove everything'
        )
    }
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = 'my-app'
        IMAGE_TAG = "${BUILD_NUMBER}"  // Unique tag for each build
        AWS_ACCOUNT_ID = '503499294473.dkr.ecr.us-east-1.amazonaws.com/my-app'
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
    }
    
    stages {
        // Step 1: Get the code from GitHub
        stage('Get Latest Code') {
            steps {
                git branch: 'main', url: 'https://github.com/your-org/your-repo.git'
            }
        }
        
        // Step 2: If user chose 'apply' - Deploy the app
        stage('Deploy Application') {
            when {
                expression { params.ACTION == 'apply' }
            }
            stages {
                
                // 2.1 Install dependencies and test
                stage('Install & Test Code') {
                    steps {
                        dir('app') {
                            sh 'npm install'  // Download required packages
                            sh 'npm test'     // Run tests
                        }
                    }
                }
                
                // 2.2 Create a Docker package
                stage('Package App in Docker') {
                    steps {
                        dir('app') {
                            sh "docker build -t ${ECR_REPO}:${IMAGE_TAG} ."
                        }
                    }
                }
                
                // 2.3 Upload Docker package to AWS
                stage('Upload to AWS Repository') {
                    steps {
                        withCredentials([
                            string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            sh """
                                # Login to AWS Docker repository
                                aws ecr get-login-password --region ${AWS_REGION} | \
                                docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                                
                                # Tag and upload the Docker package
                                docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
                                docker push ${ECR_URI}:${IMAGE_TAG}
                            """
                        }
                    }
                }
                
                // 2.4 Create AWS resources using Terraform
                stage('Create AWS Resources') {
                    steps {
                        dir('terraform') {
                            sh 'terraform init'  // Setup Terraform
                            sh "terraform plan -var='container_image=${ECR_URI}:${IMAGE_TAG}'"  // Preview changes
                            sh "terraform apply -auto-approve -var='container_image=${ECR_URI}:${IMAGE_TAG}'"  // Apply changes
                        }
                    }
                }
            }
        }
        
        // Step 3: If user chose 'destroy' - Remove everything
        stage('Remove Everything') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('terraform') {
                        sh 'terraform init'      // Setup Terraform
                        sh 'terraform destroy -auto-approve'  // Delete all resources
                    }
                }
            }
        }
    }
    
    // Cleanup and notifications
    post {
        always {
            cleanWs()  // Clean workspace regardless of success/failure
        }
        success {
            echo "SUCCESS: ${params.ACTION} completed without errors!"
        }
        failure {
            echo "FAILURE: ${params.ACTION} failed. Check the logs above for errors."
        }
    }
}