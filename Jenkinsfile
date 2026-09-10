pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'nusradotnet'
        IMAGE_NAME      = 'jenkins-cicd-demo'
        CONTAINER_NAME  = 'web-app-prod'
        APP_PORT        = '8085'
        VERSION         = "v${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test Image') {
            steps {
                echo "Building application image version ${VERSION}..."
                sh "docker build --build-arg APP_VERSION=${VERSION} -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION} ."
                sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }

        stage('Rolling Deployment') {
            steps {
                echo "Performing rolling deployment to container ${CONTAINER_NAME}..."
                sh '''
                    PREV_IMAGE=$(docker inspect --format='{{.Image}}' ${CONTAINER_NAME} 2>/dev/null || echo "")
                    echo $PREV_IMAGE > prev_image.txt

                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:80 ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}
                '''
            }
        }

stage('Verify Deployment') {
    steps {
        echo "Verifying application availability..."
        sh '''
            sleep 3
            # Intentionally failing by hitting a port that does not exist
            curl -s -f http://host.docker.internal:9999 || exit 1
        '''
    }
}
    }

    post {
        failure {
            echo 'Deployment or verification failed! Initiating automatic Rollback...'
            sh '''
                echo "Executing rollback procedure..."
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                
                docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:80 ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest || true
                echo "Rollback successfully executed."
            '''
        }
        success {
            echo "Deployment of version ${VERSION} completed successfully!"
        }
    }
}
