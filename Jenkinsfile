pipeline {
    agent any

    // Specify tools required by the pipeline
    tools {
        maven 'Maven3.9.9'  // Reference the Maven installation configured in Jenkins
    }

    // Set environment variables
    environment {
        // Replace 'your-dockerhub-username' with your actual Docker Hub username
        DOCKER_IMAGE = 'edwardokoto1/e-commerce-website'
    }

    stages {
        // Stage 1: Check-out code from GitHub
        stage('Checkout Code') {
            steps {
                echo 'Cloning repository from GitHub...'
                git branch: 'main', url: 'https://github.com/Edward-okoto/e-commerce-website.git'
            }
        }
        
        // Stage 2: Build your Maven project
        stage('Build Maven Project') {
            steps {
                echo 'Running Maven build...'
                // This command cleans, compiles, and packages the application
                sh 'mvn clean package'
            }
        }
        
        // Stage 3: Run tests (if any exist)
        stage('Run Tests') {
            steps {
                echo 'Running Maven tests...'
                sh 'mvn test'
            }
        }
        
        // Stage 4: Build the Docker image
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                // Build the image using the Dockerfile in the project root
                sh "docker build -t ${DOCKER_IMAGE}:latest ."
            }
        }
        
        // Stage 5: Push the Docker image to Docker Hub
        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                // Use saved Docker Hub credentials
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials',
                                                  usernameVariable: 'DOCKER_USERNAME',
                                                  passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh """
                        echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin
                        docker push ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
    }
    
    // Post actions (notifications, cleanup, etc.)
    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline execution failed. Please check the logs.'
        }
    }
}
