pipeline {
    agent any

    environment {
        PROJECT_ID = 'sylvan-hydra-464904-d9'
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-service-account-json') // Jenkins Secret File credentials ID
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Praveenarumugam07/flask-cloudrun-cicd.git', branch: 'main'
            }
        }

        stage('Install gcloud SDK (if needed)') {
            steps {
                sh '''
                echo "Checking if gcloud is already installed..."
                if ! command -v gcloud &> /dev/null
                then
                    echo "Installing gcloud..."
                    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-453.0.0-linux-x86_64.tar.gz
                    tar -xzf google-cloud-sdk-453.0.0-linux-x86_64.tar.gz
                    ./google-cloud-sdk/install.sh -q
                fi

                echo "Adding gcloud to PATH..."
                export PATH=$PATH:$PWD/google-cloud-sdk/bin
                gcloud --version
                '''
            }
        }

        stage('Authenticate with GCP') {
            steps {
                sh '''
                echo "Authenticating with GCP..."
                export PATH=$PATH:$PWD/google-cloud-sdk/bin
                gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                gcloud config set project $PROJECT_ID
                '''
            }
        }

        stage('Trigger Cloud Build') {
            steps {
                sh '''
                echo "Triggering Cloud Build..."
                export PATH=$PATH:$PWD/google-cloud-sdk/bin
                gcloud builds submit --project=$PROJECT_ID
                '''
            }
        }

    }

    post {
        success {
            echo "✅ Deployment succeeded."
        }
        failure {
            echo "❌ Deployment failed."
        }
    }
}
