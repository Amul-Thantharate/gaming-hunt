def COLOR_MAP = [
    'FAILURE' : 'danger',
    'SUCCESS' : 'good'
]

pipeline{
    agent any 
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=gaming-hunt-12 \
                    -Dsonar.projectKey=gaming-hunt-12'''
                }
            }
        }
        stage("quality gate"){
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-text'
                }
            }
        }
        stage("Install Npm Dependencies"){
            steps{
                sh "npm install"
            }
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Docker Scout FS') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                        sh 'docker-scout quickview fs://.'
                        sh 'docker-scout cves fs://.'
                    }
                }
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                        sh 'docker build -t gaming-hunt .'
                        sh 'docker tag gaming-hunt:latest amuldark/gaming-hunt:latest'
                        sh 'docker push amuldark/gaming-hunt:latest'
                }
                }
            }
        }
        stage('Docker Scout Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                        sh 'docker-scout cves amuldark/gaming-hunt:latest'
                        sh 'docker-scout recommendations amuldark/gaming-hunt:latest'
                    }
                }
            }
        }

    }
    post {
    always {
        echo 'Slack Notifications'
        slackSend (
            channel: '#jenkins',   
            color: COLOR_MAP[currentBuild.currentResult],
            message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} \n build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        )
    }
}
}