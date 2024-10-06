pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/mayur11052000/FullStack-Blogging-App.git'
            }
        }
        
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('test') {
            steps {
                sh "mvn test -DskipTests=true"
            }
        }
        
        stage('trivy fs scan') {
            steps {
                sh " trivy fs --format table -o fs.html ."
            }
        }
        
        
        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Mayur -Dsonar.projectName=mayur -Dsonar.java.binaries=. '''

                }
            }
        }
        
        stage('SonarQube quality gate') {
            steps {
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-cred'
                }
            }
        }
        
        stage('package') {
            steps {
                sh "mvn package -DskipTests=true"
            }
        }
        
        stage('docker build image') {
            steps {
                sh "docker build -t blog ."
            }
        }
        
        stage('docker image scan') {
            steps {
                sh "trivy image --format table -o trivy.fs-report.html blog"
            }
        }
        
        stage('docker tag and push image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker tag blog mayur11052000/blog"
                        sh "docker push mayur11052000/blog"
                    }
                }
            }
        }
        
        stage('k8s deploy') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'mayur-cluster', contextName: '', credentialsId: 'k8stoken', namespace: '', restrictKubeConfigAccess: false, serverUrl: 'https://189DC67E76E115E6A4CE1634362494BF.sk1.ap-south-1.eks.amazonaws.com') {
                    sh "kubectl apply -f deployment-service.yml -n webapps"
                    sh "kubectl get svc -n webapps"
                }
            }
        }

        
    }
}
