pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'mycode-${BUILD_NUMBER}'
    }

    stages {
        stage('Clone') {
            steps {
                git url: "https://github.com/PoojaNagawade/my-task.git", branch: "main"
            }
            
        }
         stage("Build"){
            steps{
                sh "docker build -t ${DOCKER_IMAGE} ."
            
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
                sh "docker run -d ${DOCKER_IMAGE}"
            }
        }
    }
      
}
