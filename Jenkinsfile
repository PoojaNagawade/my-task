pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'mycode-${BUILD_NUMBER}'
        CONTAINER_NAME='myapp-${BUILD_NUMBER}'
        SONAR_HOME= tool "Sonar"
    }

    stages {
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Clone') {
            steps {
                git url: "https://github.com/PoojaNagawade/my-task.git", branch: "main"
            }
            
        }
        stage("SonarQube Analysis"){
            steps{
                withSonarQubeEnv("Sonar"){
                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=nodetodo -Dsonar.projectKey=nodetodo"
                }
            }
        }
        
        stage("SonarQube Quality Gates"){
                steps{
                    timeout(time: 1, unit: "MINUTES"){
                        waitForQualityGate abortPipeline: false
                    }
                }
        }
        
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'dc'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
         stage("Build"){
            steps{
                sh "docker build -t ${DOCKER_IMAGE} ."
            
            }
        }
         stage("Docker Code Scan: Trivy"){
            steps{
                sh "trivy image ${DOCKER_IMAGE}"
            }
        }
        stage("Docker Build Push: DockerHub"){
            steps{
              withCredentials([usernamePassword(credentialsId:"Docker",passwordVariable:"dockerhubpass",usernameVariable:"dockerhubname")]){
                  sh "docker logout"
                  sh "docker login -u ${env.dockerhubname} -p ${env.dockerhubpass}"
                  sh "docker tag ${DOCKER_IMAGE} poojanagawade/my_task:${DOCKER_IMAGE}"
                  sh "docker push poojanagawade/my_task:${DOCKER_IMAGE}"
                }
            }
        }
        stage("Deploy"){
            steps{
                sh "docker run -d --name ${CONTAINER_NAME} ${DOCKER_IMAGE}"
            }
        }  
    }

}
