#Jenkins trigger
pipeline {
    agent any
    environment {
        BRANCH_NAME = "${env.GIT_BRANCH}".replaceFirst("origin/", "") // Ensure correct branch detection
    }
    stages {
        stage('Build') {
            steps {
                sh './build.sh'
            }
        }
        stage('Push to Dev') {
            when {
                expression { BRANCH_NAME == 'dev' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"'
                    sh 'docker tag devops-build-web:latest jafrrin007/dev:latest'
                    sh 'docker push jafrrin007/dev:latest'
                }
            }
        }
        stage('Push to Prod') {
            when {
                expression { BRANCH_NAME == 'master' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"'
                    sh 'docker tag devops-build-web:latest jafrrin007/prod:latest'
                    sh 'docker push jafrrin007/prod:latest'
                }
            }
        }
        stage('Deploy') {
            when {
                expression { BRANCH_NAME == 'master' }
            }
            steps {
                sh './deploy.sh'
            }
        }
    }
}
