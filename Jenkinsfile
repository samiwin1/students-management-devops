pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "samiwin1/students-management:latest"
        DOCKER_CREDS = "samiwin-dockerhub"
    }

    stages {

        stage('Checkout GitHub') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token',
                    url: 'https://github.com/samiwin1/students-management-devops.git'
            }
        }

        stage('Build Spring Boot') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: DOCKER_CREDS,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([
                    file(credentialsId: 'my_kubernetes', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG
                        kubectl apply -f k8s/mysql-deployment.yaml
                        kubectl apply -f k8s/spring-deployment.yaml
                        kubectl get pods
                    '''
                }
            }
        }
    }
}
