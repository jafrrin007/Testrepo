pipeline {
    agent any

    environment {
        DOCKER_DEV_REPO = "jafrrin007/dev"  // Dev Docker Hub repo
        DOCKER_PROD_REPO = "jafrrin007/prod" // Prod Docker Hub repo
        GIT_REPO = "https://github.com/jafrrin007/Testrepo.git"
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Clone the repo and set the BRANCH_NAME environment variable
                    git branch: 'dev', credentialsId: 'github-token', url: env.GIT_REPO
                    env.BRANCH_NAME = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Branch name: ${env.BRANCH_NAME}"  // Debugging output
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Capture commit hash
                    env.COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def IMAGE_TAG = "${env.DOCKER_DEV_REPO}:${env.COMMIT_HASH}"

                    // Building Docker image
                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_TAG} ${env.DOCKER_DEV_REPO}:latest"
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    // Logging into Docker Hub
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub (Dev)') {
            when { expression { env.BRANCH_NAME == 'dev' } }
            steps {
                script {
                    // Push to Dev Docker Hub
                    sh "docker push ${env.DOCKER_DEV_REPO}:latest"
                    sh "docker push ${env.DOCKER_DEV_REPO}:${env.COMMIT_HASH}"
                }
            }
        }

        stage('Push to Docker Hub (Prod)') {
            when { expression { env.BRANCH_NAME == 'master' } }
            steps {
                script {
                    echo "Pushing to production: ${env.BRANCH_NAME}"  // Debugging output
                    def IMAGE_TAG = "${env.DOCKER_PROD_REPO}:${env.COMMIT_HASH}"

                    // Build and push Docker image to production
                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_TAG} ${env.DOCKER_PROD_REPO}:latest"
                    sh "docker push ${env.DOCKER_PROD_REPO}:${env.COMMIT_HASH}"
                    sh "docker push ${env.DOCKER_PROD_REPO}:latest"
                }
            }
        }
    }

    post {
        always {
            // Cleanup Docker login and prune old images
            sh 'docker logout'
            sh 'docker image prune -f'
        }
    }
}
