pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-service-account-json') // Replace with your credential ID
        PROJECT_ID = "sylvan-hydra-464904-d9"
        REGION = "us-central1"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Praveenarumugam07/flask-cloudrun-cicd.git'
            }
        }

        stage('Install gcloud SDK (if needed)') {
            steps {
                sh '''#!/bin/bash
                if ! command -v gcloud &> /dev/null
                then
                    echo "Installing gcloud..."
                    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-453.0.0-linux-x86_64.tar.gz
                    tar -xzf google-cloud-sdk-453.0.0-linux-x86_64.tar.gz
                    ./google-cloud-sdk/install.sh -q
                fi
                . ./google-cloud-sdk/path.bash.inc
                '''
            }
        }

        stage('Authenticate with GCP') {
            steps {
                sh '''#!/bin/bash
                . ./google-cloud-sdk/path.bash.inc
                gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                gcloud config set project $PROJECT_ID
                '''
            }
        }

        stage('Trigger Cloud Build') {
            steps {
                sh '''#!/bin/bash
                . ./google-cloud-sdk/path.bash.inc
                gcloud builds submit --config cloudbuild.yaml .
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment completed successfully!'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
