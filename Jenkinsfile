pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jafrrin007/dev'
        PROD_DOCKER_IMAGE = 'jafrrin007/prod'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/jafrrin007/Test/jaff.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh './build.sh'
                }
            }
        }
        stage('Push to Docker Hub (Dev)') {
            steps {
                script {
                    sh 'docker tag react-app $DOCKER_IMAGE:latest'
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }
        stage('Push to Docker Hub (Prod)') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sh 'docker tag react-app $PROD_DOCKER_IMAGE:latest'
                    sh 'docker push $PROD_DOCKER_IMAGE:latest'
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
