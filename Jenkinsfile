pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'mycode:${BUILD_NUMBER}'
        CONTAINER_NAME = 'mycode'
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
        stage("Docker Build Push: DockerHub"){
            steps{
              withCredentials([usernamePassword(credentialsId:"Docker",passwordVariable:"dockerhubpass",usernameVariable:"dockerhubname")]){
                  sh "docker logout"
                  sh "docker login -u ${env.dockerhubname} -p ${env.dockerhubpass}"
                }
            }
        }
        stage("Docker Tag"){
            steps{
                sh "docker tag mycode:latest poojanagawade/my_task:mycode"
            }
        }
        stage("Code Push to DockerHub"){
            steps{
                sh "docker push poojanagawade/my_task:mycode"
            }
        }
        stage("deploy"){
            steps{
                sh "docker run -d mycode"
            }
        }
    }
      
}
