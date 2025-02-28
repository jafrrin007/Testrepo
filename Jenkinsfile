pipeline {
    agent any
    environment {
        BRANCH_NAME = "${env.GIT_BRANCH}".replaceFirst("origin/", "")
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
                // ... (your Push to Dev logic)
            }
        }
        stage('Push to Prod') {
            when {
                expression { BRANCH_NAME == 'master' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                    sh 'docker tag react-app-web:latest jafrrin007/prod:latest'
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
