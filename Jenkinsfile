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
                sh "docker run -d mycode"
            }
        }
        stage('Rollback') {
            when {
                failure()
            }
            steps {
                script {
                    sh "docker stop ${CONTAINER_NAME}"
                    sh "docker rm ${CONTAINER_NAME}"
                    sh 'echo "Rollback complete"'
                }
            }
        }

    }
}
