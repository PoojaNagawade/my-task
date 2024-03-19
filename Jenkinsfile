pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'myapp:${BUILD_NUMBER}'
        CONTAINER_NAME = 'myapp-container'
    }

    stages {
        stage('Clone') {
            steps {
                git url: "https://github.com/PoojaNagawade/my-task.git", branch: "main"
            }
            
        }
         stage("build"){
            steps{
                sh "docker build -t mycode ."
            
            }
        }
        stage("deploy"){
            steps{
                sh "docker run -d mycode1"
            }
        }
    }
      post {
            failure {
                echo 'Deployment failed! Initiating rollback...'
                sh "docker stop ${CONTAINER_NAME}"
                sh "docker rm ${CONTAINER_NAME}"
                sh "docker run -d --name ${CONTAINER_NAME} myapp:${buildPreviousTag}"
                echo 'Rollback complete.'
            }
      }   
}
