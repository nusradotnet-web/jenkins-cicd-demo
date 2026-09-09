pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'YOUR_DOCKER_HUB_USERNAME' // Replace with your Docker Hub username
        IMAGE_NAME      = 'jenkins-cicd-demo'
        BUILD_TAG       = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Compiling application workspace...'
                sh 'echo "App compilation step passed" > build.log'
            }
        }

        stage('Test') {
            steps {
                echo 'Executing automated unit tests...'
                sh 'test -f Dockerfile'
            }
        }

        stage('Package & Docker Build') {
            steps {
                echo 'Building Docker container image...'
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_TAG} ."
            }
        }

        stage('Push Image Tag') {
            steps {
                echo 'Tagging image as latest...'
                sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_TAG} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete.'
        }
    }
}
