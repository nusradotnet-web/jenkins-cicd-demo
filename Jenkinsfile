pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'nusradotnet'
        IMAGE_NAME      = 'jenkins-cicd-demo'
        BUILD_TAG       = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh 'test -f Dockerfile'
                sh 'test -f deploy.sh'
            }
        }

        stage('Docker Package') {
            steps {
                sh "docker build --build-arg VERSION=${BUILD_TAG} -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_TAG} ."
                sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_TAG} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }

        stage('Rolling Deploy') {
            steps {
                sh "./deploy.sh ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_TAG}"
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed. Executing automatic rollback cleanup...'
            sh 'docker rename web-app-old web-app-live 2>/dev/null || true'
        }
    }
}
